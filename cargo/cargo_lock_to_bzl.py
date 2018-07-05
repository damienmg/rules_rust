#!/usr/bin/env python
import sys
import pytoml
import argparse

parser = argparse.ArgumentParser()
parser.add_argument(
    "lock_file", nargs="*", help="List of lock file to parse, use '-' for stdin")
parser.add_argument(
    "--name",
    default="cargo_lockfile_crates",
    help="Name of the macro to generate")
parser.add_argument(
    "--additional_dep",
    action="append",
    default=[],
    help="New dependency to add to crate <name> in the form <name>-<version>=//label"
)
parser.add_argument(
    "--additional_flag",
    action="append",
    default=[],
    help="New flag to add to crate <name> in the form <name>-<version>=--flag"
)
parser.add_argument(
    "--skip_dep",
    action="append",
    default=[],
    help="Dependency to remove from crate <name> in the form <name>-<version>=<depname>-<depversion>")
parser.add_argument(
    "--output",
    type=argparse.FileType("w"),
    default=sys.stdout,
    help="output file")

def cargo_crate(**kwargs):
    kwargs = {k:v for k,v in kwargs.items() if v != None}
    return "cargo_crate(%s)" % (", ".join(["%s=%s" % (k, repr(v)) for k, v in kwargs.items()]))

def lock_to_bzl(fin, fout, name, ctxt):
    lock_file = pytoml.load(fin)
    fout.write("""
load("@io_bazel_rules_rust//cargo:crate_repository.bzl", "cargo_crate")

def %s():""" % name)
    for p in lock_file["package"]:
        if "source" in p and p["source"].endswith("crates.io-index"):
            name = p["name"].encode("UTF-8")
            version = p["version"].encode("UTF-8")
            versioned_name = "%s-%s" % (name, version)
            skipped_deps = set(ctxt["skpped_deps"][versioned_name] if versioned_name in ctxt["skipped_deps"] else [])
            source = p["source"].encode("UTF-8")
            locked_deps = [d.encode("UTF-8").split(" ", 2) for d in p["dependencies"]] if "dependencies" in p else []
            locked_deps = [d for d in locked_deps if not ("%s-%s" % (d[0], d[1])) in skipped_deps]
            checksum_key = "checksum %s %s (%s)" % (name, version, source)
            checksum = lock_file["metadata"][checksum_key].encode("UTF-8") if checksum_key in lock_file["metadata"] else None
            flags = ctxt["added_flags"][versioned_name] if versioned_name in ctxt["added_flags"] else None
            added_deps = ctxt["added_deps"][versioned_name] if versioned_name in ctxt["added_deps"] else None
            fout.write("\n  " + cargo_crate(
                name=name,
                version=version,
                locked_deps={d[0]: d[1] for d in locked_deps},
                additional_deps=added_deps,
                flags=flags,
                sha256=checksum))
    fout.write("\n")

def dep_context(args):
    return {
        "added_deps": {
            v.split("=", 1)[0]: v.split("=", 1)[1]
            for v in args.additional_dep
        },
        "added_flags": {
            v.split("=", 1)[0]: v.split("=", 1)[1]
            for v in args.additional_flag
        },
        "skipped_deps": {
            v.split("=", 1)[0]: v.split("=", 1)[1]
            for v in args.skip_dep
        }
    }

if __name__ == "__main__":
    args = parser.parse_args()
    ctxt = dep_context(args)
    for f in args.lock_file:
        if f == "-":
            lock_to_bzl(sys.stdin, args.output, args.name, ctxt)
        else:
            with open(f, "r") as fin:
                lock_to_bzl(fin, args.output, args.name, ctxt)
