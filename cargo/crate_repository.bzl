def _build_script_impl(ctx):
    toolchain = ctx.toolchains["@io_bazel_rules_rust//rust:toolchain"]
    out_dir = ctx.actions.declare_directory(ctx.label.name + "_out_dir_outputs")
    env = {
        "CARGO_MANIFEST_DIR": ctx.build_file_path.rsplit("/", 1)[0],
        "RUSTC": toolchain.rustc.path,
        "TARGET": toolchain.triplet,
        "RUST_BACKTRACE": "1",
        "OUT_DIR": out_dir.path,
        "BINARY_PATH": ctx.executable.script.path,
    } + {
        "CARGO_FEATURE_" + f.upper().replace("-", "_"): "1"
        for f in ctx.attr.crate_features
    }
    ctx.actions.run_shell(
        command = "%s >/dev/null" % ctx.executable.script.path,
        outputs = [out_dir],
        inputs = ctx.files.srcs + [ctx.executable.script, toolchain.rustc],
        mnemonic = "CargoBuildScript",
        env = env,
    )
    ctx.actions.run_shell(
        command = "tar czf '%s' -C '%s' ." % (ctx.outputs.out.path, out_dir.path),
        inputs = [out_dir],
        outputs = [ctx.outputs.out],
    )

cargo_build_script_run = rule(
    _build_script_impl,
    attrs = {
        "script": attr.label(
            executable = True,
            allow_files = True,
            mandatory = True,
            cfg = "host",
        ),
        "crate_features": attr.string_list(),
        "srcs": attr.label_list(allow_files = True),
    },
    outputs = {"out": "%{name}.tar.gz"},
    toolchains = ["@io_bazel_rules_rust//rust:toolchain"],
)

def _impl(rctx):
    kwargs = {
        "name": rctx.attr.crate_name,
        "version": rctx.attr.crate_version,
    }
    # Enforce dependencies on the tool dependencies
    for dep in rctx.attr._tool_deps:
        rctx.path(dep)
    rctx.download_and_extract(
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/{name}/{name}-{version}.crate".format(**kwargs),
        sha256 = rctx.attr.sha256,
        type = "tar.gz",
        stripPrefix = "{name}-{version}".format(**kwargs),
    )
    args = [
        str(rctx.path(rctx.attr._tool)),
        "--output=BUILD.bazel",
    ] + [
        "%s=%s" % (k, v)
        for k, v in rctx.attr.locked_deps.items()
    ] + [
        "--flag=" + f
        for f in rctx.attr.flags
    ] + [
        "--feature_group=" + f
        for f in rctx.attr.feature_groups
    ]
    if rctx.attr.data:
        args.append("--data=" + rctx.attr.data)
    for dep in rctx.attr.additional_deps:
        args.append("--additional_dep=" + dep)
    result = rctx.execute(args)
    if result.stderr or result.stdout or result.return_code != 0:
        print("Resolving %s:" % rctx.attr.name)
        print("%s%s" % (result.stdout, result.stderr))
        print("Running %s" % args)
        if result.return_code != 0:
            fail("Failed with returned code %s" % result.return_code)

crate_repository = repository_rule(
    _impl,
    attrs = {
        "crate_name": attr.string(mandatory = True),
        "crate_version": attr.string(mandatory = True),
        "locked_deps": attr.string_dict(default={}),
        "additional_deps": attr.string_list(default=[]),
        "feature_groups": attr.string_list(default=[]),
        "flags": attr.string_list(default=[]),
        "data": attr.string(),
        "sha256": attr.string(),
        "_tool": attr.label(default = "//cargo:cargo_manifest_to_build.py"),
        # Declare dependencies of this repository rules to all the python deps.
        "_tool_deps": attr.label_list(default = [
            "//cargo:bazel_rust_helper.py",
            "//cargo:cargo_licenses.py",
            "//cargo:cargo_features.py",
        ])
    },
)

"""Download a crate declared in crates.io index and creates a build file for it.

Example:

```python
cargo_repository(
  name = "io_crates_ansi_term__0_11_0",
  crate_name = "ansi_term",  # The crate name
  crate_version = "0.11.0",  # The crate version
  locked_deps = {"winapi": "@io_crates_winapi__0_3_5//:winapi"},
  feature_groups = ["default+binary"],  # Generate a target with the features "default+binary"
)
```

Arguments:
    crate_name: the name of the crate to download
    crate_version: the version of the crate to download
    locked_deps: map from dependency name to labels for resolving dependency. Use an empty string to remove a dependency.
    additional_deps: additional dependencies (labels) to inject to the crate.
    feature_groups: list of feature groups to generate. A feature group is a "+" separated list of features that will
      be needed from that crate.
    flags: additional flags to pass to rustc for compiling this crate.
    data: string content for the data attribute to inject in the build file.
    sha256: SHA-256 of the crate archive, if included, it improve performance, notably caching.
"""

def _split(s):
    result = []
    for l in s.split("."):
        result.extend(l.split("/"))
    return result

def _dns_to_workspace(repository):
    return "_".join(reversed(_split(repository)))

def cargo_crate(name, version, locked_deps={}, **kwargs):
    """Download a crate declared in crates.io index and creates a build file for it, automatically naming the repository
    in the form `@io_crates_<name>__<version>`.

    Example:

    ```python
    cargo_crate(
        name = "ansi_term",
        version = "0.11.0",
        locked_deps = {"winapi": "0.3.5"},
    )
    ```

    Arguments:
        name: the name of the crate to download
        version: the version of the crate to download
        locked_deps: map from dependency name to version for resolving dependency.
          Use an empty string to remove a dependency. The crate is then expected to be available at
          `@io_crates_<name>__<version>//:<name>`.
        additional_deps: additional dependencies (labels) to inject to the crate.
        feature_groups: list of feature groups to generate. A feature group is a "+" separated list of features that will
          be needed from that crate.
        flags: additional flags to pass to rustc for compiling this crate.
        data: string content for the data attribute to inject in the build file.
        sha256: SHA-256 of the crate archive, if included, it improve performance, notably caching.
    """
    n = "io_crates_%s__%s" % (
        name.replace("-", "_"),
        version.replace(".", "_"),
    )
    locked_deps = {
        k: "@io_crates_{name}__{version}//:{name}".format(
            name=k.replace("-", "_"),
            version=v.replace(".", "_")
        )
        for k, v in locked_deps.items()
    }
    if not native.existing_rule(n):
        crate_repository(
            name = n,
            crate_version = version,
            crate_name = name,
            locked_deps = locked_deps,
            **kwargs
        )
