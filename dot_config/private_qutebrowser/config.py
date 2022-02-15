from qutebrowser.config.configfiles import ConfigAPI  # noqa: F401
from qutebrowser.config.config import ConfigContainer  # noqa: F401
config: ConfigAPI = config  # noqa: F821 pylint: disable=E0602,C0103
c: ConfigContainer = c  # noqa: F821 pylint: disable=E0602,C0103

config.load_autoconfig(False)
c.auto_save.session = True
c.completion.shrink = True
c.fonts.statusbar = "12 Cantarell"


class Colors:
    black = "#282a36"
    red = "#ff5c57"
    green = "#5af78e"
    yellow = "#f3f99d"
    blue = "#57c7ff"
    magenta = "#ff6ac1"
    cyan = "#9aedfe"
    white = "#eff0eb"


colors = Colors()

# Text color of the completion widget. May be a single color to use for
# all columns or a list of three colors, one for each column.
c.colors.completion.fg = colors.magenta

# Background color of the completion widget for odd rows.
c.colors.completion.odd.bg = colors.black

# Background color of the completion widget for even rows.
c.colors.completion.even.bg = colors.black

# Foreground color of completion widget category headers.
c.colors.completion.category.fg = colors.magenta

# Background color of the completion widget category headers.
c.colors.completion.category.bg = colors.black

# Top border color of the completion widget category headers.
c.colors.completion.category.border.top = colors.black

# Bottom border color of the completion widget category headers.
c.colors.completion.category.border.bottom = colors.black

# Foreground color of the selected completion item.
c.colors.completion.item.selected.fg = colors.magenta

# Background color of the selected completion item.
c.colors.completion.item.selected.bg = colors.green

# Top border color of the selected completion item.
c.colors.completion.item.selected.border.top = colors.green

# Bottom border color of the selected completion item.
c.colors.completion.item.selected.border.bottom = colors.green

# Foreground color of the matched text in the selected completion item.
c.colors.completion.item.selected.match.fg = colors.magenta

# Foreground color of the matched text in the completion.
c.colors.completion.match.fg = colors.red

# Color of the scrollbar handle in the completion view.
c.colors.completion.scrollbar.fg = colors.magenta

# Color of the scrollbar in the completion view.
c.colors.completion.scrollbar.bg = colors.black

# Background color of disabled items in the context menu.
c.colors.contextmenu.disabled.bg = colors.red

# Foreground color of disabled items in the context menu.
c.colors.contextmenu.disabled.fg = colors.blue

# Background color of the context menu. If set to null, the Qt default is used.
c.colors.contextmenu.menu.bg = colors.black

# Foreground color of the context menu. If set to null, the Qt default is used.
c.colors.contextmenu.menu.fg = colors.magenta

# Background color of the context menu’s selected item.
# If set to null, the Qt default is used.
c.colors.contextmenu.selected.bg = colors.green

# Foreground color of the context menu’s selected item.
# If set to null, the Qt default is used.
c.colors.contextmenu.selected.fg = colors.magenta

# Background color for the download bar.
c.colors.downloads.bar.bg = colors.black

# Color gradient start for download text.
c.colors.downloads.start.fg = colors.black

# Color gradient start for download backgrounds.
c.colors.downloads.start.bg = colors.magenta

# Color gradient end for download text.
c.colors.downloads.stop.fg = colors.black

# Color gradient stop for download backgrounds.
c.colors.downloads.stop.bg = colors.blue

# Foreground color for downloads with errors.
c.colors.downloads.error.fg = colors.black

# Font color for hints.
c.colors.hints.fg = colors.black

# Background color for hints. Note that you can use a `rgba(...)` value
# for transparency.
c.colors.hints.bg = colors.green

# Font color for the matched part of hints.
c.colors.hints.match.fg = colors.magenta

# Text color for the keyhint widget.
c.colors.keyhint.fg = colors.magenta

# Highlight color for keys to complete the current keychain.
c.colors.keyhint.suffix.fg = colors.magenta

# Background color of the keyhint widget.
c.colors.keyhint.bg = colors.black

# Foreground color of an error message.
c.colors.messages.error.fg = colors.black

# Background color of an error message.
c.colors.messages.error.bg = colors.black

# Border color of an error message.
c.colors.messages.error.border = colors.black

# Foreground color of a warning message.
c.colors.messages.warning.fg = colors.black

# Background color of a warning message.
c.colors.messages.warning.bg = colors.cyan

# Border color of a warning message.
c.colors.messages.warning.border = colors.cyan

# Foreground color of an info message.
c.colors.messages.info.fg = colors.magenta

# Background color of an info message.
c.colors.messages.info.bg = colors.black

# Border color of an info message.
c.colors.messages.info.border = colors.black

# Foreground color for prompts.
c.colors.prompts.fg = colors.magenta

# Border used around UI elements in prompts.
c.colors.prompts.border = colors.black

# Background color for prompts.
c.colors.prompts.bg = colors.black

# Background color for the selected item in filename prompts.
c.colors.prompts.selected.bg = colors.green

# Foreground color for the selected item in filename prompts.
c.colors.prompts.selected.fg = colors.magenta

# Foreground color of the statusbar.
c.colors.statusbar.normal.fg = colors.magenta

# Background color of the statusbar.
c.colors.statusbar.normal.bg = colors.black

# Foreground color of the statusbar in insert mode.
c.colors.statusbar.insert.fg = colors.blue

# Background color of the statusbar in insert mode.
c.colors.statusbar.insert.bg = colors.black

# Foreground color of the statusbar in passthrough mode.
c.colors.statusbar.passthrough.fg = colors.green

# Background color of the statusbar in passthrough mode.
c.colors.statusbar.passthrough.bg = colors.black

# Foreground color of the statusbar in private browsing mode.
c.colors.statusbar.private.fg = colors.cyan

# Background color of the statusbar in private browsing mode.
c.colors.statusbar.private.bg = colors.black

# Foreground color of the statusbar in command mode.
c.colors.statusbar.command.fg = colors.blue

# Background color of the statusbar in command mode.
c.colors.statusbar.command.bg = colors.red

# Foreground color of the statusbar in private browsing + command mode.
c.colors.statusbar.command.private.fg = colors.cyan

# Background color of the statusbar in private browsing + command mode.
c.colors.statusbar.command.private.bg = colors.red

# Foreground color of the statusbar in caret mode.
c.colors.statusbar.caret.fg = colors.magenta

# Background color of the statusbar in caret mode.
c.colors.statusbar.caret.bg = colors.black

# Foreground color of the statusbar in caret mode with a selection.
c.colors.statusbar.caret.selection.fg = colors.magenta

# Background color of the statusbar in caret mode with a selection.
c.colors.statusbar.caret.selection.bg = colors.black

# Background color of the progress bar.
c.colors.statusbar.progress.bg = colors.magenta

# Default foreground color of the URL in the statusbar.
c.colors.statusbar.url.fg = colors.magenta

# Foreground color of the URL in the statusbar on error.
c.colors.statusbar.url.error.fg = colors.black

# Foreground color of the URL in the statusbar for hovered links.
c.colors.statusbar.url.hover.fg = colors.red

# Foreground color of the URL in the statusbar on successful load
# (http).
c.colors.statusbar.url.success.http.fg = colors.yellow

# Foreground color of the URL in the statusbar on successful load
# (https).
c.colors.statusbar.url.success.https.fg = colors.yellow

# Foreground color of the URL in the statusbar when there's a warning.
c.colors.statusbar.url.warn.fg = colors.cyan

# Background color of the tab bar.
c.colors.tabs.bar.bg = colors.black

# Color gradient start for the tab indicator.
c.colors.tabs.indicator.start = colors.magenta

# Color gradient end for the tab indicator.
c.colors.tabs.indicator.stop = colors.blue

# Color for the tab indicator on errors.
c.colors.tabs.indicator.error = colors.black

# Foreground color of unselected odd tabs.
c.colors.tabs.odd.fg = colors.magenta

# Background color of unselected odd tabs.
c.colors.tabs.odd.bg = colors.black

# Foreground color of unselected even tabs.
c.colors.tabs.even.fg = colors.magenta

# Background color of unselected even tabs.
c.colors.tabs.even.bg = colors.black

# Background color of pinned unselected even tabs.
c.colors.tabs.pinned.even.bg = colors.yellow

# Foreground color of pinned unselected even tabs.
c.colors.tabs.pinned.even.fg = colors.black

# Background color of pinned unselected odd tabs.
c.colors.tabs.pinned.odd.bg = colors.yellow

# Foreground color of pinned unselected odd tabs.
c.colors.tabs.pinned.odd.fg = colors.black

# Background color of pinned selected even tabs.
c.colors.tabs.pinned.selected.even.bg = colors.green

# Foreground color of pinned selected even tabs.
c.colors.tabs.pinned.selected.even.fg = colors.magenta

# Background color of pinned selected odd tabs.
c.colors.tabs.pinned.selected.odd.bg = colors.green

# Foreground color of pinned selected odd tabs.
c.colors.tabs.pinned.selected.odd.fg = colors.magenta

# Foreground color of selected odd tabs.
c.colors.tabs.selected.odd.fg = colors.black

# Background color of selected odd tabs.
c.colors.tabs.selected.odd.bg = colors.blue

# Foreground color of selected even tabs.
c.colors.tabs.selected.even.fg = colors.black

# Background color of selected even tabs.
c.colors.tabs.selected.even.bg = colors.blue

# Background color for webpages if unset (or empty to use the theme's
# color).
c.colors.webpage.bg = colors.black
