#!/bin/bash

set -e

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

CONTAINER_ENGINE=${CONTAINER_ENGINE:-$(detect_container_engine)}
CONTAINER_NAME=${CONTAINER_NAME:-"crossdev"}
CONTAINER_URI=${CONTAINER_URI:-"docker.io/gentoo/stage3"}
CONTAINER_TAG="latest"
EMERGE_SYSTEM=1
LLVM=${LLVM:-0}
OVERLAY_REPO=${OVERLAY_REPO:-"https://github.com/gentoo-mirror/gentoo"}
OVERLAY_BRANCH=${OVERLAY_BRANCH:-"stable"}
TOPDIR=$(git rev-parse --show-toplevel)

print_help() {
	echo "Usage: $0 [SUBCOMMAND] [OPTIONS]
	
Subcommands:
	run      Run crossdev in a containerized environment.
	shell    Run shell in a containerized environment, useful for debugging.

Notes:
  - Ensure the container engine (docker or podman) is installed and available."
}

print_help_run() {
	echo "Usage: $0 run [OPTIONS]

Options:
	--llvm                Use LLVM/Clang as a cross compiler.
	--overlay-repo        URL of the overlay git repository.
	--overlay-branch      Branch of the overlay git repository.
  --skip-system         Skip emerging the @system set after setting up crossdev.
  --tag <tag>           Specify the container tag to use. Default is 'latest'.
  --target <target>     Specify the target architecture for crossdev. Required.
  -h, --help            Show this help message and exit.

Environment Variables:
  CONTAINER_ENGINE      Specify the container engine to use (docker or podman).
                        Default is detected automatically.
  CONTAINER_NAME        Name of the container instance. Default is 'crossdev'.
  CONTAINER_URI         URI of the container image. Default is 'docker.io/gentoo/stage3'.
  OVERLAY_REPO          URL of the overlay git repository.
  OVERLAY_BRANCH        Branch of the overlay git repository.

Examples:
  # Run with the default container and target architecture
  $0 run --target aarch64-unknown-linux-gnu

  # Run with a specific container tag and skip emerging @system
  $0 run --tag musl-llvm --target riscv64-unknown-linux-musl --skip-system

Notes:
  - You must specify a target using the --target option.
  - Ensure the container engine (docker or podman) is installed and available."
}

print_help_shell() {
	echo "Usage: $0 shell [OPTIONS]

Options:
	--overlay-repo        URL of the overlay git repository.
	--overlay-branch      Branch of the overlay git repository.
  --tag <tag>           Specify the container tag to use. Default is 'latest'.
  -h, --help            Show this help message and exit.

Environment Variables:
  CONTAINER_ENGINE      Specify the container engine to use (docker or podman).
                        Default is detected automatically.
  CONTAINER_NAME        Name of the container instance. Default is 'crossdev'.
  CONTAINER_URI         URI of the container image. Default is 'docker.io/gentoo/stage3'.
  OVERLAY_REPO          URL of the overlay git repository.
  OVERLAY_BRANCH        Branch of the overlay git repository.

Examples:
  # Run shell in the default container
  $0 shell

  # Run with a specific container tag
  $0 shell --tag musl-llvm

Notes:
  - You must specify a target using the --target option.
  - Ensure the container engine (docker or podman) is installed and available."
}

remove_container() {
	"${CONTAINER_ENGINE}" rm -f "${CONTAINER_NAME}" "$@"
}

start_container() {
	"${CONTAINER_ENGINE}" run -d \
		--name "${CONTAINER_NAME}" \
		-v "${TOPDIR}:/workspace" \
		-w /workspace \
		"${CONTAINER_URI}:${CONTAINER_TAG}" \
		/bin/sleep inf
}

run_in_container() {
	echo "+ $@"
	"${CONTAINER_ENGINE}" exec "${CONTAINER_NAME}" "$@"
}

install_crossdev() {
	run_in_container mkdir -p /var/db/repos/gentoo
	run_in_container bash -c "curl -L ${OVERLAY_REPO}/archive/${OVERLAY_BRANCH}.tar.gz | tar -xzf - --strip-components 1 -C /var/db/repos/gentoo"
	run_in_container emerge app-eselect/eselect-repository sys-apps/config-site	

	run_in_container make install
	run_in_container eselect repository create crossdev
}

run_crossdev() {
	EXTRA_ARGS=()
	if [[ "${LLVM}" -eq 1 ]]; then
		EXTRA_ARGS+=("--llvm")
	fi
	run_in_container crossdev "${EXTRA_ARGS[@]}" --show-fail-log --target "${TARGET}"
	
	if [[ "${EMERGE_SYSTEM}" -eq 1 ]]; then
		run_in_container "${TARGET}-emerge" @system
	fi
}

shell() {
	"${CONTAINER_ENGINE}" exec -it "${CONTAINER_NAME}" bash
}

remove_container || true
trap "remove_container" EXIT

case "$1" in
	run)
		shift 1
		while [[ $# -gt 0 ]]; do
			case $1 in
				-h|--help)
					print_help
					exit 0
					;;
				--llvm)
					LLVM=1
					shift 1
					;;
				--overlay-branch)
					OVERLAY_BRANCH="$2"
					shift 2
					;;
				--overlay-repo)
					OVERLAY_REPO="$2"
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
					print_help_run
					exit 1
					;;
			esac
		done

		start_container
		install_crossdev
		run_crossdev
		;;
	shell)
		shift 1
		while [[ $# -gt 0 ]]; do
			case $1 in
				-h|--help)
					print_help
					exit 0
					;;
				--overlay-branch)
					OVERLAY_BRANCH="$2"
					shift 2
					;;
				--overlay-repo)
					OVERLAY_REPO="$2"
					shift 2
					;;
				--tag)
					CONTAINER_TAG="$2"
					shift 2
					;;
				*)
					echo "Unknown"
					print_help_shell
					exit 1
			esac
		done

		start_container
		install_crossdev
		shell
		;;
	*)
		echo "Unknown command: $1"
		print_help
		exit 1
		;;
esac
