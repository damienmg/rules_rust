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
"""Utilities to generate a Bazel BUILD file."""

from cargo_licenses import license_type

class BazelBuildFile:
    """A Helper class to generate a Bazel BUILD file."""
    def __init__(self):
        self.header = []
        self.lines = []
        self.header = ["package(default_visibility=[\"//visibility:public\"])", ""]
        self.bazel_rule(
            "load",
            "@io_bazel_rules_rust//rust:rust.bzl",
            "rust_library",
            "rust_binary")
        self.bazel_rule(
            "load",
            "@io_bazel_rules_rust//cargo:crate_repository.bzl",
            "cargo_build_script_run")

    def __str__(self):
        return "\n".join(self.header + self.lines)

    def licenses(self, licenses):
        self.header.append("licenses([")
        for license in licenses.split("/"):
            self.header.append("    \"%s\",  # \"%s\"" %
                               (license_type(license), license))
        self.header.append("])")
        self.header.append("")

    def bazel_rule(self, rule, *args, **kwargs):
        self.lines.append(rule + "(")
        for a in args:
            self.lines.append("    %s, " % repr(a))
        for k, v in kwargs.items():
            if v or v is False:
                self.lines.append("    %s = %s, " % (k, repr(v)))
        self.lines.append(")")
        self.lines.append("")

    def rust_library(self, **kwargs):
        self.bazel_rule("rust_library", **kwargs)

    def rust_binary(self, **kwargs):
        self.bazel_rule("rust_binary", **kwargs)

    def cargo_build_script_run(self, **kwargs):
        self.bazel_rule("cargo_build_script_run", **kwargs)

    def alias(self, name, actual):
        self.bazel_rule("alias", name=name, actual=actual)

    def comment(self, text):
        self.lines.append("# %s" % text)
        self.lines.append("")

class glob:
    def __init__(self, *args, **kwargs):
        self.representation = "glob("
        for a in args:
            self.representation += "%s, " % repr(a)
        for k, v in kwargs.items():
            if v or v is False:
                self.representation += "%s = %s, " % (k, repr(v))
        self.representation += ")"

    def __repr__(self):
        return self.representation
