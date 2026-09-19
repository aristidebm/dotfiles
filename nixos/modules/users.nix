{pkgs, ...}:

{
   users = {
     # I want to still be able to use useradd, groupadd and passwd
     # on my system
     mutableUsers = true;
     users = {
     aristide = {
         # Define a user account.
         # Don't forget to set a password with ‘passwd’.
         isNormalUser = true;
         description = "Main User Account";
         extraGroups = [ "wheel" ];
         linger = true;
         shell = pkgs.zsh;
       };
     };
   };
}
