#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#define BUFSIZE 4
extern char **environ;

int main() {
	char e[BUFSIZE];
	char *envvar = "_SECRET_TEST";
	char *envf = "/proc/self/environ";
	char eb;
	FILE *f;

	// Print the envvar
	if(!getenv(envvar)) {
		fprintf(stderr, "getenv error");
		exit(1);
	}
	if(snprintf(e, BUFSIZE, "%s", getenv(envvar)) >= BUFSIZE) {
		fprintf(stderr, "BUFSIZE %d too small", BUFSIZE);
		exit(1);
	}
	fprintf(stdout, "_SECRET_TEST=%s\n", e);

	// Unset the envvar
	if(unsetenv(envvar) != 0) {
		fprintf(stderr, "Unable to unset envvar");
		exit(1);
	}

	// Print the envvar again
	if(!getenv(envvar)) {
		fprintf(stdout, "_SECRET_TEST=\n"); // we did it, reddit!
	} else {
		if(snprintf(e, BUFSIZE, "%s", getenv(envvar)) >= BUFSIZE) {
			fprintf(stderr, "BUFSIZE %d too small", BUFSIZE);
			exit(1);
		}
		fprintf(stdout, "_SECRET_TEST=%s\n", e);
	}

	// The code below reads the environ, but isn't used
	/*
	bool ok = false;
	char* s = *environ; // technically not /proc/self/environ, but in practice the same
	for (int i = 1; NULL != s; i++) {
		if (strncmp(envvar, s, strlen(envvar)) == 0) {
			ok = true;
			fprintf(stdout, "%s\n", s);
			break;
		}
		s = *(environ+i);
	}
	if (!ok) {
		fprintf(stdout, "_SECRET_TEST=\n");
	}
	*/

	char *envfile = "/proc/self/environ";
	char buf[4096];

	f = fopen(envfile, "r");
	if (f == NULL) {
		fprintf(stderr, "error opening /proc/self/environ\n");
		exit(1);
	}

	fscanf(f, "%s", buf);
	fprintf(stdout, "%s\n", buf);

	fclose(f);
	// We would normally test and spawn a child process, but we know
	// the ENV has been successfully unset (run this program), so no need
	// to go to the effort :-)
	return 0;
}
