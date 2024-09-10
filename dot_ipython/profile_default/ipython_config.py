c = get_config()  # type:ignore[name-defined]

c.InteractiveShellApp.extensions = ["rich"]
c.TerminalIPythonApp.display_banner = True
c.TerminalInteractiveShell.editing_mode = "vi"
