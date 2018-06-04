// Copyright 2018 The Bazel Authors. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Integration tests for the greeter client/server
use std::process::{Command, Child, Stdio};
use std::io::BufReader;
use std::str::FromStr;
use std::io::BufRead;

/// Returns the .runfiles directory for the currently executing binary.
fn get_runfiles_dir() -> String {
    let mut path = std::env::current_exe().unwrap();

    if cfg!(target_os = "macos") {
        path.pop();
    } else {
        let mut name = path.file_name().unwrap().to_owned();
        name.push(".runfiles");
        path.pop();
        path.push(name);
    }

    path.into_os_string().into_string().unwrap()
}

struct ServerInfo {
    process: Child,
    port: u16,
}

macro_rules! assert_contains {
    ($s: expr, $e: expr) => {
        assert!($s.find($e).is_some(), format!("'{}' not found in '{}'", $e, $s));
    }
}

impl ServerInfo {
    fn new() -> ServerInfo {
        let mut c = Command::new(format!(
            "{}/examples/proto/helloworld/greeter_server/greeter_server",
            get_runfiles_dir()
        )).arg("0")
            .stdout(Stdio::piped())
            .spawn()
            .expect("Unable to start server");
        let mut port: u16 = 0;
        {
            let mut stdout = BufReader::new(c.stdout.as_mut().expect("Failed to open stdout"));
            let port_prefix = "greeter server started on port ";
            while port == 0 {
                let mut line = String::new();
                stdout.read_line(&mut line).expect(
                    "Waiting for server startup",
                );
                line = line.trim().to_owned();
                if line.starts_with(port_prefix) {
                    port = u16::from_str(&line[port_prefix.len()..]).expect(&format!(
                        "Invalid port number {}",
                        &line[port_prefix.len()..]
                    ))
                }
            }
        }
        println!("Started server on port {}", port);
        ServerInfo {
            process: c,
            port: port,
        }
    }

    fn run_client_impl(&self, arg: Option<String>) -> String {
        let mut cmd0 = Command::new(format!(
            "{}/examples/proto/helloworld/greeter_client/greeter_client",
            get_runfiles_dir()
        ));
        let cmd = cmd0.arg(format!("-p={}", self.port));

        let output = if let Some(s) = arg { cmd.arg(s) } else { cmd }
            .output()
            .expect("Unable to start client");
        assert!(output.status.success());
        String::from_utf8(output.stdout).expect("Non UTF-8 output from the client")
    }

    fn run_client(&self) -> String {
        self.run_client_impl(None)
    }
    fn run_client_with_arg(&self, arg: &str) -> String {
        self.run_client_impl(Some(arg.to_owned()))
    }

    fn expect_log(&mut self, log: &str) {
        let mut reader =
            BufReader::new(self.process.stdout.as_mut().expect("Failed to open stdout"));
        let mut line = String::new();
        reader.read_line(&mut line).expect(
            "Failed to read line from the server",
        );
        assert_contains!(line, log);
    }

    fn destroy(&mut self) {
        self.process.kill().unwrap();
    }
}


#[test]
fn test_client_server() {
    let mut s = ServerInfo::new();
    assert_contains!(s.run_client(), "message: \"Hello world\"");
    s.expect_log("greeting request from world");
    assert_contains!(s.run_client_with_arg("thou"), "message: \"Hello thou\"");
    s.expect_log("greeting request from thou");
    s.destroy();
}