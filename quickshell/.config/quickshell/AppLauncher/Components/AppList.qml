import QtQuick
import Quickshell
import Quickshell.Io

// Owns filtering + selection state for the app list. Exposes `query` as
// input and `moveUp()`/`moveDown()`/`launchSelected()` as the only outward
// API, so the root window doesn't need to know anything about ListView,
// ScriptModel, or DesktopEntries internals.
Item {
    id: self

    property string query: ""
    property string terminal: "st"
    property color accentColor: "#3a7bd5"
    readonly property int count: list.count
    readonly property var currentApp: list.currentItem ? list.currentItem.modelData : null

    onQueryChanged: list.currentIndex = filtered.values.length > 0 ? 0 : -1

    function moveUp() {
        if (list.currentIndex > 0)
            list.currentIndex--;
    }

    function moveDown() {
        if (list.currentIndex < list.count - 1)
            list.currentIndex++;
    }

    function reset() {
        list.currentIndex = 0;
    }

    // DesktopEntry.execute() currently ignores runInTerminal and field
    // codes (see https://quickshell.org/docs/v0.3.0/types/Quickshell/DesktopEntry/),
    // so terminal apps like vifm/helix/neovim never actually get a
    // terminal. We spawn manually instead, wrapping in `terminal` when
    // the entry asks for one.
    function launchSelected() {
        const entry = currentApp;
        if (!entry)
            return;

        // Strip desktop-entry field codes (%f, %F, %u, %U, %i, %c, %k, etc.)
        // — see the Desktop Entry Specification's Exec key.
        const cmd = entry.execString.replace(/%[fFuUdDnNickvm%]/g, "").trim();
        launchProc.command = entry.runInTerminal ? [self.terminal, "-e", "sh", "-c", cmd] : ["sh", "-c", cmd];
        launchProc.startDetached();
    }

    Process {
        id: launchProc
    }

    ScriptModel {
        id: filtered
        values: {
            const allEntries = [...DesktopEntries.applications.values];
            const q = self.query.trim().toLowerCase();
            return q === "" ? allEntries : allEntries.filter(d => d.name && d.name.toLowerCase().includes(q));
        }
    }

    ListView {
        id: list
        anchors.fill: parent
        clip: true
        model: filtered.values
        currentIndex: filtered.values.length > 0 ? 0 : -1
        keyNavigationWraps: true
        preferredHighlightBegin: 0
        preferredHighlightEnd: height
        highlightRangeMode: ListView.ApplyRange
        highlightMoveDuration: 80

        highlight: Rectangle {
            radius: 4
            opacity: 0.45
            color: self.accentColor
        }

        delegate: AppEntry {
            onSelected: list.currentIndex = index
            onActivated: self.launchSelected()
        }

        // Enter also works while the list itself has focus.
        Keys.onReturnPressed: self.launchSelected()
    }
}
