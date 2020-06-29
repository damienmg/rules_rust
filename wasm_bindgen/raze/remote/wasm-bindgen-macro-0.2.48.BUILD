"""
cargo-raze crate build file.

DO NOT EDIT! Replaced on runs of cargo-raze
"""
package(default_visibility = [
  # Public for visibility by "@raze__crate__version//" targets.
  #
  # Prefer access through "//wasm_bindgen/raze", which limits external
  # visibility to explicit Cargo.toml dependencies.
  "//visibility:public",
])

licenses([
  "notice", # MIT from expression "MIT OR Apache-2.0"
])

load(
    "@io_bazel_rules_rust//rust:rust.bzl",
    "rust_library",
    "rust_binary",
    "rust_test",
)


# Unsupported target "ui" with type "test" omitted

rust_library(
    name = "wasm_bindgen_macro",
    crate_type = "proc-macro",
    deps = [
        "@raze__quote__0_6_12//:quote",
        "@raze__wasm_bindgen_macro_support__0_2_48//:wasm_bindgen_macro_support",
    ],
    srcs = glob(["**/*.rs"]),
    crate_root = "src/lib.rs",
    edition = "2018",
    rustc_flags = [
        "--cap-lints=allow",
    ],
    version = "0.2.48",
    crate_features = [
        "spans",
    ],
)

