#!/usr/bin/env bash

get_latest_release() {
  if [[ -z "${GHTOKEN}" ]]; then
    echo "err"
    return 1
  fi
  curl -H "Authorization: token ${GHTOKEN}" --silent \
    "https://api.github.com/repos/$1/releases/latest" |
    grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

CURRENT_VER=$(TYPEPHP_HOME="${HOME}/Downloads/tpc" tpc --version | cut -d' ' -f 4)
echo ""
echo "Getting the version of the latest release archive of TypePHP..."
echo ""
LATEST=$(get_latest_release "swoole/typephp")

if [[ "${LATEST}" == "err" ]]; then
  echo "Provide the Github access token!"
  exit 1
elif [[ -z "${LATEST}" ]]; then
  echo "Error while getting repository info from Github!"
  exit 1
fi

if [[ ! "${LATEST}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Got incorrect version format: ${LATEST}, should be: vX.Y.Z."
  exit 1
fi

if [[ "${LATEST}" == "${CURRENT_VER}" ]]; then
  echo "Already using the latest version: ${CURRENT_VER}"
  exit
fi

if [[ -z "${PHP_HOME}" ]]; then
  export PHP_HOME="${HOME}/repos/php-build"
elif [[ -z "${PHPX_HOME}" ]]; then
  export PHPX_HOME="${HOME}/repos/phpx"
fi

if [[ -z "${1}" ]]; then
  export SEL_CMP="clang"
  echo "Going with default compiler: ${SEL_CMP}"
  echo ""
else
  if [[ "${1}" != "clang" && "${1}" != "gcc" ]]; then
    echo "Provided compiler is not supported"
    exit 1
  else
    export SEL_CMP="${1}"
    echo "Going with compiler: ${SEL_CMP}"
  fi
fi

export CFLAGS="-O3 -march=native -mtune=native"
export CXXFLAGS="-O3 -march=native -mtune=native"

export CC="ccache ${SEL_CMP}"
export CXX="ccache ${SEL_CMP}++"

echo "Updating from ${CURRENT_VER} to ${LATEST}..."
echo ""

echo "Pulling/Cloning PHPX..."
echo ""
if [[ ! -d "${PHPX_HOME}" ]]; then
  cd "${HOME}/repos"
  git clone "https://github.com/swoole/phpx.git"
  cd phpx || exit
else
  cd "${PHPX_HOME}" || exit
  git pull
fi

echo "Compiling PHPX..."
echo ""
cmake -S ./ -B ./build \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_TESTS=OFF \
  -DCMAKE_C_FLAGS="-O3 -march=native -mtune=native" \
  -DCMAKE_CXX_FLAGS="-O3 -march=native -mtune=native" \
  -DCMAKE_C_COMPILER="${SEL_CMP}" \
  -DCMAKE_CXX_COMPILER="${SEL_CMP}++" \
  -DCMAKE_C_COMPILER_LAUNCHER=ccache \
  -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
  -Dphp_dir="${PHP_HOME}"

mold -run cmake --build ./build --parallel "$(nproc)" --target phpx

echo "Checking PHPX shared library for existence..."
test -f "${PHPX_HOME}/lib/libphpx.so" || exit
echo -n "Looks OK..."
echo ""

cd "${HOME}" || exit

URL="https://github.com/swoole/typephp/releases/download/${LATEST}/tpc_${LATEST}_linux_x64.tar.gz"
FILE="tpc_${LATEST}.tar.gz"

echo "Downloading tpc release archive from Github..."
wget "${URL}" -qO "${HOME}/Downloads/${FILE}"

if [[ -f "${HOME}/Downloads/${FILE}" ]]; then
  cd "${HOME}/Downloads"
  if [[ -d "tpc" ]]; then
    mv tpc "tpc.bak"
  fi
  mkdir tpc
  tar -xzf "${FILE}" -C tpc --strip-components=1
fi

if [[ -f "${HOME}/Downloads/tpc/tpc" ]]; then
  echo "tpc updated!"
fi
