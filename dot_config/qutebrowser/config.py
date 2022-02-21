from qutebrowser.config.configfiles import ConfigAPI

config: ConfigAPI = config


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
    medium = 12
    large = 14
    web = 17


config.load_autoconfig(False)

# Key bindings
config.unbind("d")
config.unbind("J")
config.unbind("K")
config.bind(";r", "hint all right-click")
config.bind("<Shift+Escape>", ":fake-key <Escape>")
config.bind("<Shift+j>", "scroll-px 0 50")
config.bind("<Shift+k>", "scroll-px 0 -50")
config.bind("g[", "tab-prev")
config.bind("g]", "tab-next")
config.bind("gc", "tab-close")

config.set("auto_save.session", True)
config.set("completion.shrink", True)
config.set("confirm_quit", ["multiple-tabs", "downloads"])
config.set("content.notifications.enabled", True, "https://web.whatsapp.com/")
config.set(
    "content.tls.certificate_errors", "load-insecurely", "https://127.0.0.1:8384/"
)
config.set("editor.command", ["foot", "-e", "nvim", "{file}"])
config.set(
    "url.searchengines",
    {
        "DEFAULT": "https://duckduckgo.com/?q={}",
        "arch": "https://wiki.archlinux.org/?search={}",
        "crunch": "https://www.crunchbase.com/textsearch?q={}",
        "define": "https://dictionary.cambridge.org/search/direct/?datasetsearch=english&q={}",
    },
)

# Fonts
fonts = Fonts()

config.set("fonts.default_family", fonts.fixed)
config.set("fonts.default_size", f"{fonts.medium}pt")
config.set("fonts.tabs.selected", f"{fonts.large}pt {fonts.sans}")
config.set("fonts.tabs.unselected", f"{fonts.large}pt {fonts.sans}")
config.set("fonts.web.family.fixed", fonts.fixed)
config.set("fonts.web.family.sans_serif", fonts.sans)
config.set("fonts.web.family.serif", fonts.sans)
config.set("fonts.web.family.standard", fonts.sans)
config.set("fonts.web.size.default", fonts.web)
config.set("fonts.web.size.default_fixed", fonts.medium)

# Colors
colors = Colors()

config.set("colors.completion.fg", colors.white)
config.set("colors.completion.odd.bg", colors.black)
config.set("colors.completion.even.bg", colors.black)

config.set("colors.completion.category.fg", colors.magenta)
config.set("colors.completion.category.bg", colors.black)
config.set("colors.completion.category.border.top", colors.black)
config.set("colors.completion.category.border.bottom", colors.black)

config.set("colors.completion.item.selected.fg", colors.black)
config.set("colors.completion.item.selected.bg", colors.yellow)
config.set("colors.completion.item.selected.border.top", colors.yellow)
config.set("colors.completion.item.selected.border.bottom", colors.yellow)
config.set("colors.completion.item.selected.match.fg", colors.magenta)

config.set("colors.completion.match.fg", colors.magenta)
config.set("colors.completion.scrollbar.fg", colors.magenta)
config.set("colors.completion.scrollbar.bg", colors.black)

config.set("colors.contextmenu.disabled.fg", colors.light_black)
config.set("colors.contextmenu.disabled.bg", colors.black)
config.set("colors.contextmenu.menu.fg", colors.white)
config.set("colors.contextmenu.menu.bg", colors.black)
config.set("colors.contextmenu.selected.fg", colors.black)
config.set("colors.contextmenu.selected.bg", colors.blue)

config.set("colors.downloads.bar.bg", colors.black)
config.set("colors.downloads.start.fg", colors.black)
config.set("colors.downloads.start.bg", colors.magenta)
config.set("colors.downloads.stop.fg", colors.black)
config.set("colors.downloads.stop.bg", colors.blue)
config.set("colors.downloads.error.fg", colors.black)

config.set("hints.border", f"1px solid {colors.yellow}")
config.set("colors.hints.fg", colors.black)
config.set("colors.hints.bg", colors.yellow)
config.set("colors.hints.match.fg", colors.red)

config.set("colors.keyhint.suffix.fg", colors.magenta)
config.set("colors.keyhint.fg", colors.magenta)
config.set("colors.keyhint.bg", colors.black)

config.set("colors.messages.error.fg", colors.black)
config.set("colors.messages.error.bg", colors.red)
config.set("colors.messages.error.border", colors.red)

config.set("colors.messages.warning.fg", colors.black)
config.set("colors.messages.warning.bg", colors.yellow)
config.set("colors.messages.warning.border", colors.yellow)

config.set("colors.messages.info.fg", colors.magenta)
config.set("colors.messages.info.bg", colors.black)
config.set("colors.messages.info.border", colors.black)

config.set("colors.prompts.fg", colors.white)
config.set("colors.prompts.bg", colors.black)
config.set("colors.prompts.border", colors.black)
config.set("colors.prompts.selected.fg", colors.magenta)
config.set("colors.prompts.selected.bg", colors.green)

config.set("colors.statusbar.normal.fg", colors.magenta)
config.set("colors.statusbar.normal.bg", colors.black)
config.set("colors.statusbar.insert.fg", colors.blue)
config.set("colors.statusbar.insert.bg", colors.black)
config.set("colors.statusbar.passthrough.fg", colors.green)
config.set("colors.statusbar.passthrough.bg", colors.black)
config.set("colors.statusbar.private.fg", colors.cyan)
config.set("colors.statusbar.private.bg", colors.black)

config.set("colors.statusbar.command.fg", colors.white)
config.set("colors.statusbar.command.bg", colors.black)
config.set("colors.statusbar.command.private.fg", colors.cyan)
config.set("colors.statusbar.command.private.bg", colors.red)

config.set("colors.statusbar.caret.fg", colors.magenta)
config.set("colors.statusbar.caret.bg", colors.black)
config.set("colors.statusbar.caret.selection.fg", colors.magenta)
config.set("colors.statusbar.caret.selection.bg", colors.black)

config.set("colors.statusbar.progress.bg", colors.magenta)

config.set("colors.statusbar.url.fg", colors.magenta)
config.set("colors.statusbar.url.hover.fg", colors.green)
config.set("colors.statusbar.url.success.http.fg", colors.yellow)
config.set("colors.statusbar.url.success.https.fg", colors.white)
config.set("colors.statusbar.url.warn.fg", colors.yellow)
config.set("colors.statusbar.url.error.fg", colors.red)

config.set("colors.tabs.bar.bg", colors.black)

config.set("colors.tabs.indicator.start", colors.magenta)
config.set("colors.tabs.indicator.stop", colors.blue)
config.set("colors.tabs.indicator.error", colors.red)

config.set("colors.tabs.odd.fg", colors.white)
config.set("colors.tabs.odd.bg", colors.black)
config.set("colors.tabs.even.fg", colors.white)
config.set("colors.tabs.even.bg", colors.black)

config.set("colors.tabs.pinned.even.fg", colors.white)
config.set("colors.tabs.pinned.even.bg", colors.black)
config.set("colors.tabs.pinned.odd.fg", colors.white)
config.set("colors.tabs.pinned.odd.bg", colors.black)

config.set("colors.tabs.pinned.selected.even.fg", colors.black)
config.set("colors.tabs.pinned.selected.even.bg", colors.blue)
config.set("colors.tabs.pinned.selected.odd.fg", colors.black)
config.set("colors.tabs.pinned.selected.odd.bg", colors.blue)

config.set("colors.tabs.selected.odd.fg", colors.black)
config.set("colors.tabs.selected.odd.bg", colors.blue)
config.set("colors.tabs.selected.even.fg", colors.black)
config.set("colors.tabs.selected.even.bg", colors.blue)

config.set("colors.webpage.bg", colors.white)
