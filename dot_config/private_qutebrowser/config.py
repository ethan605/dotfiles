from qutebrowser.config.configfiles import ConfigAPI  # noqa: F401
from qutebrowser.config.config import ConfigContainer  # noqa: F401
config: ConfigAPI = config  # noqa: F821 pylint: disable=E0602,C0103
c: ConfigContainer = c  # noqa: F821 pylint: disable=E0602,C0103


class Colors:
    black = "#282a36"
    light_black = "#686868"
    red = "#ff5c57"
    green = "#5af78e"
    yellow = "#f3f99d"
    blue = "#57c7ff"
    magenta = "#ff6ac1"
    cyan = "#9aedfe"
    white = "#eff0eb"


class Fonts:
    sans = "Cantarell"
    fixed = "OperatorMonoLig Nerd Font"
    small = "10pt"
    medium = "12pt"
    large = "14pt"


config.load_autoconfig(False)

# Key bindings
config.bind("d", "nop")
config.bind("gc", "tab-close")
config.bind("g[", "tab-prev")
config.bind("g]", "tab-next")
config.bind("yl", "yank pretty-url")

c.auto_save.session = True
c.completion.shrink = True
c.confirm_quit = ["multiple-tabs", "downloads"]
c.editor.command = ["foot", "-e", "nvim", "{file}"]
c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "arch": "https://wiki.archlinux.org/?search={}",
    "crunch": "https://www.crunchbase.com/textsearch?q={}",
    "define": "https://dictionary.cambridge.org/search/direct/?datasetsearch=english&q={}",
}

# Fonts
fonts = Fonts()

c.fonts.completion.entry = f"{fonts.medium} {fonts.fixed}"
c.fonts.completion.category = f"bold {fonts.medium} {fonts.fixed}"
c.fonts.debug_console = f"{fonts.medium} {fonts.fixed}"
c.fonts.downloads = f"{fonts.medium} {fonts.fixed}"
c.fonts.hints = f"{fonts.medium} {fonts.fixed}"
c.fonts.keyhint = f"{fonts.medium} {fonts.fixed}"
c.fonts.prompts = f"{fonts.large} {fonts.sans}"
c.fonts.statusbar = f"{fonts.medium} {fonts.fixed}"
c.fonts.messages.error = f"{fonts.medium} {fonts.fixed}"
c.fonts.messages.info = f"{fonts.medium} {fonts.fixed}"
c.fonts.messages.warning = f"{fonts.medium} {fonts.fixed}"
c.fonts.tabs.selected = f"{fonts.large} {fonts.sans}"
c.fonts.tabs.unselected = f"{fonts.large} {fonts.sans}"
c.fonts.web.family.fixed = fonts.fixed
c.fonts.web.family.sans_serif = fonts.sans
c.fonts.web.family.serif = fonts.sans

# Colors
colors = Colors()

c.colors.completion.fg = colors.white
c.colors.completion.odd.bg = colors.black
c.colors.completion.even.bg = colors.black

c.colors.completion.category.fg = colors.magenta
c.colors.completion.category.bg = colors.black
c.colors.completion.category.border.top = colors.black
c.colors.completion.category.border.bottom = colors.black

c.colors.completion.item.selected.fg = colors.black
c.colors.completion.item.selected.bg = colors.yellow
c.colors.completion.item.selected.border.top = colors.yellow
c.colors.completion.item.selected.border.bottom = colors.yellow
c.colors.completion.item.selected.match.fg = colors.magenta

c.colors.completion.match.fg = colors.magenta
c.colors.completion.scrollbar.fg = colors.magenta
c.colors.completion.scrollbar.bg = colors.black

c.colors.contextmenu.disabled.fg = colors.light_black
c.colors.contextmenu.disabled.bg = colors.black
c.colors.contextmenu.menu.fg = colors.white
c.colors.contextmenu.menu.bg = colors.black
c.colors.contextmenu.selected.fg = colors.black
c.colors.contextmenu.selected.bg = colors.blue

c.colors.downloads.bar.bg = colors.black
c.colors.downloads.start.fg = colors.black
c.colors.downloads.start.bg = colors.magenta
c.colors.downloads.stop.fg = colors.black
c.colors.downloads.stop.bg = colors.blue
c.colors.downloads.error.fg = colors.black

c.colors.hints.fg = colors.black
c.colors.hints.bg = colors.green
c.colors.hints.match.fg = colors.magenta

c.colors.keyhint.suffix.fg = colors.magenta
c.colors.keyhint.fg = colors.magenta
c.colors.keyhint.bg = colors.black

c.colors.messages.error.fg = colors.black
c.colors.messages.error.bg = colors.red
c.colors.messages.error.border = colors.red

c.colors.messages.warning.fg = colors.black
c.colors.messages.warning.bg = colors.yellow
c.colors.messages.warning.border = colors.yellow

c.colors.messages.info.fg = colors.magenta
c.colors.messages.info.bg = colors.black
c.colors.messages.info.border = colors.black

c.colors.prompts.fg = colors.white
c.colors.prompts.bg = colors.black
c.colors.prompts.border = colors.black
c.colors.prompts.selected.fg = colors.magenta
c.colors.prompts.selected.bg = colors.green

c.colors.statusbar.normal.fg = colors.magenta
c.colors.statusbar.normal.bg = colors.black
c.colors.statusbar.insert.fg = colors.blue
c.colors.statusbar.insert.bg = colors.black
c.colors.statusbar.passthrough.fg = colors.green
c.colors.statusbar.passthrough.bg = colors.black
c.colors.statusbar.private.fg = colors.cyan
c.colors.statusbar.private.bg = colors.black

c.colors.statusbar.command.fg = colors.white
c.colors.statusbar.command.bg = colors.black
c.colors.statusbar.command.private.fg = colors.cyan
c.colors.statusbar.command.private.bg = colors.red

c.colors.statusbar.caret.fg = colors.magenta
c.colors.statusbar.caret.bg = colors.black
c.colors.statusbar.caret.selection.fg = colors.magenta
c.colors.statusbar.caret.selection.bg = colors.black

c.colors.statusbar.progress.bg = colors.magenta

c.colors.statusbar.url.fg = colors.magenta
c.colors.statusbar.url.hover.fg = colors.green
c.colors.statusbar.url.success.http.fg = colors.yellow
c.colors.statusbar.url.success.https.fg = colors.white
c.colors.statusbar.url.warn.fg = colors.yellow
c.colors.statusbar.url.error.fg = colors.red

c.colors.tabs.bar.bg = colors.black

c.colors.tabs.indicator.start = colors.magenta
c.colors.tabs.indicator.stop = colors.blue
c.colors.tabs.indicator.error = colors.red

c.colors.tabs.odd.fg = colors.white
c.colors.tabs.odd.bg = colors.black
c.colors.tabs.even.fg = colors.white
c.colors.tabs.even.bg = colors.black

c.colors.tabs.pinned.even.fg = colors.white
c.colors.tabs.pinned.even.bg = colors.black
c.colors.tabs.pinned.odd.fg = colors.white
c.colors.tabs.pinned.odd.bg = colors.black

c.colors.tabs.pinned.selected.even.fg = colors.black
c.colors.tabs.pinned.selected.even.bg = colors.blue
c.colors.tabs.pinned.selected.odd.fg = colors.black
c.colors.tabs.pinned.selected.odd.bg = colors.blue

c.colors.tabs.selected.odd.fg = colors.black
c.colors.tabs.selected.odd.bg = colors.blue
c.colors.tabs.selected.even.fg = colors.black
c.colors.tabs.selected.even.bg = colors.blue

# c.colors.webpage.bg = colors.black
