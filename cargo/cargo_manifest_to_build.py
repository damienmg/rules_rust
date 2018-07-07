#!/usr/bin/env python
import sys
import json
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


def remove_path_prefix(s, prefix):
    res = s[len(prefix):] if s.startswith(prefix) else s
    return res[1:] if res.startswith("/") else res


def rust_library_from_context(target, context):
    name = rule_name(target["name"])
    context["build_file"].rust_library(
        name=name,
        crate_root=remove_path_prefix(target["src_path"].encode("UTF-8"),
                                      context["workspace_root"]),
        crate_type=target["crate_types"][0].encode("UTF-8"),
        srcs=glob(["**/*.rs"]),
        deps=context["deps"],
        rustc_flags=["--cap-lints allow"] + context["flags"],
        version=context["version"],
        # TODO(damienmg): crate_features=features,
        **context["extra"])


def rust_binary_from_context(target, context):
    name = rule_name(target["name"])
    bin_name = rule_name(target["name"] + "_bin")
    context["build_file"].rust_binary(
        name=bin_name,
        crate_root=remove_path_prefix(target["src_path"].encode("UTF-8"),
                                      context["workspace_root"]),
        srcs=glob(["**/*.rs"]),
        deps=[":" + name] + context["deps"],
        rustc_flags=["--cap-lints allow"] + context["flags"],
        version=context["version"],
        # TODO(damienmg): crate_features=features,
        **context["extra"])


def custom_build_script_from_context(target, context):
    name = rule_name(context["name"])
    context["build_file"].rust_binary(
        name=name + "_build_script",
        crate_root=remove_path_prefix(target["src_path"].encode("UTF-8") or
                                      "build.rs", context["workspace_root"]),
        srcs=glob(["**/*.rs"]),
        deps=context["build_deps"],
        rustc_flags=["--cap-lints allow"],
        # TODO(damienmg): crate_features=features,
        version=context["version"])
    context["build_file"].cargo_build_script_run(
        name=name + "_build_script_executor",
        srcs=glob(["*", "**/*.rs"]),
        # TODO(damienmg): crate_features=features,
        script=":%s_build_script" % name)


def resolve_deps(deps, ctxt):
    return [
        ctxt["resolved_deps"][d["name"]].encode("UTF-8") for d in deps
        if d["name"] in ctxt["resolved_deps"]
        and ctxt["resolved_deps"][d["name"]]
    ]


def extend_context(ctxt, json):
    out_dir_tar = ""
    other = {}
    if any(t["kind"] == ["custom-build"] for t in json["targets"]):
        other["out_dir_tar"] = ":%s_build_script_executor" % json[
            "name"].encode("UTF-8").replace("-", "_")
    data = ""
    if ctxt["data"]:
        other["data"] = ctxt["data"]
    for d in json["dependencies"]:
        if d["name"] not in ctxt["resolved_deps"] and not d["optional"] and not d["kind"]:
            sys.stderr.write(
                "WARNING: Cannot resolve required dependency on crate '%s'\n" %
                d["name"])
    return {
        "name":
        json["name"].encode("UTF-8"),
        "workspace_root":
        ctxt["workspace_root"],
        "flags":
        ctxt["flags"],
        "version":
        json["version"].encode("UTF-8"),
        "extra":
        other,
        "deps":
        resolve_deps([d for d in json["dependencies"]
                      if not d["kind"]], ctxt) + ctxt["additional_deps"],
        "build_deps":
        resolve_deps([d for d in json["dependencies"]
                      if d["kind"] == "build"], ctxt),
        # TODO(damienmg): features
    }


def to_build_file(ctxt, json):
    context = extend_context(ctxt, json)
    context["build_file"] = BazelBuildFile()
    if "license" in json and json["license"]:
        context["build_file"].licenses(json["license"])
    aliased = False
    for target in json["targets"]:
        if target["kind"][0] in ["lib", "proc-macro", "dylib", "rlib"]:
            if target["name"] == context["name"]:
                aliased = True
            elif not aliased:
                aliased = target["name"].encode("UTF-8")
            rust_library_from_context(target, context)
        elif target["kind"][0] == "bin":
            rust_binary_from_context(target, context)
        elif target["kind"][0] == "custom-build":
            custom_build_script_from_context(target, context)
        else:
            context["build_file"].comment(
                "Unsupported target %s with type %s omitted" %
                (target["name"], target["kind"][0]))
    if aliased and aliased is not True:
        context["build_file"].alias(context["name"].replace("-", "_"), aliased)
    return str(context["build_file"])


def build_context(args, json):
    return {
        "workspace_root": json["workspace_root"].encode("UTF-8"),
        "data": args.data,
        "resolved_deps":
        {v.split("=", 1)[0]: v.split("=", 1)[1]
         for v in args.dep},
        "additional_deps": [d.encode("UTF-8") for d in args.additional_dep],
        "flags": [d.encode("UTF-8") for d in (args.flag or [])],
    }


if __name__ == "__main__":
    args = parser.parse_args()
    json = json.load(
        StringIO.StringIO(
            subprocess.check_output([
                "cargo", "metadata", "--no-deps", "--manifest-path",
                args.manifest_path, "--format-version", "1"
            ])))
    args.output.write(to_build_file(build_context(args, json), json["packages"][0]))
    args.output.close()