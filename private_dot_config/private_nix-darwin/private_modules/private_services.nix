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

    /*
      mpd = {
        serviceConfig = {
          ProgramArguments = [
            "${pkgs.mpd}/bin/mpd"
            "--no-daemon"
            "--verbose"
            "${home-dir}/.config/mpd/mpd.conf"
          ];
          ProcessType = "Interactive";
          RunAtLoad = true;
          KeepAlive = true;
          StandardErrorPath = "/tmp/mpd.stderr.log";
          StandardOutPath = "/tmp/mpd.stdout.log";
        };
      };

      mpd-idle = {
        serviceConfig = {
          ProcessType = "Background";
          RunAtLoad = true;
          KeepAlive = true;
        };

        script = ''
          while true; do
            ${pkgs.mpc}/bin/mpc idle
            ${pkgs.sketchybar}/bin/sketchybar --trigger mpd_idle
          done
        '';
      };
    */
  };
}
