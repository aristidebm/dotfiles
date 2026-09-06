import QtQuick
import Quickshell
import Quickshell.Widgets

// A single row in the app list. Purely presentational — selection and
// activation are reported upward via signals rather than reaching into
// ListView.currentIndex directly, so this stays testable/reusable on its own.
Item {
    id: self

    required property var modelData
    required property int index

    signal selected
    signal activated

    width: ListView.view ? ListView.view.width : 0
    height: 36

    MouseArea {
        anchors.fill: parent
        onClicked: self.selected()
        onDoubleClicked: self.activated()
    }

    Row {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 10

        IconImage {
            source: Quickshell.iconPath(self.modelData.icon, true)
            width: 23
            height: 23
        }

        Text {
            color: "white"
            text: self.modelData.name
            font.pointSize: 13
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
    }
}
