#!/usr/bin/env bash
set -euo pipefail

OUT_LINK=$1
INSTALL_DIR=$2

NIX_EXPR=$(
	cat <<'DERIVATION'
let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/release-19.03.tar.gz"; 
    sha256 = "1id874rh5gsgnl5hdhmhidbrb0cl9qidk00r3jkhki3rpk4jfd75";
  };
  pkgs = import nixpkgs {};
in
pkgs.buildEnv {
  name = "esy-glfw-env";
  paths = with pkgs; [ 
    glfw3 
    libGL
    mesa_glu
    xorg.xorgproto
    xorg.libX11 xorg.libX11.dev
    xorg.libXrandr xorg.libXrandr.dev 
    xorg.libXinerama xorg.libXinerama.dev 
    xorg.libXcursor xorg.libXcursor.dev
    xorg.libXi xorg.libXi.dev
    xorg.libXrender xorg.libXrender.dev
    xorg.libXxf86vm
  ];
  postBuild = ''
    cp $out/lib/libglfw.so $out/lib/libglfw3.so
    cp $out/lib/libglfw.so.3 $out/lib/libglfw3.so.3
    cp $out/lib/libglfw.so.3.2 $out/lib/libglfw3.so.3.2
  '';
}
DERIVATION
)

/run/current-system/sw/bin/nix-build \
	--expr "$NIX_EXPR" \
	--out-link "$OUT_LINK"

ln -sv "$(readlink -f "$OUT_LINK")/include" "$INSTALL_DIR/include"
rm -r "$INSTALL_DIR/lib"   # assuming this is empty
ln -sv "$(readlink -f "$OUT_LINK")/lib" "$INSTALL_DIR" # NOTE: ln -sf won't overwrite a directory
