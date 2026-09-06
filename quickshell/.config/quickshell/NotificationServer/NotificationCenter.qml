import QtQuick
import QtQuick.Layouts
import QtQuick.Window

Window {
    id: root

    required property var theme
    required property var history

    visible: false
    title: "NotificationCenter"
    color: theme.colBackground

    ColumnLayout {
        id: centerColumn
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: "Notifications"
                color: theme.colForeground
                font { family: theme.fontFamily; pixelSize: theme.fontSize + 2; bold: true }
                Layout.fillWidth: true
            }

            Rectangle {
                Layout.preferredWidth: clearText.implicitWidth + 16
                Layout.preferredHeight: 28
                radius: 6
                color: Qt.alpha(theme.colCritical, 0.2)
                visible: history.count > 0

                Text {
                    id: clearText
                    anchors.centerIn: parent
                    text: "Clear All"
                    color: theme.colCritical
                    font { family: theme.fontFamily; pixelSize: theme.fontSize - 2 }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: history.clearAll()
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: theme.colBorder
        }

        Text {
            text: "No notifications"
            color: theme.colMuted
            font { family: theme.fontFamily; pixelSize: theme.fontSize }
            Layout.alignment: Qt.AlignHCenter
            visible: history.count === 0
            Layout.topMargin: 40
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 8
            model: history

            delegate: NotificationCard {
                required property var model
                required property int index

                width: listView.width
                theme: root.theme
                inPopup: false
                notifData: ({
                    appName: model.appName,
                    summary: model.summary,
                    body: model.body,
                    appIcon: model.appIcon,
                    urgency: model.urgency,
                    hasInlineReply: false,
                    actions: []
                })

                onDismissed: {
                    if (index >= 0 && index < history.count)
                        history.remove(index)
                }

                onExpired: {
                    if (index >= 0 && index < history.count)
                        history.remove(index)
                }
            }
        }
    }
}
