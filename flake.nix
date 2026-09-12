{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});

      docs = [
        {
          name = "cpprefjp";
          data = "https://cpprefjp.github.io/index.html";
        }
        {
          name = "acl";
          data = "https://atcoder.github.io/ac-library/production/document_ja";
        }
        {
          name = "live_library";
          data = "https://github.com/atcoder/live_library/blob/master/README.md";
        }
      ];
    in
    {
      devShells = forAllSystems (
        pkgs:
        let
          acl =
            with pkgs;
            (ac-library.overrideAttrs (old: {
              doCheck = stdenv.hostPlatform.isLinux;
              doInstallCheck = stdenv.hostPlatform.isLinux;
            })).dev;
        in
        {
          default = pkgs.mkShellNoCC {
            packages =
              with pkgs;
              [
                acl
              ]
              # ドキュメントを開くスクリプト
              ++ (map (
                doc:
                writeShellApplication {
                  inherit (doc) name;
                  runtimeInputs = [ xdg-utils ];
                  text = ''xdg-open "${doc.data}"'';
                }
              ) docs);

            CPLUS_INCLUDE_PATH = pkgs.lib.concatStringsSep ":" [
              "${acl}/include"
              ".include"
            ];

            shellHook = ''
              export ROOT=$(pwd)
            '';
          };
        }
      );
    };
}
