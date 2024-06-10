{
  pkgs,
  ...
}:
{
  imports = [
    ./mutability.nix

    ./deployment
    ./development
    ./kubernetes
    ./security
    ./shell
  ];

  config = {
    home.stateVersion = "23.11";

    programs = {
      home-manager.enable = true;
    };

    xdg.enable = true;

    home.packages = [
      pkgs.home-manager
    ];
  };
}
