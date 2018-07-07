package(default_visibility = ["//visibility:public"])

py_binary(
    name = "cargo_lock_to_bzl",
    srcs = ["cargo_lock_to_bzl.py"],
    deps = ["@com_github_avakar_pytoml//:pytoml"],
)

py_binary(
    name = "cargo_manifest_to_build",
    srcs = [
        "bazel_rust_helper.py",
        "cargo_licenses.py",
        "cargo_manifest_to_build.py",
    ],
)
