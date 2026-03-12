{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  pkgs-unstable = import inputs.nixpkgs-unstable {system = pkgs.stdenv.system;};

  state_dir = config.env.DEVENV_STATE;

  mix_dir = "${state_dir}/mix";
  hex_dir = "${state_dir}/hex";

  cfg = config.modules.elixir;
in {
  options = {
    modules.elixir = {
      enable = mkEnableOption "Rust development";

      package = mkOption {
        type = types.package;
        default = pkgs.elixir;
        defaultText = literalMD "pkgs.elixir";
        description = "The Elixir package to use";
      };

      erlang = {
        package = mkOption {
          type = types.package;
          default = pkgs.erlang;
          defaultText = literalMD "pkgs.erlang";
          description = "The Erlang package to use";
        };
      };

      phoenix = {
        enable = mkEnableOption "Enable phoenix development";
      };
    };
  };

  config = mkIf cfg.enable {
    packages = lists.optionals cfg.phoenix.enable [pkgs.watchman pkgs.inotify-tools] ++ [cfg.package cfg.erlang.package pkgs.wxGTK33 pkgs.emacs-lsp-booster];

    env.ERL_AFLAGS = "-kernel shell_history enabled -kernel shell_history_path '\"${state_dir}/erlang-history\"'";

    enterShell = ''
      mkdir -p ${mix_dir}/bin
      mkdir -p ${mix_dir}/escripts
      mkdir -p ${hex_dir}/bin

      export PATH="${mix_dir}/bin:${mix_dir}/escripts:${hex_dir}/bin:$PATH"
    '';

    env.MIX_TAILWINDCSS_PATH = mkIf cfg.phoenix.enable "${pkgs.tailwindcss_4}/bin/tailwindcss";
    env.MIX_ESBUILD_PATH = mkIf cfg.phoenix.enable "${pkgs.esbuild}/bin/esbuild";
    env.MIX_PRETTIER_PATH = mkIf cfg.phoenix.enable "${pkgs.prettier}/bin/prettier";

    env.MIX_HOME = mix_dir;
    env.HEX_HOME = hex_dir;

    env.ERL_LIBS = "${hex_dir}/lib/erlang/lib";
  };
}
