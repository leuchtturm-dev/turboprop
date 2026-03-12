{
  pkgs,
  config,
  inputs,
  ...
}: let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.system;
    config.allowUnfree = true;
  };

  state_dir = config.env.DEVENV_STATE;
in {
  imports = [
    ./modules/elixir.nix
  ];

  modules.elixir = {
    enable = true;
    package = pkgs-unstable.elixir_1_19;

    erlang.package = pkgs-unstable.erlang_28;

    phoenix.enable = true;
  };
}
