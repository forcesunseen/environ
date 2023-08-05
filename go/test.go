package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"strings"
)

const envvar string = "_SECRET_TEST"

func main() {
	e := os.Getenv(envvar)
	if e == "" {
		// the test is no good if we can't find the envvar
		log.Fatalf("Unable to find environment variable!")
	}
	// Print the envvar
	fmt.Printf("%s=%s\n", envvar, os.Getenv(envvar))
	// Unset the envvar
	if err := os.Unsetenv(envvar); err != nil {
		log.Fatalf("Error unsetting environment variable: %s", err.Error())
	}
	// Print the envvar again
	fmt.Printf("%s=%s\n", envvar, os.Getenv(envvar))
	// Read /proc/self/environ to look for the envvar
	d, err := ioutil.ReadFile("/proc/self/environ")
	if err != nil {
		log.Fatal("Error reading /proc/self/environ: %s", err.Error())
	}
	env := strings.Split(string(d), string('\x00'))
	ok := false
	for _, kv := range env {
		if strings.HasPrefix(kv, envvar) {
			ok = true
			fmt.Printf("%s\n", kv)
		}
	}
	if !ok {
		fmt.Printf("%s=", envvar)
	}

	cmd := exec.Command("bash", "-c", "echo \"_SECRET_TEST=${_SECRET_TEST}\"")
	b := bytes.NewBuffer([]byte(""))
	cmd.Stdout = b
	if err := cmd.Run(); err != nil {
		log.Fatal("Error executing bash subprocess to read _SECRET_TEST")
	}
	line, err := b.ReadString('\n')
	if err != nil {
		log.Fatal("Error reading bash command output")
	}
	fmt.Println(line)
}
