     {
     description = "Flake Update";
   
     inputs = {
       nixpkgs.url = "nixpkgs/nixos-25.05";
	   home-manager.url = "github:nix-community/home-manager/release-25.05";
	   home-manager.inputs.nixpkgs.follows = "nixpkgs";
     };  
   
     outputs = {self, nixpkgs, home-manager,  ... }:
        let
          lib = nixpkgs.lib;
	  system = "x86_64-linux";
	  pkgs = nixpkgs.legacyPackages.${system};
        in {
        nixosConfigurations = {
          gary = lib.nixosSystem {
            inherit system;
            modules = [ 
              ./hosts/gary/configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = { hostname = "gary"; };
                home-manager.users.aristide = import ./home.nix;
              }
            ];
          };
          zola = lib.nixosSystem {
            inherit system;
            modules = [ 
              ./hosts/zola/configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = { hostname = "zola"; };
                home-manager.users.aristide = import ./home.nix;
              }
            ];
          };
          exupery = lib.nixosSystem {
            inherit system;
            modules = [ 
              ./hosts/exupery/configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = { hostname = "exupery"; };
                home-manager.users.aristide = import ./home.nix;
              }
            ];
          };
        };
		homeConfigurations = {
		  aristide = home-manager.lib.homeManagerConfiguration {
		    inherit pkgs;
		    modules = [ ./home.nix ];
		  };
    };
  };
}
