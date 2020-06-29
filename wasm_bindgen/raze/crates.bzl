"""
cargo-raze crate workspace functions

DO NOT EDIT! Replaced on runs of cargo-raze
"""
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")

def _new_http_archive(name, **kwargs):
    if not native.existing_rule(name):
        http_archive(name=name, **kwargs)

def _new_git_repository(name, **kwargs):
    if not native.existing_rule(name):
        new_git_repository(name=name, **kwargs)

def raze_fetch_remote_crates():

    _new_http_archive(
        name = "raze__bumpalo__2_4_3",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/bumpalo/bumpalo-2.4.3.crate",
        type = "tar.gz",
        sha256 = "84dca3afd8e01b9526818b7963e5b4916063b3cdf9f10cf6b73ef0bd0ec37aa5",
        strip_prefix = "bumpalo-2.4.3",
        build_file = Label("//wasm_bindgen/raze/remote:bumpalo-2.4.3.BUILD"),
    )

    _new_http_archive(
        name = "raze__cfg_if__0_1_9",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/cfg-if/cfg-if-0.1.9.crate",
        type = "tar.gz",
        sha256 = "b486ce3ccf7ffd79fdeb678eac06a9e6c09fc88d33836340becb8fffe87c5e33",
        strip_prefix = "cfg-if-0.1.9",
        build_file = Label("//wasm_bindgen/raze/remote:cfg-if-0.1.9.BUILD"),
    )

    _new_http_archive(
        name = "raze__lazy_static__1_3_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/lazy_static/lazy_static-1.3.0.crate",
        type = "tar.gz",
        sha256 = "bc5729f27f159ddd61f4df6228e827e86643d4d3e7c32183cb30a1c08f604a14",
        strip_prefix = "lazy_static-1.3.0",
        build_file = Label("//wasm_bindgen/raze/remote:lazy_static-1.3.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__log__0_4_6",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/log/log-0.4.6.crate",
        type = "tar.gz",
        sha256 = "c84ec4b527950aa83a329754b01dbe3f58361d1c5efacd1f6d68c494d08a17c6",
        strip_prefix = "log-0.4.6",
        build_file = Label("//wasm_bindgen/raze/remote:log-0.4.6.BUILD"),
    )

    _new_http_archive(
        name = "raze__proc_macro2__0_4_30",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/proc-macro2/proc-macro2-0.4.30.crate",
        type = "tar.gz",
        sha256 = "cf3d2011ab5c909338f7887f4fc896d35932e29146c12c8d01da6b22a80ba759",
        strip_prefix = "proc-macro2-0.4.30",
        build_file = Label("//wasm_bindgen/raze/remote:proc-macro2-0.4.30.BUILD"),
    )

    _new_http_archive(
        name = "raze__quote__0_6_12",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/quote/quote-0.6.12.crate",
        type = "tar.gz",
        sha256 = "faf4799c5d274f3868a4aae320a0a182cbd2baee377b378f080e16a23e9d80db",
        strip_prefix = "quote-0.6.12",
        build_file = Label("//wasm_bindgen/raze/remote:quote-0.6.12.BUILD"),
    )

    _new_http_archive(
        name = "raze__syn__0_15_43",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/syn/syn-0.15.43.crate",
        type = "tar.gz",
        sha256 = "ee06ea4b620ab59a2267c6b48be16244a3389f8bfa0986bdd15c35b890b00af3",
        strip_prefix = "syn-0.15.43",
        build_file = Label("//wasm_bindgen/raze/remote:syn-0.15.43.BUILD"),
    )

    _new_http_archive(
        name = "raze__unicode_xid__0_1_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/unicode-xid/unicode-xid-0.1.0.crate",
        type = "tar.gz",
        sha256 = "fc72304796d0818e357ead4e000d19c9c174ab23dc11093ac919054d20a6a7fc",
        strip_prefix = "unicode-xid-0.1.0",
        build_file = Label("//wasm_bindgen/raze/remote:unicode-xid-0.1.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__wasm_bindgen__0_2_48",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/wasm-bindgen/wasm-bindgen-0.2.48.crate",
        type = "tar.gz",
        sha256 = "4de97fa1806bb1a99904216f6ac5e0c050dc4f8c676dc98775047c38e5c01b55",
        strip_prefix = "wasm-bindgen-0.2.48",
        build_file = Label("//wasm_bindgen/raze/remote:wasm-bindgen-0.2.48.BUILD"),
    )

    _new_http_archive(
        name = "raze__wasm_bindgen_backend__0_2_48",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/wasm-bindgen-backend/wasm-bindgen-backend-0.2.48.crate",
        type = "tar.gz",
        sha256 = "5d82c170ef9f5b2c63ad4460dfcee93f3ec04a9a36a4cc20bc973c39e59ab8e3",
        strip_prefix = "wasm-bindgen-backend-0.2.48",
        build_file = Label("//wasm_bindgen/raze/remote:wasm-bindgen-backend-0.2.48.BUILD"),
    )

    _new_http_archive(
        name = "raze__wasm_bindgen_macro__0_2_48",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/wasm-bindgen-macro/wasm-bindgen-macro-0.2.48.crate",
        type = "tar.gz",
        sha256 = "f07d50f74bf7a738304f6b8157f4a581e1512cd9e9cdb5baad8c31bbe8ffd81d",
        strip_prefix = "wasm-bindgen-macro-0.2.48",
        build_file = Label("//wasm_bindgen/raze/remote:wasm-bindgen-macro-0.2.48.BUILD"),
    )

    _new_http_archive(
        name = "raze__wasm_bindgen_macro_support__0_2_48",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/wasm-bindgen-macro-support/wasm-bindgen-macro-support-0.2.48.crate",
        type = "tar.gz",
        sha256 = "95cf8fe77e45ba5f91bc8f3da0c3aa5d464b3d8ed85d84f4d4c7cc106436b1d7",
        strip_prefix = "wasm-bindgen-macro-support-0.2.48",
        build_file = Label("//wasm_bindgen/raze/remote:wasm-bindgen-macro-support-0.2.48.BUILD"),
    )

    _new_http_archive(
        name = "raze__wasm_bindgen_shared__0_2_48",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/wasm-bindgen-shared/wasm-bindgen-shared-0.2.48.crate",
        type = "tar.gz",
        sha256 = "d9c2d4d4756b2e46d3a5422e06277d02e4d3e1d62d138b76a4c681e925743623",
        strip_prefix = "wasm-bindgen-shared-0.2.48",
        build_file = Label("//wasm_bindgen/raze/remote:wasm-bindgen-shared-0.2.48.BUILD"),
    )

