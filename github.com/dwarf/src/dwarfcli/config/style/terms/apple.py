from sty import fg

from dwarfcli.config.style.color import Color
from dwarfcli.config.style.palette import Palette
from dwarfcli.config.style.terms.term import Term


class AppleTerminal(Term):
    TERM_PROGRAM = 'Apple_Terminal'
    BLUE = (33, 46, 222)
    GREEN = (40, 138, 74)
    RED = (191, 29, 42)
    YELLOW = (199, 142, 10)
    ORANGE = (232, 149, 39)

    def get_colors(self) -> Color:
        return Color(
            colors_enabled=self.colors_enabled,
            palette=Palette(
                blue=AppleTerminal.BLUE,
                green=AppleTerminal.GREEN,
                red=AppleTerminal.RED,
                yellow=AppleTerminal.YELLOW,
                orange=AppleTerminal.ORANGE
            )
        )
