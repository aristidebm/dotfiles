import QtQuick
import QtQuick.Controls

// A TextField with GNU-readline-style editing keybindings (Emacs bindings:
// Ctrl-A/E/B/F/D/H/K/U/W/Y, Alt-B/F/D). List/app navigation is *not* handled
// here — it's delegated upward via signals so this component stays reusable
// anywhere a readline-style text input is needed, not just this launcher.
TextField {
    id: self

    signal submitted
    signal cancelled

    // Emacs-style "kill ring" — holds the last killed (cut) span of text so
    // Ctrl-Y can yank it back.
    property string killRing: ""

    placeholderText: "Run…"
    font.pixelSize: 18
    color: "white"
    focus: true
    padding: 15

    background: Rectangle {
        border.width: 0
        color: "transparent"
    }

    // Find the start of the word before `pos` (skips trailing whitespace
    // first, then walks back to the previous word boundary).
    function wordStartBefore(pos) {
        let i = pos;
        while (i > 0 && /\s/.test(text.charAt(i - 1)))
            i--;
        while (i > 0 && !/\s/.test(text.charAt(i - 1)))
            i--;
        return i;
    }

    // Find the end of the word after `pos`.
    function wordEndAfter(pos) {
        let i = pos;
        const len = text.length;
        while (i < len && /\s/.test(text.charAt(i)))
            i++;
        while (i < len && !/\s/.test(text.charAt(i)))
            i++;
        return i;
    }

    // Remove text in [start, end), remember it in the kill ring, and leave
    // the cursor at `start`. Implemented via plain string slicing rather
    // than TextInput's insert()/remove() methods, so this doesn't depend on
    // the exact set of invokable methods available on your Qt version.
    function killRange(start, end) {
        killRing = text.substring(start, end);
        text = text.substring(0, start) + text.substring(end);
        cursorPosition = start;
    }

    function yankAt(pos) {
        text = text.substring(0, pos) + killRing + text.substring(pos);
        cursorPosition = pos + killRing.length;
    }

    function reset() {
        text = "";
        killRing = "";
        cursorPosition = 0;
    }

    Keys.onPressed: event => {
        const ctrl = event.modifiers & Qt.ControlModifier;
        const alt = event.modifiers & Qt.AltModifier;
        const key = event.key;

        if (key === Qt.Key_Return || key === Qt.Key_Enter) {
            event.accepted = true;
            submitted();
            return;
        }
        if (key === Qt.Key_Escape || (ctrl && key === Qt.Key_BracketLeft)) {
            event.accepted = true;
            cancelled();
            return;
        }

        // --- Readline-style line editing ---
        if (ctrl && key === Qt.Key_A) {
            event.accepted = true;
            cursorPosition = 0;
        } else if (ctrl && key === Qt.Key_E) {
            event.accepted = true;
            cursorPosition = text.length;
        } else if (ctrl && key === Qt.Key_B) {
            event.accepted = true;
            cursorPosition = Math.max(0, cursorPosition - 1);
        } else if (ctrl && key === Qt.Key_F) {
            event.accepted = true;
            cursorPosition = Math.min(text.length, cursorPosition + 1);
        } else if (ctrl && key === Qt.Key_D) {
            event.accepted = true;
            if (cursorPosition < text.length)
                killRange(cursorPosition, cursorPosition + 1);
        } else if (ctrl && key === Qt.Key_H) {
            event.accepted = true;
            if (cursorPosition > 0)
                killRange(cursorPosition - 1, cursorPosition);
        } else if (ctrl && key === Qt.Key_K) {
            event.accepted = true;
            killRange(cursorPosition, text.length);
        } else if (ctrl && key === Qt.Key_U) {
            event.accepted = true;
            killRange(0, cursorPosition);
        } else if (ctrl && key === Qt.Key_W) {
            event.accepted = true;
            killRange(wordStartBefore(cursorPosition), cursorPosition);
        } else if (ctrl && key === Qt.Key_Y) {
            event.accepted = true;
            yankAt(cursorPosition);
        } else if (alt && key === Qt.Key_B) {
            event.accepted = true;
            cursorPosition = wordStartBefore(cursorPosition);
        } else if (alt && key === Qt.Key_F) {
            event.accepted = true;
            cursorPosition = wordEndAfter(cursorPosition);
        } else if (alt && key === Qt.Key_D) {
            event.accepted = true;
            killRange(cursorPosition, wordEndAfter(cursorPosition));
        }
    }
}
