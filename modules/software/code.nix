{pkgs, ...}: {
  # Some default packages for quick and dirty development. For proper
  # development use custom flakes with `nix develop`.
  environment.systemPackages = with pkgs; [
    # helpful tools
    cloc
    # rust
    cargo
    rustc
    clippy
    rust-analyzer
    rustfmt
    # c debgugging
    gdb
    valgrind
    # python
    python3
    python3Packages.virtualenv
    # ocaml
    ocaml
    opam
    # Isabelle/HOL
    isabelle
  ];
}
