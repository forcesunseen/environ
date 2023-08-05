# Stop storing secrets in environment variables

A short code follow-up to the [blog post](https://blog.forcesunseen.com/stop-storing-secrets-in-environment-variables) to demonstrate why unsetting environment variables [can be tricky](https://old.reddit.com/r/netsec/comments/sevepr/comment/hum23xj/?utm_source=share&utm_medium=web2x&context=3). Often you're best off just not using them.

## Threats

1. An application *internal* dependency disclosing `ENV` during a crash or exception (language library)
2. An application *external* dependency disclosing `ENV` during a crash or exception (ffmpeg, imagemagick, etc.)
3. A limited command injection attack (no `$IFS`)
4. An arbitrary file read of `/self/proc/environ`

## Results: tl;dr

Most language runtimes maintain a "shadow-copy" of the environment that is
manipulated and inherited by sub-processes (exec, not fork). Arbitrary file
reads of `/proc/self/environ` are still game over even if the application
unsets the environment variables.

[Don't use environment variables for secret storage](https://blog.forcesunseen.com/stop-storing-secrets-in-environment-variables).

## Tests

| Test                                      | Threat   |
| ----                                      | ------   |
| Print the envvar (simple echo)            | \[test\] |
| Unset and print the envvar                | \[1, 3\] |
| Read the envvar from `/proc/self/environ` | \[3, 4\] |
| Print envvar from subprocess              | \[2, 3\] |

## Languages

* [x] Bash
* [x] C
* [x] C#
* [x] Go
* [ ] Java
* [x] JavaScript
* [x] Python
* [x] Ruby
* [x] Rust

## Results

| Language   | Envvar             | Envvar after unset | Envvar in `/proc/self/environ` after unset | Envvar in subprocess after reset |
| ---------- | -----------        | ------------       | --------------------                       | ---------------------------      |
| Bash       | :white_check_mark: | :heavy_check_mark: | :heavy_check_mark:                         | :heavy_check_mark:               |
| C          | :white_check_mark: | :heavy_check_mark: | :white_check_mark:                         | :heavy_check_mark:               |
| C#         | :white_check_mark: | :heavy_check_mark: | :white_check_mark:                         | :heavy_check_mark:               |
| Go         | :white_check_mark: | :heavy_check_mark: | :white_check_mark:                         | :heavy_check_mark:               |
| Java       | :white_check_mark: | :heavy_check_mark: | :white_check_mark:                         | :heavy_check_mark:               |
| JavaScript | :white_check_mark: | :heavy_check_mark: | :white_check_mark:                         | :heavy_check_mark:               |
| Python     | :white_check_mark: | :heavy_check_mark: | :white_check_mark:                         | :heavy_check_mark:               |
| Ruby       | :white_check_mark: | :heavy_check_mark: | :white_check_mark:                         | :heavy_check_mark:               |
| Rust       | :white_check_mark: | :heavy_check_mark: | :white_check_mark:                         | :heavy_check_mark:               |

This table is updated manually.

For the absolute latest results, view the [Github Actions CI job log](https://github.com/forcesunseen/environ/actions/workflows/test.yml).

### Legend

:heavy_check_mark: means the envvar couldn't be read.
:white_check_mark: means the envvar was readable.

## Notes about the tests

Each test is hacked together. I'm not a polyglot developer.
PRs to improve inadequate tests are welcome.
