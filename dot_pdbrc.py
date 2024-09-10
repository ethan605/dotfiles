from pdb import DefaultConfig

class Config(DefaultConfig):
    prompt = '(pdb++) '
    sticky_by_default = True

from rich import pretty
pretty.install()
