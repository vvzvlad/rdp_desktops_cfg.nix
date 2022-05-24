{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/22.05";
  inputs.home-manager.url = "gitlab:rycee/home-manager/release-22.05";
  outputs = { self, nixpkgs, home-manager }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [ ./configuration.nix ];
      specialArgs.inputs = inputs;
      system = "x86_64-linux";
    };
  };
}
