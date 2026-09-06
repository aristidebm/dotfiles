import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import "../Shared"
import "./Components"

Window {
    id: self

    Theme {
        id: theme
    }

    title: "AppLauncher"
    visible: false
    color: theme.colBackground
    width: 1500
    height: 700

    IpcHandler {
        target: "AppLauncher"

        function toggle() {
            if (self.visible) {
                self.hide()
            } else {
                self.show()
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        Keys.onPressed: event => {
            const ctrl = event.modifiers & Qt.ControlModifier;
            const alt = event.modifiers & Qt.AltModifier;
            const key = event.key;

            // --- Navigation / lifecycle, delegated to the parent ---
            if (key === Qt.Key_Up || (ctrl && key === Qt.Key_P)) {
                event.accepted = true;
                appList.moveUp();
                return;
            }
            if (key === Qt.Key_Down || (ctrl && key === Qt.Key_N)) {
                event.accepted = true;
                appList.moveDown()
                return;
            }
        }

        RowLayout {
            IconImage {
                Layout.leftMargin: 10
                source: Quickshell.iconPath("nix-snowflake", true)
                Layout.preferredWidth: 25
                Layout.preferredHeight: 25
            }

            SearchField {
                id: textField
                Layout.fillWidth: true
                onTextChanged: appList.query = text
                onSubmitted: {
                    appList.launchSelected();
                    appList.reset();
                    reset();
                    self.close();
                }
                onCancelled: {
                    appList.reset();
                    reset();
                    self.close();
                }
            }
        }

        AppList {
            id: appList
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
