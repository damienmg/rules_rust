package(default_visibility = ["//visibility:public"])

exports_files([
    "rust.bzl",
    "toolchain.bzl",
    "repositories.bzl",
])

py_binary(name = "cargo_lock_to_bzl", srcs = ["cargo_lock_to_bzl.py"], deps = ["@com_github_avakar_pytoml//:pytoml"])