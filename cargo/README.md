# Integration with crates.io and Cargo

This directory contains rules and binary to integrate with Cargo and [crates.io].

- [import_cargo_lockfile](#import_cargo_lockfile) let you import import a
  `Cargo.lock` directly from the Bazel `WORKSPACE` file.
- [crate_repository](#crate_repository) and [cargo_crate](#cargo_crate) are
  rules to download dependency from [crates.io] and automatically creates BUILD
  file for them.
- [@io_bazel_rules_rust//cargo:cargo_lock_to_bzl](#cargo_lock_to_bzl) is the
  `Cargo.lock` to `.bzl` file converter used by the
  [import_cargo_lockfile](#import_cargo_lockfile) rule and can be used
  independently to vendor the Bazel extension in your sources.

## import_cargo_lockfile

`import_cargo_lockfile` import dependencies declared in one `Cargo.lock` file.

To use, simply generate the lockfile with `cargo generate-lockfile` then refer
to it from the WORKSPACE file:

```python
# Import the lockfile
load("@io_bazel_rules_rust//cargo:cargo_lock_to_bzl.bzl", "import_cargo_lockfile")
import_cargo_lockfile(["//:Cargo.lock"])
# Fetch the depdencies included in the lockfile
load("@import_cargo_lockfile//:def.bzl", "cargo_lockfile_crates")
cargo_lockfile_crates()
```

It will import all the dependencies using `cargo_crate` rules. Alternatively, one
can use directly the [python binary](#cargo_lock_to_bzl) to generate the bzl file
inside the repository.

All direct dependencies of the crate represented by the cargo lockfile will be
exposed with an aliases under `@import_cargo_lockfiles//:__<name>__`. For convenience
a macro `cargo_lockfile_aliases` is also declared in
`@import_cargo_lockfiles//:def.bzl` to declare thoses aliases in your own packages.

<table class="table table-condensed table-bordered table-params">
  <colgroup>
    <col class="col-param" />
    <col class="param-description" />
  </colgroup>
  <thead>
    <tr>
      <th colspan="2">Attributes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>name</code></td>
      <td>
        <code>Name, optional</code>
        <p>A unique name for this repository, defaulted to <code>import_cargo_lockfile</code>.</p>
      </td>
    </tr>
    <tr>
      <td><code>additional_deps</code></td>
      <td>
        <code>Dictionary of string lists, optional</code>
        <p>Dictionary from crate (<i>name</i>-<i>version</i>) to labels of
        dependencies to add to the given crate.</p>
      </td>
    </tr>
    <tr>
      <td><code>additional_flags</code></td>
      <td>
        <code>Dictionary of string lists, optional</code>
        <p>Dictionary from crate (<i>name</i>-<i>version</i>) to flags to pass to
        rustc in the given crate.</p>
      </td>
    </tr>
    <tr>
      <td><code>skipped_deps</code></td>
      <td>
        <code>Dictionary of string lists, optional</code>
        <p>Dictionary from crate (<i>name</i>-<i>version</i>) to crate dependencies
        (<i>name</i>-<i>version</i>) to skip on the given crate.</p>
      </td>
    </tr>
  </tbody>
</table>
   
## crate_repository

`crate_repository` downloads a crate declared in [crates.io] index and creates
a build file for it.

__Note__: Please prefer `cargo_crate` most of the time which automatically name
the repository and do not re-create it if it already exists.

### Example:

```python
cargo_repository(
  name = "io_crates_ansi_term__0_11_0",
  crate_name = "ansi_term",  # The crate name
  crate_version = "0.11.0",  # The crate version
  locked_deps = {"winapi": "@io_crates_winapi__0_3_5//:winapi"},
)
```

<table class="table table-condensed table-bordered table-params">
  <colgroup>
    <col class="col-param" />
    <col class="param-description" />
  </colgroup>
  <thead>
    <tr>
      <th colspan="2">Attributes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>name</code></td>
      <td>
        <code>Name, required</code>
        <p>A unique name for this repository.</p>
      </td>
    </tr>
    <tr>
      <td><code>crate_name</code></td>
      <td>
        <code>String, required</code>
        <p>The name of the crate to download.</p>
      </td>
    </tr>
    <tr>
      <td><code>crate_version</code></td>
      <td>
        <code>String, required</code>
        <p>The version of the crate to download.</p>
      </td>
    </tr>
    <tr>
      <td><code>locked_deps</code></td>
      <td>
        <code>Dictionary of strings, optional</code>
        <p>Map from dependency name to labels for resolving dependencies.
           Use an empty string as label to ignore a dependency.</p>
      </td>
    </tr>
    <tr>
      <td><code>additional_deps</code></td>
      <td>
        <code>List of strings, optional</code>
        <p>Additional dependencies (labels) to inject to the crate dependencies.</p>
      </td>
    </tr>
    <tr>
      <td><code>flags</code></td>
      <td>
        <code>List of strings, optional</code>
        <p>Additional flags to pass to rustc when compiling this crate.</p>
      </td>
    </tr>
    <tr>
      <td><code>data</code></td>
      <td>
        <code>String, optional</code>
        <p>The raw content of the data section to inject in the BUILD file.</p>
      </td>
    </tr>
    <tr>
      <td><code>sha256</code></td>
      <td>
        <code>String, optional</code>
        <p>SHA-256 of the crate archive, if included, it improves performance, notably caching.</p>
      </td>
    </tr>
  </tbody>
</table>

## cargo_crate

`cargo_crate` downloads a crate declared in [crates.io] index and creates a build
file for it, automatically naming the repository in the form
`@io_crates_<name>__<version>`. Compared to [cargo_repository](#cargo_repository), this
rule also takes version number instead of labels for dependencies and do not crate a
repository if it was already declared.

### Example:

```python
cargo_crate(
    name = "ansi_term",
    version = "0.11.0",
    locked_deps = {"winapi": "0.3.5"},
)
```

<table class="table table-condensed table-bordered table-params">
  <colgroup>
    <col class="col-param" />
    <col class="param-description" />
  </colgroup>
  <thead>
    <tr>
      <th colspan="2">Attributes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>name</code></td>
      <td>
        <code>String, required</code>
        <p>The name of the crate to download.</p>
      </td>
    </tr>
    <tr>
      <td><code>version</code></td>
      <td>
        <code>String, required</code>
        <p>The version of the crate to download.</p>
      </td>
    </tr>
    <tr>
      <td><code>locked_deps</code></td>
      <td>
        <code>Dictionary of strings, optional</code>
        <p>Map from dependency name to version for resolving dependencies.
           Use an empty string as version to ignore a dependency.</p>
      </td>
    </tr>
    <tr>
      <td><code>additional_deps</code></td>
      <td>
        <code>List of strings, optional</code>
        <p>Additional dependencies (labels) to inject to the crate dependencies.</p>
      </td>
    </tr>
    <tr>
      <td><code>flags</code></td>
      <td>
        <code>List of strings, optional</code>
        <p>Additional flags to pass to rustc when compiling this crate.</p>
      </td>
    </tr>
    <tr>
      <td><code>data</code></td>
      <td>
        <code>String, optional</code>
        <p>The raw content of the data section to inject in the BUILD file.</p>
      </td>
    </tr>
    <tr>
      <td><code>sha256</code></td>
      <td>
        <code>String, optional</code>
        <p>SHA-256 of the crate archive, if included, it improves performance, notably caching.</p>
      </td>
    </tr>
  </tbody>
</table>

## cargo_lock_to_bzl

`cargo_lock_to_bzl` is a binary provided in the `rules_rust` repository to automatically
create a `.bzl` file from a `Cargo.lock` file. The generated file can then be checked in
compared to using the [import_cargo_lockfile](#import_cargo_lockfile) rule.

You can run it with:

```bash
bazel run //rust:cargo_lock_to_bzl -- Cargo.lock
```

See `bazel run //rust:cargo_lock_to_bzl -- --help` for the list of options.

## To-do

  - [ ] Support for configuration specifics part of Cargo in [cargo_repository](#cargo_repository)
  - [ ] Support features in [cargo_repository](#cargo_repository).
  - [ ] Add tests.
  - [ ] Support non [crates.io] repositories. 
