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
        name = "raze__aho_corasick__0_7_13",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/aho-corasick/aho-corasick-0.7.13.crate",
        type = "tar.gz",
        strip_prefix = "aho-corasick-0.7.13",
        build_file = Label("//bindgen/raze/remote:aho-corasick-0.7.13.BUILD"),
    )

    _new_http_archive(
        name = "raze__ansi_term__0_11_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/ansi_term/ansi_term-0.11.0.crate",
        type = "tar.gz",
        strip_prefix = "ansi_term-0.11.0",
        build_file = Label("//bindgen/raze/remote:ansi_term-0.11.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__atty__0_2_14",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/atty/atty-0.2.14.crate",
        type = "tar.gz",
        strip_prefix = "atty-0.2.14",
        build_file = Label("//bindgen/raze/remote:atty-0.2.14.BUILD"),
    )

    _new_http_archive(
        name = "raze__bindgen__0_54_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/bindgen/bindgen-0.54.0.crate",
        type = "tar.gz",
        strip_prefix = "bindgen-0.54.0",
        build_file = Label("//bindgen/raze/remote:bindgen-0.54.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__bitflags__1_2_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/bitflags/bitflags-1.2.1.crate",
        type = "tar.gz",
        strip_prefix = "bitflags-1.2.1",
        build_file = Label("//bindgen/raze/remote:bitflags-1.2.1.BUILD"),
    )

    _new_http_archive(
        name = "raze__cc__1_0_55",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/cc/cc-1.0.55.crate",
        type = "tar.gz",
        strip_prefix = "cc-1.0.55",
        build_file = Label("//bindgen/raze/remote:cc-1.0.55.BUILD"),
    )

    _new_http_archive(
        name = "raze__cexpr__0_4_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/cexpr/cexpr-0.4.0.crate",
        type = "tar.gz",
        strip_prefix = "cexpr-0.4.0",
        build_file = Label("//bindgen/raze/remote:cexpr-0.4.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__cfg_if__0_1_10",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/cfg-if/cfg-if-0.1.10.crate",
        type = "tar.gz",
        strip_prefix = "cfg-if-0.1.10",
        build_file = Label("//bindgen/raze/remote:cfg-if-0.1.10.BUILD"),
    )

    _new_http_archive(
        name = "raze__clang_sys__0_29_3",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/clang-sys/clang-sys-0.29.3.crate",
        type = "tar.gz",
        strip_prefix = "clang-sys-0.29.3",
        build_file = Label("//bindgen/raze/remote:clang-sys-0.29.3.BUILD"),
    )

    _new_http_archive(
        name = "raze__clap__2_33_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/clap/clap-2.33.1.crate",
        type = "tar.gz",
        strip_prefix = "clap-2.33.1",
        build_file = Label("//bindgen/raze/remote:clap-2.33.1.BUILD"),
    )

    _new_http_archive(
        name = "raze__env_logger__0_7_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/env_logger/env_logger-0.7.1.crate",
        type = "tar.gz",
        strip_prefix = "env_logger-0.7.1",
        build_file = Label("//bindgen/raze/remote:env_logger-0.7.1.BUILD"),
    )

    _new_http_archive(
        name = "raze__glob__0_3_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/glob/glob-0.3.0.crate",
        type = "tar.gz",
        strip_prefix = "glob-0.3.0",
        build_file = Label("//bindgen/raze/remote:glob-0.3.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__hermit_abi__0_1_14",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/hermit-abi/hermit-abi-0.1.14.crate",
        type = "tar.gz",
        strip_prefix = "hermit-abi-0.1.14",
        build_file = Label("//bindgen/raze/remote:hermit-abi-0.1.14.BUILD"),
    )

    _new_http_archive(
        name = "raze__humantime__1_3_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/humantime/humantime-1.3.0.crate",
        type = "tar.gz",
        strip_prefix = "humantime-1.3.0",
        build_file = Label("//bindgen/raze/remote:humantime-1.3.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__lazy_static__1_4_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/lazy_static/lazy_static-1.4.0.crate",
        type = "tar.gz",
        strip_prefix = "lazy_static-1.4.0",
        build_file = Label("//bindgen/raze/remote:lazy_static-1.4.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__lazycell__1_2_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/lazycell/lazycell-1.2.1.crate",
        type = "tar.gz",
        strip_prefix = "lazycell-1.2.1",
        build_file = Label("//bindgen/raze/remote:lazycell-1.2.1.BUILD"),
    )

    _new_http_archive(
        name = "raze__libc__0_2_71",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/libc/libc-0.2.71.crate",
        type = "tar.gz",
        strip_prefix = "libc-0.2.71",
        build_file = Label("//bindgen/raze/remote:libc-0.2.71.BUILD"),
    )

    _new_http_archive(
        name = "raze__libloading__0_5_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/libloading/libloading-0.5.2.crate",
        type = "tar.gz",
        strip_prefix = "libloading-0.5.2",
        build_file = Label("//bindgen/raze/remote:libloading-0.5.2.BUILD"),
    )

    _new_http_archive(
        name = "raze__log__0_4_8",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/log/log-0.4.8.crate",
        type = "tar.gz",
        strip_prefix = "log-0.4.8",
        build_file = Label("//bindgen/raze/remote:log-0.4.8.BUILD"),
    )

    _new_http_archive(
        name = "raze__memchr__2_3_3",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/memchr/memchr-2.3.3.crate",
        type = "tar.gz",
        strip_prefix = "memchr-2.3.3",
        build_file = Label("//bindgen/raze/remote:memchr-2.3.3.BUILD"),
    )

    _new_http_archive(
        name = "raze__nom__5_1_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/nom/nom-5.1.2.crate",
        type = "tar.gz",
        strip_prefix = "nom-5.1.2",
        build_file = Label("//bindgen/raze/remote:nom-5.1.2.BUILD"),
    )

    _new_http_archive(
        name = "raze__peeking_take_while__0_1_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/peeking_take_while/peeking_take_while-0.1.2.crate",
        type = "tar.gz",
        strip_prefix = "peeking_take_while-0.1.2",
        build_file = Label("//bindgen/raze/remote:peeking_take_while-0.1.2.BUILD"),
    )

    _new_http_archive(
        name = "raze__proc_macro2__1_0_18",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/proc-macro2/proc-macro2-1.0.18.crate",
        type = "tar.gz",
        strip_prefix = "proc-macro2-1.0.18",
        build_file = Label("//bindgen/raze/remote:proc-macro2-1.0.18.BUILD"),
    )

    _new_http_archive(
        name = "raze__quick_error__1_2_3",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/quick-error/quick-error-1.2.3.crate",
        type = "tar.gz",
        strip_prefix = "quick-error-1.2.3",
        build_file = Label("//bindgen/raze/remote:quick-error-1.2.3.BUILD"),
    )

    _new_http_archive(
        name = "raze__quote__1_0_7",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/quote/quote-1.0.7.crate",
        type = "tar.gz",
        strip_prefix = "quote-1.0.7",
        build_file = Label("//bindgen/raze/remote:quote-1.0.7.BUILD"),
    )

    _new_http_archive(
        name = "raze__regex__1_3_9",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/regex/regex-1.3.9.crate",
        type = "tar.gz",
        strip_prefix = "regex-1.3.9",
        build_file = Label("//bindgen/raze/remote:regex-1.3.9.BUILD"),
    )

    _new_http_archive(
        name = "raze__regex_syntax__0_6_18",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/regex-syntax/regex-syntax-0.6.18.crate",
        type = "tar.gz",
        strip_prefix = "regex-syntax-0.6.18",
        build_file = Label("//bindgen/raze/remote:regex-syntax-0.6.18.BUILD"),
    )

    _new_http_archive(
        name = "raze__rustc_hash__1_1_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/rustc-hash/rustc-hash-1.1.0.crate",
        type = "tar.gz",
        strip_prefix = "rustc-hash-1.1.0",
        build_file = Label("//bindgen/raze/remote:rustc-hash-1.1.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__shlex__0_1_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/shlex/shlex-0.1.1.crate",
        type = "tar.gz",
        strip_prefix = "shlex-0.1.1",
        build_file = Label("//bindgen/raze/remote:shlex-0.1.1.BUILD"),
    )

    _new_http_archive(
        name = "raze__strsim__0_8_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/strsim/strsim-0.8.0.crate",
        type = "tar.gz",
        strip_prefix = "strsim-0.8.0",
        build_file = Label("//bindgen/raze/remote:strsim-0.8.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__termcolor__1_1_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/termcolor/termcolor-1.1.0.crate",
        type = "tar.gz",
        strip_prefix = "termcolor-1.1.0",
        build_file = Label("//bindgen/raze/remote:termcolor-1.1.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__textwrap__0_11_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/textwrap/textwrap-0.11.0.crate",
        type = "tar.gz",
        strip_prefix = "textwrap-0.11.0",
        build_file = Label("//bindgen/raze/remote:textwrap-0.11.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__thread_local__1_0_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/thread_local/thread_local-1.0.1.crate",
        type = "tar.gz",
        strip_prefix = "thread_local-1.0.1",
        build_file = Label("//bindgen/raze/remote:thread_local-1.0.1.BUILD"),
    )

    _new_http_archive(
        name = "raze__unicode_width__0_1_7",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/unicode-width/unicode-width-0.1.7.crate",
        type = "tar.gz",
        strip_prefix = "unicode-width-0.1.7",
        build_file = Label("//bindgen/raze/remote:unicode-width-0.1.7.BUILD"),
    )

    _new_http_archive(
        name = "raze__unicode_xid__0_2_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/unicode-xid/unicode-xid-0.2.1.crate",
        type = "tar.gz",
        strip_prefix = "unicode-xid-0.2.1",
        build_file = Label("//bindgen/raze/remote:unicode-xid-0.2.1.BUILD"),
    )

    _new_http_archive(
        name = "raze__vec_map__0_8_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/vec_map/vec_map-0.8.2.crate",
        type = "tar.gz",
        strip_prefix = "vec_map-0.8.2",
        build_file = Label("//bindgen/raze/remote:vec_map-0.8.2.BUILD"),
    )

    _new_http_archive(
        name = "raze__version_check__0_9_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/version_check/version_check-0.9.2.crate",
        type = "tar.gz",
        strip_prefix = "version_check-0.9.2",
        build_file = Label("//bindgen/raze/remote:version_check-0.9.2.BUILD"),
    )

    _new_http_archive(
        name = "raze__which__3_1_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/which/which-3.1.1.crate",
        type = "tar.gz",
        strip_prefix = "which-3.1.1",
        build_file = Label("//bindgen/raze/remote:which-3.1.1.BUILD"),
    )

    _new_http_archive(
        name = "raze__winapi__0_3_9",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/winapi/winapi-0.3.9.crate",
        type = "tar.gz",
        strip_prefix = "winapi-0.3.9",
        build_file = Label("//bindgen/raze/remote:winapi-0.3.9.BUILD"),
    )

    _new_http_archive(
        name = "raze__winapi_i686_pc_windows_gnu__0_4_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/winapi-i686-pc-windows-gnu/winapi-i686-pc-windows-gnu-0.4.0.crate",
        type = "tar.gz",
        strip_prefix = "winapi-i686-pc-windows-gnu-0.4.0",
        build_file = Label("//bindgen/raze/remote:winapi-i686-pc-windows-gnu-0.4.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__winapi_util__0_1_5",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/winapi-util/winapi-util-0.1.5.crate",
        type = "tar.gz",
        strip_prefix = "winapi-util-0.1.5",
        build_file = Label("//bindgen/raze/remote:winapi-util-0.1.5.BUILD"),
    )

    _new_http_archive(
        name = "raze__winapi_x86_64_pc_windows_gnu__0_4_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/winapi-x86_64-pc-windows-gnu/winapi-x86_64-pc-windows-gnu-0.4.0.crate",
        type = "tar.gz",
        strip_prefix = "winapi-x86_64-pc-windows-gnu-0.4.0",
        build_file = Label("//bindgen/raze/remote:winapi-x86_64-pc-windows-gnu-0.4.0.BUILD"),
    )

