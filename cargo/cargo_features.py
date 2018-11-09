# Copyright 2018 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""Utilities to manipulate features declares in a Cargo.toml file."""


class Feature:
    def __init__(self, name, json_value=[], json_features={}):
        # Name is an ordered list of activated features
        self.name = name if type(name) == list else [name.encode("UTF-8")]
        # Deps are all object that are not features.
        # TODO(damieng): propagate feature deps (e.g. foo/bar that activate feature bar in dep foo)
        self.deps = set(
            [l.encode("UTF-8") for l in json_value if l not in json_features])
        self.features = set(self.name +
            [l.encode("UTF-8") for l in json_value if l in json_features])

    def __eq__(self, other):
        if isinstance(other, self.__class__):
            return self.name == other.name and self.deps == other.deps and self.features == other.features
        else:
            return False

    def __ne__(self, other):
        return not self.__eq__(other)

    def __repr__(self):
        return "Feature(name=%s, deps=%s, features=%s)" % (self.key(), self.deps, self.features)

    def key(self):
        return "+".join(self.name)

    def expand_deps(self, features):
        copy = Feature(self.name)
        copy.deps = self.deps.union(set([
            d for f in self.features for d in features[f].deps
        ]))
        copy.features = self.features.union(set([
            d for f in self.features for d in features[f].features
        ]))
        return copy

    def __add__(self, other):
        if not isinstance(other, self.__class__):
            raise ValueError("Can only add a Feature with another Feature")
        copy = Feature(sorted(set(self.name + other.name)))
        copy.deps = self.deps.union(other.deps)
        copy.features = self.features.union(other.features)
        return copy


class FeatureGraph:
    """Features are forming a graph and can be combined.

    This class tries to flatten the Graph into a list of possible feature combination.
    """

    def __init__(self, features):
        # Do not use, use from_json
        self.features = {k: v for k, v in features.iteritems()}

    @classmethod
    def from_json(cls, json_features):
        features = [
            Feature(k, v, json_features) for k, v in json_features.items()
        ]
        features = {f.key(): f for f in features}
        if not "default" in json_features:
            features["default"] = Feature(["default"])
        return cls(features)

    def filter_on_available_deps(self, deps):
        """Remove features depending on a non available dependency."""
        self.features = {
            k: v
            for k, v in self.features.items()
            if all(d.split("/", 1)[0] in deps for d in v.deps)
        }

    def fixed_point(self, fn):
        n = fn(self.features)
        while n != self.features:
            self.features = n
            n = fn(self.features)

    def remove_features_with_missing_features(self):
        """Remove all features that transitively depends on a missing feature."""
        self.fixed_point(
            lambda feat: {
                k: v
                for k, v in feat.items()
                if all(d in feat for d in v.features)
            })

    def flatten(self):
        """Expand the transitive dependencies and features."""
        self.fixed_point(lambda feat: {k: v.expand_deps(feat) for k, v in feat.iteritems()})

    def append(self, feature):
        key = feature.key()
        if key not in self.features:
            self.features[key] = feature

    def extend(self, feature):
        # Copy the iterable so we don't have concurrent modification issues.
        items = [(k,v) for k, v in self.features.iteritems()]
        for k, v in items:
            # Append already check for not overwriting existing feature
            self.append(v + feature)

    def __mul__(self, other):
        if isinstance(other, self.__class__):
            # Factorial complexity!
            result = FeatureGraph(self.features)
            items = other.features.values()
            for f in items:
                result.extend(f)
            return result
        elif isinstance(other, Feature):
            result = FeatureGraph(self.features)
            result.extend(other)
            return result
        else:
            raise ValueError("Can only multiply a FeatureGraph with another FeatureGraph or a Feature")

    def generate_combination(self, features):
        r = Feature("")
        for f in features:
            if f not in self.features:
                return None
            r += self.features[f]
        return r

    def generate_combinations(self, groups=None):
        """Generate all possible feature combinations."""
        result = None
        if groups is not None:
            # We have the list of feature combinations we need.
            result = FeatureGraph(self.features)
            for f in groups:
                if f not in result.features:
                    add = self.generate_combination(f.split("+"))
                    if add:
                        result.features[f] = add
        elif len(self.features) < 8:
            # If we have less than 8 features we can generate all the combinaison (5040).
            result = self * self
        else:
            # We have too many features, the number of combinaisons is n! where n is the
            # number of features. We cannot generate that many combinaisons.
            # Instead we just generate the feature with default.
            # Ideally we would generate just the combination of feature used but that would
            # require to know all the resolved graph and would make the crate too specific
            # to one resolution graph.
            # TODO(damienmg): once feature flags are available from Skylark, use them rather
            # than generating all the targets
            if "default" in self.features:
                result = self * self.features["default"]
            else:
                result = FeatureGraph(self.features)
        # Add the empty feature set
        if "" not in result.features:
            result.features[""] = Feature([])
        return result

    def resolve(self, resolved_deps, groups=None):
        """Resolve the current object into the actual list of possible feature combinations."""
        copy = FeatureGraph(self.features)
        copy.flatten()
        copy.filter_on_available_deps(resolved_deps)
        copy.remove_features_with_missing_features()
        return copy.generate_combinations(groups)

    def forall(self, fn):
        for k, v in self.features.iteritems():
            # TODO(damienmg): take care of dependencies
            fn(k, sorted(v.features))

    def has(self, feat):
        return feat in self.features