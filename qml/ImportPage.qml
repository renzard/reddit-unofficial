/*
 * Copyright (C) 2026 renzard politakis
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * ImportPage.qml - Επιλογέας αρχείων/συλλογής για Lomiri / Ubuntu Touch
 */

import QtQuick 2.9
import Lomiri.Components 1.3
import Lomiri.Content 1.3
import QtQuick.Controls.Suru 2.2

Page {
    id: importPage
    objectName: "importPage"

    property color b_color: "#501644"
    property color b_colorDark: "#1b0e17"
    readonly property color headerColor: Suru.theme === 0 ? b_color : b_colorDark
    readonly property color accentColor: Suru.theme === 0 ? b_color : "#d99fc9"

    signal imported(var fileUrl)
    signal canceled()

    property var contentType: ContentType.All
    property var handler: ContentHandler.Source
    property var activeTransfer: null

    property var pageStack: null

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Επιλογή Αρχείου")

        leadingActionBar.actions: [
            Action {
                iconName: "close"
                text: i18n.tr("Ακύρωση")
                onTriggered: {
                    importPage.canceled();
                    if (importPage.pageStack) importPage.pageStack.pop();
                }
            }
        ]

        StyleHints {
            foregroundColor: "white"
            backgroundColor: importPage.headerColor
            dividerColor: importPage.headerColor
        }
    }

    Rectangle {
        anchors.fill: parent
        color: theme.palette.normal.background
    }

    Column {
        anchors {
            top: pageHeader.bottom
            left: parent.left
            right: parent.right
        }
        anchors.margins: units.gu(2)
        spacing: units.gu(0.5)

        Label {
            text: i18n.tr("Από πού θέλεις να προσθέσεις το αρχείο;")
            textSize: Label.Medium
            font.bold: true
            wrapMode: Text.WordWrap
            width: parent.width
        }

        Label {
            text: i18n.tr("Διάλεξε μια από τις παρακάτω πηγές.")
            textSize: Label.Small
            opacity: 0.6
            wrapMode: Text.WordWrap
            width: parent.width
        }
    }

    ContentPeerPicker {
        id: peerPicker
        anchors {
            top: pageHeader.bottom
            topMargin: units.gu(9)
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        contentType: importPage.contentType
        handler: importPage.handler

        onPeerSelected: {
            peer.selectionType = ContentTransfer.Single;
            importPage.activeTransfer = peer.request();

            if (importPage.activeTransfer) {
                importPage.activeTransfer.stateChanged.connect(function() {
                    if (importPage.activeTransfer.state === ContentTransfer.Charged) {
                        if (importPage.activeTransfer.items.length > 0) {
                            var fileUrl = importPage.activeTransfer.items[0].url;
                            importPage.imported(fileUrl);
                        } else {

                            importPage.canceled();
                        }
                    } else if (importPage.activeTransfer.state === ContentTransfer.Aborted) {
                        importPage.canceled();
                    }
                });
            }
        }

        onCancelPressed: {
            importPage.canceled();
            if (importPage.pageStack) importPage.pageStack.pop();
        }
    }
}
