{
    description = "Simple Qt OpenGL test project";

    inputs = {
        nixpkgs.url = github:NixOS/nixpkgs/nixos-22.11;
        utils.url = github:numtide/flake-utils;
    };

    outputs = attrs @ { self, nixpkgs, utils, ... }: utils.lib.eachDefaultSystem (system: rec {
        pkgs = import nixpkgs {
            inherit system;
        };

        packages = rec {
            default = view;

            view = pkgs.stdenv.mkDerivation rec {
                pname = "view";
                version = "1.00-" + (builtins.substring 0 8 (if (self ? rev) then self.rev else "dirty"));

                src = self;

                buildInputs = [
                    pkgs.cmake
                    pkgs.pkg-config
                    pkgs.qt5.qtbase
                    pkgs.ninja
                ];

                nativeBuildInputs = [
                    pkgs.breakpointHook
                    pkgs.qt5.wrapQtAppsHook
                ];

                cmakeFlags = [
                    # NOP
                ];
            };
        };

        devShells = rec {
            default = dev;

            # Main developer shell.
            dev = pkgs.mkShell rec {
                name = "dev";

                packages = [
                    pkgs.cntr
                ] ++ self.outputs.packages.${system}.view.buildInputs;

                nativeBuildInputs = [
                    pkgs.qt5.wrapQtAppsHook
                    pkgs.makeWrapper
                    pkgs.openssl
                ];

                shellHook = ''
                    export PS1='\n\[\033[1;36m\][${name}:\W]\$\[\033[0m\] '

                    # Bit of a weird one - Qt programs can't find plugin path unwrapped, so we make a temporary wrapper and source its env.
                    # See: https://discourse.nixos.org/t/python-qt-woes/11808/10
                    setQtEnvironment=$(mktemp)
                    random=$(openssl rand -base64 20 | sed "s/[^a-zA-Z0-9]//g")
                    makeWrapper "$(type -p sh)" "$setQtEnvironment" "''${qtWrapperArgs[@]}" --argv0 "$random"
                    sed "/$random/d" -i "$setQtEnvironment"
                    source "$setQtEnvironment"
                '';
            };
        };
    });
}
