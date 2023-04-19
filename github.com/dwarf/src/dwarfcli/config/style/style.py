from prompt_toolkit.styles import Style

# Prompt Colors
from dwarfcli.config.style.color import Color
from dwarfcli.config.style.terminal_factory import TerminalFactory

colors: Color = TerminalFactory(True).instance().get_colors()

DWARF_STYLE = Style.from_dict({
    colors.bl: colors.bl_val,
    colors.gr: colors.gr_val,
    colors.rd: colors.rd_val,
    colors.yl: colors.yl_val,
    colors.og: colors.og_val
})