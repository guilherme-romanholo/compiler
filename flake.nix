{
  inputs = {
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, systems, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = forEachSystem (system: {
        devenv-up = self.devShells.${system}.default.config.procfileScript;
      });

      devShells = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {
                  languages.c = {
                    enable = true;
                    debugger = pkgs.gdb;
                  };

                  # https://devenv.sh/reference/options/
                  packages = with pkgs; [ 
                    flex
                  ];

                  scripts.build = {
                    exec = "make; ./compiler < tests/code1; make clean";
                  };

                  enterShell = ''
                    printf "\033[96mWelcome to Compiler Project!\033[0m\n"
                    gcc --version | grep gcc
                    flex --version
                  '';
                }
              ];
            };
          });
    };
}
