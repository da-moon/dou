from sty import fg

from dwarfcli.config.style.color import Color
from dwarfcli.config.style.palette import Palette
from dwarfcli.config.style.terms.term import Term


class iTerm(Term):
    TERM_PROGRAM = 'iTerm.app'
    BLUE = (5, 156, 205)
    GREEN = (51, 222, 136)
    RED = (240, 70, 87)
    YELLOW = (249, 149, 72)
    ORANGE = (232, 149, 39)

    def get_colors(self) -> Color:
        return Color(
            colors_enabled=self.colors_enabled,
            palette=Palette(
                blue=iTerm.BLUE,
                green=iTerm.GREEN,
                red=iTerm.RED,
                yellow=iTerm.YELLOW,
                orange = iTerm.ORANGE
            )
        )
