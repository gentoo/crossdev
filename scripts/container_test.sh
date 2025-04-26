#!/bin/bash

set -e

print_help() {
	echo "Usage: $0 [OPTIONS]

Options:
  --skip-system         Skip emerging the @system set after setting up crossdev.
  --tag <tag>           Specify the container tag to use. Default is 'latest'.
  --target <target>     Specify the target architecture for crossdev. Required.
  --profile <profile>   Specify the Portage profile for crossdev. Default is 'embedded'.
  -h, --help            Show this help message and exit.

Environment Variables:
  CONTAINER_ENGINE      Specify the container engine to use (docker or podman).
                        Default is detected automatically.
  CONTAINER_NAME        Name of the container instance. Default is 'crossdev'.
  CONTAINER_URI         URI of the container image. Default is 'docker.io/gentoo/stage3'.

Examples:
  # Run with the default container and target architecture
  $0 --target aarch64-unknown-linux-gnu

  # Run with a specific container tag and skip emerging @system
  $0 --tag stable --target riscv64-unknown-linux-musl --skip-system

Notes:
  - You must specify a target using the --target option.
  - Ensure the container engine (docker or podman) is installed and available."
}

detect_container_engine() {
	if command -v podman &>/dev/null; then
		echo "podman"
	elif command -v docker &>/dev/null; then
		echo "docker"
	else
		echo "No container engine found. The supported ones are: docker, podman."
		exit 1
	fi
}

remove_container() {
	"${CONTAINER_ENGINE}" rm -f "${CONTAINER_NAME}" "$@"
}

run_in_container() {
	echo "+ $@"
	"${CONTAINER_ENGINE}" exec "${CONTAINER_NAME}" "$@"
}

CONTAINER_ENGINE=${CONTAINER_ENGINE:-$(detect_container_engine)}
CONTAINER_NAME=${CONTAINER_NAME:-"crossdev"}
CONTAINER_URI=${CONTAINER_URI:-"docker.io/gentoo/stage3"}
CONTAINER_TAG="latest"
EMERGE_SYSTEM=1
TOPDIR=$(git rev-parse --show-toplevel)
unset PROFILE

remove_container || true
trap "remove_container" EXIT

while [[ $# -gt 0 ]]; do
	case $1 in
		-h|--help)
			print_help
			exit 0
			;;
		--profile)
			PROFILE="$2"
			shift 2
			;;
		--skip-system)
			EMERGE_SYSTEM=0
			shift 1
			;;
		--tag)
			CONTAINER_TAG="$2"
			shift 2
			;;
		--target)
			TARGET="$2"
			shift 2
			;;
		*)
			echo "Unknown option: $1"
			print_help
			exit 1
			;;
	esac
done

"${CONTAINER_ENGINE}" run -d \
	--name "${CONTAINER_NAME}" \
	-v "${TOPDIR}:/workspace" \
	-w /workspace \
	"${CONTAINER_URI}:${CONTAINER_TAG}" \
	/bin/sleep inf

run_in_container emerge-webrsync
run_in_container getuto
run_in_container emerge --getbinpkg app-eselect/eselect-repository sys-apps/config-site
run_in_container make install
run_in_container eselect repository create crossdev
run_in_container crossdev --show-fail-log --target "${TARGET}" ${PROFILE+--profile "${PROFILE}"}
if [[ "${EMERGE_SYSTEM}" -eq 1 ]]; then
	run_in_container "${TARGET}-emerge" @system
fi
