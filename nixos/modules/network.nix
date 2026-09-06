{pkgs, ...}:

{
  networking.hostName = "workstation";
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.networkmanager.enable = true;
  users.users.aristide.extraGroups = [ "networkmanager" ];

  environment.systemPackages = with pkgs; [
       wget
       curl
       wireshark-cli
       zrok
  ];
}
