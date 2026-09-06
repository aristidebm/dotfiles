import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    required property var theme
    required property var server
    required property bool centerVisible

    visible: false
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: theme.popupPosition.indexOf("top") >= 0
        bottom: theme.popupPosition.indexOf("bottom") >= 0
        left: theme.popupPosition.indexOf("left") >= 0
        right: theme.popupPosition.indexOf("right") >= 0
    }

    margins {
        top: theme.popupMargin + 8
        bottom: theme.popupMargin + 8
        left: theme.popupMargin + 8
        right: theme.popupMargin + 8
    }

    implicitWidth: theme.popupWidth
    implicitHeight: _activeCards.length > 0 ? _calcHeight() : 0

    property var _activeCards: []
    property bool _replyFocused: false

    focusable: _replyFocused

    function _calcHeight() {
        var h = 0
        for (var i = 0; i < _activeCards.length; i++) {
            h += _activeCards[i].implicitHeight + 12
        }
        return h - 8
    }

    Connections {
        target: root.server
        function onNotification(notif) {
            if (root.theme.dnd) return
            if (!root.theme.popupShowWhenCenterOpen && root.centerVisible) return
            root._showNotification(notif)
        }
    }

    Component {
        id: cardComponent
        NotificationCard {}
    }

    function _showNotification(notif) {
        _activeCards = _activeCards.filter(function(c) { return c && c.visible })

        while (_activeCards.length >= theme.popupMaxVisible) {
            var oldest = _activeCards.shift()
            if (oldest) oldest.expired()
        }

        var newCard = cardComponent.createObject(cardContainer, {
            theme: theme,
            notifData: notif,
            notif: notif,
            inPopup: true,
            width: theme.popupWidth
        })

        newCard.dismissed.connect(function() { _dismissCard(newCard) })
        newCard.expired.connect(function() { _dismissCard(newCard) })
        newCard.closedExternally.connect(function() { _removeCard(newCard) })
        newCard.canReplyChanged.connect(function() { root._updateReplyFocus() })

        _activeCards.push(newCard)
        _relayout()
        root.visible = true
        root._updateReplyFocus()
    }

    function _dismissCard(card) {
        if (!card || card._dismissHandled) return

        var notif = null
        try {
            notif = card.notif
        } catch (e) {
            console.warn("NotificationPopup: could not read card notification", e)
        }

        if (notif) {
            try {
                notif.dismiss()
            } catch (e) {
                console.warn("NotificationPopup: notification dismiss failed", e)
            }
        }

        _removeCard(card)
    }

    function _removeCard(card) {
        if (!card || card._dismissHandled) return
        card._dismissHandled = true

        var idx = _activeCards.indexOf(card)
        if (idx !== -1) _activeCards.splice(idx, 1)

        root._updateReplyFocus()

        card.destroy()
        _relayout()
        if (_activeCards.length === 0) root.visible = false
    }

    function _updateReplyFocus() {
        var any = false
        for (var i = 0; i < _activeCards.length; i++) {
            if (_activeCards[i].canReply) {
                any = true
                break
            }
        }
        var prev = root._replyFocused
        root._replyFocused = any
        if (any && !prev) Qt.callLater(function() { root.requestActivate() })
    }

    function _relayout() {
        var y = 0
        for (var i = 0; i < _activeCards.length; i++) {
            var c = _activeCards[i]
            c.x = 0
            c.y = y
            y += c.implicitHeight + 12
        }
        root.implicitHeight = _activeCards.length > 0 ? y - 12 : 0
    }

    Item {
        id: cardContainer
        anchors.fill: parent
    }
}
