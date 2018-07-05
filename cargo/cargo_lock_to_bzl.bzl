def cargo_lock_deps():
    native.new_http_archive(
        name = "com_github_avakar_pytoml",
        build_file_content = """
py_library(
    name = "pytoml",
    srcs = glob(["pytoml/*.py"]),
    visibility = ["//visibility:public"],
)
""",
        sha256 = "c9bf42cd79e1a8e046daf23bfaa6fd9e723567958fdbf9873e11ff4a8e01f609",
        urls = ["https://github.com/avakar/pytoml/archive/v0.1.18.tar.gz"],
        strip_prefix = "pytoml-0.1.18"
    )

def _import_cargo_lockfiles(rctx):
    rctx.file("BUILD.bazel")
    args = [
        str(rctx.path(rctx.attr._tool)),
        "--output=def.bzl",
    ] + [
        "--skip_dep=%s=%s" % (k, v)
        for k, vl in rctx.attr.skipped_deps.items()
        for v in vl
    ] + [
        "--additional_flag=%s=%s" % (k, v)
        for k, vl in rctx.attr.additional_flags.items()
        for v in vl
    ] + [
        "--additional_dep=%s=%s" % (k, v)
        for k, vl in rctx.attr.additional_deps.items()
        for v in vl
    ] + [rctx.path(l) for l in rctx.attr.lockfiles]
    result = rctx.execute(
        args,
        environment={"PYTHONPATH": ":".join([rctx.path(l).dirname for l in rctx.attr._tool_deps])})
    if result.stderr:
        print(result.stderr)

import_cargo_lockfiles = repository_rule(
    _import_cargo_lockfiles,
    attrs = {
        "lockfiles": attr.label_list(mandatory = True),
        "additional_deps": attr.string_list_dict(),
        "additional_flags": attr.string_list_dict(),
        "skipped_deps": attr.string_list_dict(),
        "_tool": attr.label(default = "//rust:cargo_lock_to_bzl.py"),
        "_tool_deps": attr.label_list(default = ["@com_github_avakar_pytoml//:BUILD.bazel"]),
    },
)

"""Import dependencies declared in one or multiple cargo lockfiles

To use, simply generate the lockfile with `cargo generate-lockfile` then refer to it from the WORKSPACE file:
```
# Load dependencies
load("@io_bazel_rules_rust//cargo:cargo_lock_to_bzl.bzl", "cargo_lock_deps", "import_cargo_lockfiles")
cargo_lock_deps()

# Import the lockfile
import_cargo_lockfiles(name = "import_cargo_lockfiles", lockfiles = ["//:Cargo.lock"])
# Fetch the depdencies included in the lockfile
load("@import_cargo_lockfiles//:def.bzl", "cargo_lockfile_crates")
cargo_lockfile_crates()
```

It will import all the dependencies using `cargo_crate` rules. Alternatively, one can use directly
the python binary to generate the bzl file inside the repository: `bazel run //rust:cargo_lock_to_bzl -- Cargo.lock`.
See `bazel run //rust:cargo_lock_to_bzl -- --help` for the list of options.

Paramters:
  lockfiles: list of lockfiles to import.
  additional_deps: dictionary from crate (<name>-<version>) to labels of dependencies to add to the given crate.
  additional_flags: dictionary from crate (<name>-<version>) to flag to pass to the given crate.
  skipped_deps: dictionary from crate (<name>-<version>) to crate dependencies (<name>-<version>) to skip on the given crate.
"""