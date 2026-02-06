from pdb import Color  # type: ignore
from pdb import DefaultConfig  # type: ignore


class Config(DefaultConfig):
    prompt = "(pdb++) "
    show_hidden_frames_count = True
    sticky_by_default = True

    line_number_color = Color.blue
    filename_color = Color.yellow
