# Ned's .pdbrc (updated)
# Source: https://kylekizirian.github.io/ned-batchelders-updated-pdbrc.html

import pdb

class Config(pdb.DefaultConfig):
    pygments_formatter_class = "pygments.formatters.TerminalTrueColorFormatter"
    pygments_formatter_kwargs = {"style": "solarized-dark"}

from rich import print

# Print a dictionary, sorted. %1 is the dict, %2 is the prefix for the names.
alias p_ for k in sorted(%1.keys()): print(f"%2{k.ljust(max(len(s) for s in %1.keys()))} = {%1[k]}")

alias p print(%1)
#alias pp from rich import print; print(%1)

# Print the member variables of a thing.
alias pi p_ %1.__dict__ %1.

# Print the member variables of self.
alias ps pi self

# Print the locals.
alias pl p_ locals() local:

# Next and list, and step and list.
alias nl n;;l
alias sl s;;l
