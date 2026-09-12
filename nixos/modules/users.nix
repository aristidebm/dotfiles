{pkgs, ...}:

{
   users.users = {
   # I don't want to share my password with the public even
   # if it is a hashed password so mutableUsers should be true
   # I will set the password manually is passwd
   mutableUsers = true;
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
}
