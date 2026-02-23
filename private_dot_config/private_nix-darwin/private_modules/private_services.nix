{ pkgs, home-dir, ... }:

{
  services.sketchybar.enable = true;

  launchd.user.agents = {
    aerospace = {
      serviceConfig = {
        ProgramArguments = [
          "/usr/bin/open"
          "-b"
          "bobko.aerospace"
        ];
        RunAtLoad = true;
        KeepAlive = false;
      };
    };

    mpd = {
      serviceConfig = {
        ProgramArguments = [
          "${pkgs.mpd}/bin/mpd"
          "--no-daemon"
          "${home-dir}/.config/mpd/mpd.conf"
        ];
        KeepAlive = true;
        RunAtLoad = true;
      };
    };

    mpd-idle = {
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
      };

      script = ''
        while true; do
          ${pkgs.mpc}/bin/mpc idle
          ${pkgs.sketchybar}/bin/sketchybar --trigger mpd_idle
        done
      '';
    };
  };
}
