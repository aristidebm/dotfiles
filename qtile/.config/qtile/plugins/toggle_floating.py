from libqtile.lazy import lazy
from libqtile.log_utils import get_default_logger

__all__ == ["toggle_focus_floating"]


def toggle_focus_floating():
    """Toggle focus between floating window and other windows in group"""

    @lazy.function
    def _toggle_focus_floating(qtile):
        logger = get_default_logger()
        group = qtile.current_group
        switch = "non-float" if qtile.current_window.floating else "float"
        logger.debug(
            f"toggle_focus_floating: switch = {switch}\t current_window: {qtile.current_window}"
        )
        logger.debug(f"focus_history: {group.focus_history}")

        for win in reversed(group.focus_history):
            logger.debug(f"{win}: {win.floating}")
            if switch == "float" and win.floating:
                # win.focus(warp=False)
                group.focus(win)
                return
            if switch == "non-float" and not win.floating:
                # win.focus(warp=False)
                group.focus(win)
                return

    return _toggle_focus_floating
