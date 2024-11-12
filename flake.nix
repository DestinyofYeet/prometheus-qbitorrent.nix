{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
    pname = "qbittorrent-prometheus-exporter";
  in {

    packages.x86_64-linux.${pname} = pkgs.buildGoModule {
      name = "Qbittorrent prometheus exporter";
      pname = pname;

      vendorHash = "sha256-Zz8INxhVTHis0KiJB7NTP+JMOGbL6q59Qapfo5gstwI=";

      src = pkgs.fetchFromGitHub {
        owner = "martabal";
        repo = "qbittorrent-exporter";
        rev = "a4890b245cf383a679b9315d916645a9000fe240";
        sha256 = "sha256-WViMLjdR9MoUa7bEpbG9ew1N4TnermW45HDIGFjHCdE=";
      } + "/src";
    };

    packages.x86_64-linux.default = self.packages.x86_64-linux.${pname};

    nixosModules.${pname} = import ./module.nix self pname;

    nixosModules.default = self.nixosModules.${pname};

    hydraJobs = {
      inherit (self) packages;
    };
  };
}
