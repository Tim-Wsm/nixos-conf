{pkgs, ...}: {
  # Some default packages for quick and dirty development. For proper
  # development use custom flakes with `nix develop`.
  environment.systemPackages = with pkgs; [
    # rust
    cargo
    rustc
    clippy
    rust-analyzer
    # c and c++
    gcc
    libgcc
    clang
    libclang
    clang-tools
    cmake
    gnumake
    # debgugging
    gdb
    valgrind
    # python
    python3
    python3Packages.virtualenv
    # ocaml
    ocaml
    opam
  ];
}
