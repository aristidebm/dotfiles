# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
from libqtile.config import Key, EzKey, EzClick, EzDrag, ScratchPad, Group
from libqtile.lazy import lazy

from groups import groups
from constants import TERMINAL, MENU, MOD4

__all__ = ["keys", "mouse"]

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    EzKey(
        "M-n",
        lazy.group.next_window(),
        desc="Move focus to next window of the group",
    ),
    EzKey(
        "M-p",
        lazy.group.prev_window(),
        desc="Move focus to previous window of the group",
    ),
    EzKey("M-S-n", lazy.layout.swap_left(), desc=""),
    EzKey("M-S-p", lazy.layout.swap_right(), desc=""),
    EzKey("M-<space>", lazy.layout.maximize().when(layout="monadtall"), desc=""),
    Key([MOD4], "equal", lazy.layout.reset().when(layout="monadtall"), desc=""),
    EzKey("M-<Return>", lazy.layout.swap_main().when(layout="monadtall"), desc="Swap the current window with the master window",),
    Key(
        [MOD4, "shift"],
        "period",
        lazy.layout.grow().when(layout="monadtall"),
        desc="",
    ),
    Key(
        [MOD4, "shift"],
        "comma",
        lazy.layout.shrink().when(layout="monadtall"),
        desc="",
    ),
    Key(
        [MOD4],
        "i",
        lazy.layout.flip().when(layout="monadtall"),
        desc="",
    ),
    EzKey("M-d", lazy.spawn(MENU), desc="Run Launcher"),
    EzKey("M-q", lazy.window.kill(), desc="Kill focused window"),
    EzKey("M-S-f", lazy.window.toggle_fullscreen(), desc="toggle fullscreen"),
    EzKey("M-<Tab>", lazy.next_layout(), desc="Toggle between layouts"),
    # Disable layout keybindings, since it need to be hooked to work
    # expected
    EzKey("M-S-<space>", lazy.window.toggle_floating(), desc="Toggle floating"),
    EzKey("M-S-r", lazy.reload_config(), desc="Reload the config"),
    EzKey("M-S-<Return>", lazy.spawn(TERMINAL), desc="Launch terminal"),
    # Special keys binding
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.widget["volume"].increase_vol(),
        desc="Increase the volume",
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.widget["volume"].decrease_vol(),
        desc="Decrease the volume.",
    ),
    Key(
        [],
        "XF86MonBrightnessUp",
        lazy.spawn("brightnessctl set +10%"),
        desc="Increase the brightness.",
    ),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.spawn("brightnessctl set 10%-"),
        desc="Decrease the brightness.",
    ),
]

top4 = ["j", "k", "l", "<semicolon>"]
for i, g in enumerate(groups[:4]):
    if type(g) is not Group:
        continue

    toscreen = EzKey(
        f"M-{top4[i]}",
        lazy.group[g.name].toscreen(),
        desc=f"Switch to group {g.name}",
    )
    togroup = EzKey(
        f"M-S-{top4[i]}",
        lazy.window.togroup(g.name, switch_group=False),
        desc=f"Switch to & move focused window to group  {g.name}",
    )
    keys.extend([toscreen, togroup])

for g in groups:
    if type(g) is not Group:
        continue

    toscreen = EzKey(
        f"M-{g.name}",
        lazy.group[g.name].toscreen(),
        desc=f"Switch to group {g.name}",
    )
    togroup = EzKey(
        f"M-S-{g.name}",
        lazy.window.togroup(g.name, switch_group=False),
        desc=f"Switch to & move focused window to group  {g.name}",
    )
    keys.extend([toscreen, togroup])

for g in groups:
    if not isinstance(g, ScratchPad):
        continue
    keys.append(Key([MOD4], "o", lazy.group["scratchpad"].dropdown_toggle("term")))
    # keys.append(Key([MOD4], "i", lazy.group["scratchpad"].dropdown_toggle("term")))
    # keys.append(Key([MOD4], "o", lazy.group["scratchpad"].dropdown_toggle("fm")))
    # keys.append(Key([MOD4], "m", lazy.group["scratchpad"].dropdown_toggle("pick")))

mouse = [
    EzDrag(
        "M-1", lazy.window.set_position_floating(), start=lazy.window.get_position()
    ),
    EzDrag("M-3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    EzClick("M-2", lazy.window.bring_to_front()),
]
