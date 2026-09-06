{pkgs, ...}:

{
   users.users = {
   # controls whether normal commands may change accounts, and turning it off means declaring a password hash as well.
   # mutableUsers = false;
   aristide = {
       # Define a user account. Don't forget to set a password with ‘passwd’.
       isNormalUser = true;
       description = "Owner";
       extraGroups = [ "wheel" ];
       shell = pkgs.zsh;
     };
   };
}
