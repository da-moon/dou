from sty import fg

from dwarfcli.config.style.color import Color
from dwarfcli.config.style.palette import Palette
from dwarfcli.config.style.terms.term import Term


class DefaultTerm(Term):
    TERM_PROGRAM = 'Unknown'
    BLUE = Palette.BLUE
    GREEN = Palette.GREEN
    RED = Palette.RED
    YELLOW = Palette.YELLOW
    ORANGE = Palette.ORANGE

    def get_colors(self) -> Color:
        return Color(
            colors_enabled=self.colors_enabled,
            palette=Palette(
                blue=DefaultTerm.BLUE,
                green=DefaultTerm.GREEN,
                red=DefaultTerm.RED,
                yellow=DefaultTerm.YELLOW,
                orange=DefaultTerm.ORANGE,
            )
        )
