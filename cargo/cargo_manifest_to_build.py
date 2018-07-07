#!/usr/bin/env python
import sys
import json as _json
import subprocess
import argparse
import StringIO

sys.dont_write_bytecode = True

from bazel_rust_helper import BazelBuildFile, glob

parser = argparse.ArgumentParser()
parser.add_argument(
    'dep', nargs='*', help='List of dep_name=dep_version resolved versions')
parser.add_argument('--data', required=False, help='Content of the data file')
parser.add_argument(
    '--flag',
    action='append',
    default=[],
    help='Extra arguments for compilation')
parser.add_argument(
    '--output',
    type=argparse.FileType('w'),
    default=sys.stdout,
    help='output file')
parser.add_argument(
    '--additional_dep',
    action='append',
    default=[],
    help='Extra dependency for compilation')
parser.add_argument(
    '--manifest_path', default='Cargo.toml', help='Path to Cargo.toml')


def rule_name(name):
    return name.encode("UTF-8").replace("-", "_")


class CargoTomlContext:
    """Utility to convert Cargo.toml file to a BUILD file."""

    def __init__(self, args, json=None):
        """Take command line arguments and load the Cargo.toml file."""
        json = json if json else _json.load(
            StringIO.StringIO(
                subprocess.check_output([
                    "cargo", "metadata", "--no-deps", "--manifest-path",
                    args.manifest_path, "--format-version", "1"
                ])))
        self.json = json
        self.workspace_root = json["workspace_root"].encode("UTF-8")
        self.resolved_deps = {
            v.split("=", 1)[0]: v.split("=", 1)[1]
            for v in args.dep
        }
        self.additional_deps = [d.encode("UTF-8") for d in args.additional_dep]
        self.flags = [d.encode("UTF-8") for d in (args.flag or [])]
        out_dir_tar = ""
        self.extra = {}
        self.package = json["packages"][0]
        if any(t["kind"] == ["custom-build"] for t in self.package["targets"]):
            self.extra[
                "out_dir_tar"] = ":%s_build_script_executor" % self.package[
                    "name"].encode("UTF-8").replace("-", "_")
        if args.data:
            self.extra["data"] = args.data
        for d in self.package["dependencies"]:
            if d["name"] not in self.resolved_deps and not d["optional"] and not d["kind"]:
                sys.stderr.write(
                    "WARNING: Cannot resolve required dependency on crate '%s'\n"
                    % d["name"])
        self.name = self.package["name"].encode("UTF-8")
        self.version = self.package["version"].encode("UTF-8")
        self.deps = self.resolve_deps(
            [d for d in self.package["dependencies"]
             if not d["kind"]]) + self.additional_deps
        self.build_deps = self.resolve_deps(
            [d for d in self.package["dependencies"] if d["kind"] == "build"])
        # TODO(damienmg): features


    def resolve_deps(self, deps):
        return [
            self.resolved_deps[d["name"]].encode("UTF-8") for d in deps
            if d["name"] in self.resolved_deps
            and self.resolved_deps[d["name"]]
        ]

    def remove_workspace_prefix(self, path):
        res = path[len(self.workspace_root):] if path.startswith(
            self.workspace_root) else path
        return res[1:] if res.startswith("/") else res

    def library(self, target):
        name = rule_name(target["name"])
        self.build_file.rust_library(
            name=name,
            crate_root=self.remove_workspace_prefix(target["src_path"].encode("UTF-8")),
            crate_type=target["crate_types"][0].encode("UTF-8"),
            srcs=glob(["**/*.rs"]),
            deps=self.deps,
            rustc_flags=["--cap-lints allow"] + self.flags,
            version=self.version,
            # TODO(damienmg): crate_features=features,
            **self.extra)


    def binary(self, target):
        name = rule_name(target["name"])
        bin_name = rule_name(target["name"] + "_bin")
        self.build_file.rust_binary(
            name=bin_name,
            crate_root=self.remove_workspace_prefix(target["src_path"].encode("UTF-8")),
            srcs=glob(["**/*.rs"]),
            deps=[":" + name] + self.deps,
            rustc_flags=["--cap-lints allow"] + self.flags,
            version=self.version,
            # TODO(damienmg): crate_features=features,
            **self.extra)

    def build_script(self, target):
        name = rule_name(self.name)
        self.build_file.rust_binary(
            name=name + "_build_script",
            crate_root=self.remove_workspace_prefix(target["src_path"].encode("UTF-8")
                                        or "build.rs"),
            srcs=glob(["**/*.rs"]),
            deps=self.build_deps,
            rustc_flags=["--cap-lints allow"],
            # TODO(damienmg): crate_features=features,
            version=self.version)
        self.build_file.cargo_build_script_run(
            name=name + "_build_script_executor",
            srcs=glob(["*", "**/*.rs"]),
            # TODO(damienmg): crate_features=features,
            script=":%s_build_script" % name)

    def to_build_file(self):
        self.build_file = BazelBuildFile()
        json = self.package
        if "license" in json and json["license"]:
            self.build_file.licenses(json["license"])
        aliased = False
        for target in json["targets"]:
            if target["kind"][0] in ["lib", "proc-macro", "dylib", "rlib"]:
                if target["name"] == self.name:
                    aliased = True
                elif not aliased:
                    aliased = target["name"].encode("UTF-8")
                self.library(target)
            elif target["kind"][0] == "bin":
                self.binary(target)
            elif target["kind"][0] == "custom-build":
                self.build_script(target)
            else:
                self.build_file.comment(
                    "Unsupported target %s with type %s omitted" %
                    (target["name"], target["kind"][0]))
        if aliased and aliased is not True:
            self.build_file.alias(context["name"].replace("-", "_"), aliased)
        return str(self.build_file)

if __name__ == "__main__":
    args = parser.parse_args()
    context = CargoTomlContext(args)
    args.output.write(context.to_build_file())
    args.output.close()