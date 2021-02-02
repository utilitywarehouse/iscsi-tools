// This script is meant to be used in cases where needed to invoke iscsiadm
// commands in a container that runs the iscsi daemon and bash tools are not
// available (for example from inside a distroless container). It is opinionated
// to suit a setup where the host filestystem is mounted in the calling
// container under `/host` and iscsid runs in a container named `open_iscsid`.
// It also assumes a docker installation on the host under `/usr/bin/docker`.
package main

import (
	"fmt"
	"os"
	"os/exec"

	"golang.org/x/sys/unix"
)

func main() {
	if err := unix.Chroot("/host"); nil != err {
		panic(err)
	}
	if err := unix.Chdir("/"); nil != err {
		panic(err)
	}
	argv := os.Args
	out, err := execIscsiadmCommand(argv[1:])
	fmt.Print(string(out))
	if err != nil {
		if exitError, ok := err.(*exec.ExitError); ok {
			os.Exit(exitError.ExitCode())
		}
	}
}

// expexts a docker container named `open_iscsid` to exec the iscsiadm with the
// given arguments inside.
func execIscsiadmCommand(iscsiadmArgs []string) ([]byte, error) {
	cmd := `/usr/bin/docker`
	args := []string{`exec`, `-i`, `open_iscsid`, `iscsiadm`}
	args = append(args, iscsiadmArgs...)
	out, err := exec.Command(cmd, args...).CombinedOutput()
	return out, err
}
