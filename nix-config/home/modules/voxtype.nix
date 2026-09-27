{
  pkgs,
  voxtype,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
in

{
  # For more information on how to configure this, check
  # https://raw.githubusercontent.com/peteonrails/voxtype/refs/heads/dev/nix/home-manager-module.nix
  programs.voxtype = {
    # Do not install, this dependency is huge and cloning that https://github.com/openvinotoolkit/openvino
    # takes an eternity
    enable = false;
    package = voxtype.packages.${system}.vulkan;
    # Replace this by hugging face model directory
    model.path = /home/aristide/.cache/huggingface/hub/whisper/pytorch_model.bin;
    service.enable = true;
    settings = {
      hotkey = {
        enabled = false; # Use compositor key bindings
        # key = ""; only useful when enabled is true
      };
      whisper.language = ["en" "fr"];
    };
  };
}
