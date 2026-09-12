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
          atcoder-cli =
            let
              version = "2.2.0";
            in
            pkgs.buildNpmPackage {
              pname = "atcoder-cli";
              inherit version;
              src = pkgs.fetchFromGitHub {
                owner = "Tatamo";
                repo = "atcoder-cli";
                rev = "v${version}";
                hash = "sha256-7pbCTgWt+khKVyMV03HanvuOX2uAC0PL9OLmqly7IWE=";
              };
              npmDepsHash = "sha256-ufG7Fq5D2SOzUp8KYRYUB5tYJYoADuhK+2zDfG0a3ks=";
              npmFlags = [ "--ignore-scripts" ];
              NODE_OPTIONS = "--openssl-legacy-provider";
            };
        in
        {
          default = pkgs.mkShellNoCC {
            packages =
              with pkgs;
              [
                acl
                atcoder-cli
                online-judge-tools
                python3Packages.selenium
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
