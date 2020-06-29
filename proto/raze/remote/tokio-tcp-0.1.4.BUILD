"""
cargo-raze crate build file.

DO NOT EDIT! Replaced on runs of cargo-raze
"""
package(default_visibility = [
  # Public for visibility by "@raze__crate__version//" targets.
  #
  # Prefer access through "//proto/raze", which limits external
  # visibility to explicit Cargo.toml dependencies.
  "//visibility:public",
])

licenses([
  "notice", # MIT from expression "MIT"
])

load(
    "@io_bazel_rules_rust//rust:rust.bzl",
    "rust_library",
    "rust_binary",
    "rust_test",
)


# Unsupported target "chain" with type "test" omitted
# Unsupported target "echo" with type "test" omitted
# Unsupported target "limit" with type "test" omitted
# Unsupported target "stream-buffered" with type "test" omitted
# Unsupported target "tcp" with type "test" omitted

rust_library(
    name = "tokio_tcp",
    crate_type = "lib",
    deps = [
        "@raze__bytes__0_4_12//:bytes",
        "@raze__futures__0_1_29//:futures",
        "@raze__iovec__0_1_4//:iovec",
        "@raze__mio__0_6_21//:mio",
        "@raze__tokio_io__0_1_13//:tokio_io",
        "@raze__tokio_reactor__0_1_12//:tokio_reactor",
    ],
    srcs = glob(["**/*.rs"]),
    crate_root = "src/lib.rs",
    edition = "2015",
    rustc_flags = [
        "--cap-lints=allow",
    ],
    version = "0.1.4",
    crate_features = [
    ],
)

