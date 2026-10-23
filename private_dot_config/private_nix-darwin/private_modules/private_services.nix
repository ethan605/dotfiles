{ pkgs, home-dir, ... }:

{
  services.sketchybar.enable = true;

  launchd.user.agents = {
    aerospace = {
      serviceConfig = {
        ProcessType = "Background";
        ProgramArguments = [
          "/usr/bin/open"
          "-b"
          "bobko.aerospace"
        ];
        RunAtLoad = true;
        KeepAlive = false;
      };
    };

    # launchd lifecycle:
    #   - boot-up:    launchctl bootstrap     "gui/$(id -u)" ~/Library/LaunchAgents/org.nixos.caffeinate.plist
    #   - run:        launchctl kickstart -k  "gui/$(id -u)/org.nixos.caffeinate"
    #   - stop:       launchctl kill SIGINT   "gui/$(id -u)/org.nixos.caffeinate"
    #   - tear-down:  launchctl bootout       "gui/$(id -u)" ~/Library/LaunchAgents/org.nixos.caffeinate.plist
    caffeinate = {
      serviceConfig = {
        ProcessType = "Interactive";
        ProgramArguments = [
          "/usr/bin/caffeinate"
          "-dimsu"
        ];
        RunAtLoad = false;
        KeepAlive = false;
      };
    };

    mpd = {
      serviceConfig = {
        ProcessType = "Interactive";
        ProgramArguments = [
          "${pkgs.mpd}/bin/mpd"
          "--no-daemon"
          "--verbose"
          "${home-dir}/.config/mpd/mpd.conf"
        ];
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
  };
}
