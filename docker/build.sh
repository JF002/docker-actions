#!/bin/bash
(return 0 2>/dev/null) && SOURCED="true" || SOURCED="false"
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
set -x
set -e

# Default locations if the var isn't already set
export TOOLS_DIR="${TOOLS_DIR:=/opt}"
export SOURCES_DIR="${SOURCES_DIR:=.}"
export BUILD_DIR="${BUILD_DIR:=$SOURCES_DIR/build}"
export OUTPUT_DIR="${OUTPUT_DIR:=$BUILD_DIR/output}"

export BUILD_TYPE=${BUILD_TYPE:=Release}

MACHINE="$(uname -m)"
[[ "$MACHINE" == "arm64" ]] && MACHINE="aarch64"

main() {
  local target="$1"

  mkdir -p "$TOOLS_DIR"

  mkdir -p "$BUILD_DIR"

  CmakeGenerate
  CmakeBuild $target
  BUILD_RESULT=$?
}

CmakeGenerate() {
  # We can swap the CD and trailing SOURCES_DIR for -B and -S respectively
  # once we go to newer CMake (Ubuntu 18.10 gives us CMake 3.10)
  cd "$BUILD_DIR"

  cmake -G "Unix Makefiles" \
    -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
    "$SOURCES_DIR"
  cmake -L -N .
}

CmakeBuild() {
  local target="$1"
  [[ -n "$target" ]] && target="--target $target"
  if cmake --build "$BUILD_DIR" --config $BUILD_TYPE $target -- -j$(nproc)
    then return 0; else return 1;
  fi
}

[[ $SOURCED == "false" ]] && main "$@" || echo "Sourced!"