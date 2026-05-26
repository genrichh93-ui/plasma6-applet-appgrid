/*
    SPDX-FileCopyrightText: 2026 AppGrid Contributors
    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kcmutils as KCMUtils
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

KCMUtils.SimpleKCM {
    id: page

    property alias cfg_searchAll: searchAll.checked
    property alias cfg_useExtraRunners: useExtraRunners.checked

    ColumnLayout {
        anchors.left: parent.left
        anchors.leftMargin: Kirigami.Units.gridUnit
        anchors.rightMargin: Kirigami.Units.gridUnit
        anchors.right: parent.right
        spacing: Kirigami.Units.largeSpacing

        Kirigami.Heading {
            level: 3
            text: i18nd("dev.xarbit.appgrid", "App search")
        }

        QQC2.CheckBox {
            id: searchAll
            text: i18nd("dev.xarbit.appgrid", "Search all apps regardless of active tab")
        }

        Kirigami.Separator { Layout.fillWidth: true }

        Kirigami.Heading {
            level: 3
            text: i18nd("dev.xarbit.appgrid", "Search plugins")
        }

        QQC2.Label {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            font: Kirigami.Theme.smallFont
            opacity: 0.7
            text: i18nd("dev.xarbit.appgrid", "Adds calculator, unit conversion, file search, bookmarks, web shortcuts and other KRunner results next to apps.")
        }

        QQC2.CheckBox {
            id: useExtraRunners
            text: i18nd("dev.xarbit.appgrid", "Use KDE search plugins (KRunner)")
        }

        QQC2.Button {
            text: i18nd("dev.xarbit.appgrid", "Configure Search Plugins…")
            icon.name: "settings-configure"
            enabled: useExtraRunners.checked
            onClicked: KCMUtils.KCMLauncher.openSystemSettings("kcm_plasmasearch")
        }
    }
}
