#!/usr/bin/env bash
set -euo pipefail

OUT_LINK=$1
INSTALL_DIR=$2

NIX_EXPR=$(
	cat <<'DERIVATION'
let
  nixpkgsRev = "0213ccf6243a63c34b72e6a2ef4d9140a4d86540";
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${nixpkgsRev}.tar.gz";
    sha256 = "0vl73i4qxg3whdnwzyfkamcbp585imxxaca55lg72br252bkhjcq";
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
