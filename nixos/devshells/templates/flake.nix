{
  # Inspiration from https://github.com/NixOS/templates/tree/master
  description = "A collection of flake templates";
  outputs = { self, nixpkgs, ... }:
  {
      templates.python-uv = {
        description = "Python Template, using UV";
        path = ./python/uv;
        welcomeText = ''
 ____        _   _                   _____                    _       _
|  _ \ _   _| |_| |__   ___  _ __   |_   _|__ _ __ ___  _ __ | | __ _| |_ ___
| |_) | | | | __| '_ \ / _ \| '_ \    | |/ _ \ '_ ` _ \| '_ \| |/ _` | __/ _ \
|  __/| |_| | |_| | | | (_) | | | |   | |  __/ | | | | | |_) | | (_| | ||  __/
|_|    \__, |\__|_| |_|\___/|_| |_|   |_|\___|_| |_| |_| .__/|_|\__,_|\__\___|
       |___/                                           |_|

Run
$ nix develop
and you are good to go
Happy coding!
      '';
      };

      templates.python-poetry = {
        description = "Python Template, using Poetry";
        path = ./python/poetry;
        welcomeText = ''
 ____        _   _                   _____                    _       _
|  _ \ _   _| |_| |__   ___  _ __   |_   _|__ _ __ ___  _ __ | | __ _| |_ ___
| |_) | | | | __| '_ \ / _ \| '_ \    | |/ _ \ '_ ` _ \| '_ \| |/ _` | __/ _ \
|  __/| |_| | |_| | | | (_) | | | |   | |  __/ | | | | | |_) | | (_| | ||  __/
|_|    \__, |\__|_| |_|\___/|_| |_|   |_|\___|_| |_| |_| .__/|_|\__,_|\__\___|
       |___/                                           |_|

Run
$ nix develop
and you are good to go
Happy coding!
        '';
      };

      templates.rust = {
        description = "Rust Template";
        path = ./rust;
        welcomeText = ''
        '';
      };

      templates.go = {
        description = "Go Template";
        path = ./go;
        welcomeText = ''
  ____         _____                    _       _
 / ___| ___   |_   _|__ _ __ ___  _ __ | | __ _| |_ ___
| |  _ / _ \    | |/ _ \ '_ ` _ \| '_ \| |/ _` | __/ _ \
| |_| | (_) |   | |  __/ | | | | | |_) | | (_| | ||  __/
 \____|\___/    |_|\___|_| |_| |_| .__/|_|\__,_|\__\___|
                                 |_|
Run
$ nix develop
and you are good to go
Happy coding!
        '';
      };

      templates.typst = {
        description = "Typst Template";
        path = ./typst;
        welcomeText = ''
 _____                _     _____                    _       _
|_   _|   _ _ __  ___| |_  |_   _|__ _ __ ___  _ __ | | __ _| |_ ___
  | || | | | '_ \/ __| __|   | |/ _ \ '_ ` _ \| '_ \| |/ _` | __/ _ \
  | || |_| | |_) \__ \ |_    | |  __/ | | | | | |_) | | (_| | ||  __/
  |_| \__, | .__/|___/\__|   |_|\___|_| |_| |_| .__/|_|\__,_|\__\___|
      |___/|_|                                |_|

Run
$ nix develop
and you are good to go
Happy coding!
        '';
      };

      templates.latexmk = {
        description = "Latex Template";
        path = ./latexmk;
        welcomeText = ''
 _          _              _____                    _       _
| |    __ _| |_ _____  __ |_   _|__ _ __ ___  _ __ | | __ _| |_ ___
| |   / _` | __/ _ \ \/ /   | |/ _ \ '_ ` _ \| '_ \| |/ _` | __/ _ \
| |__| (_| | ||  __/>  <    | |  __/ | | | | | |_) | | (_| | ||  __/
|_____\__,_|\__\___/_/\_\   |_|\___|_| |_| |_| .__/|_|\__,_|\__\___|
                                             |_|
Run
$ nix develop
and you are good to go
Happy coding!
        '';
      };

      templates.typescript-pnpm = {
        description = "Go Template";
        path = ./typescript/pnpm;
        welcomeText = ''
 _____ ____    _____                    _       _
|_   _/ ___|  |_   _|__ _ __ ___  _ __ | | __ _| |_ ___
  | | \___ \    | |/ _ \ '_ ` _ \| '_ \| |/ _` | __/ _ \
  | |  ___) |   | |  __/ | | | | | |_) | | (_| | ||  __/
  |_| |____/    |_|\___|_| |_| |_| .__/|_|\__,_|\__\___|
                                 |_|
Run
$ nix develop
and you are good to go
Happy coding!
        '';
      };

      templates.typescript-bun = {
        description = "Go Template";
        path = ./typescript/pnpm;
        welcomeText = ''
 _____ ____    _____                    _       _
|_   _/ ___|  |_   _|__ _ __ ___  _ __ | | __ _| |_ ___
  | | \___ \    | |/ _ \ '_ ` _ \| '_ \| |/ _` | __/ _ \
  | |  ___) |   | |  __/ | | | | | |_) | | (_| | ||  __/
  |_| |____/    |_|\___|_| |_| |_| .__/|_|\__,_|\__\___|
                                 |_|
Run
$ nix develop
and you are good to go
Happy coding!
        '';
    };
 };
}
