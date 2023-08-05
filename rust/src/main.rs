use std::env;
use std::fs;
use std::process::Command;

fn main(){
    // Read the env
    let e = match env::var_os("_SECRET_TEST") {
        Some(v) => v.into_string().unwrap(),
        None => panic!("$_SECRET_TEST is unset")
    };
    println!("_SECRET_TEST={}", e);

    // Unset env
    env::remove_var("_SECRET_TEST");
    let e = match env::var_os("_SECRET_TEST") {
        Some(v) => v.into_string().unwrap(),
        None => String::from("")
    };
    println!("_SECRET_TEST={}", e);

    // read /proc/self/environ
    let d = fs::read_to_string("/proc/self/environ")
        .expect("Error reading /proc/self/environ");
    let mut ok = false;
    for line in d.split("\0") {
        if line.starts_with("_SECRET_TEST") {
            ok = true;
            println!("{}", line);
        };
    }
    if !ok {
            println!("_SECRET_TEST=");
    }

    // read env in subprocess
    let cmd = Command::new("bash")
        .arg("-c")
        .arg("echo _SECRET_TEST=${SECRET_TEST}")
        .output()
        .unwrap();
    let stdout = String::from_utf8(cmd.stdout).unwrap();
    println!("{}", stdout);
}
