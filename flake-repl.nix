# Run `nix repl flake-repl.nix` to develop your flake.

builtins.getFlake (builtins.toPath ./.)
