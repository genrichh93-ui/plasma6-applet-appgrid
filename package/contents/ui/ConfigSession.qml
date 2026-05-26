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

    property var cfg_powerButtonOrder: Plasmoid.configuration.powerButtonOrder
    property var cfg_powerButtonsHidden: Plasmoid.configuration.powerButtonsHidden
    property alias cfg_showActionLabels: showActionLabels.checked

    ColumnLayout {
        anchors.left: parent.left
        anchors.leftMargin: Kirigami.Units.gridUnit
        anchors.rightMargin: Kirigami.Units.gridUnit
        anchors.right: parent.right
        spacing: Kirigami.Units.largeSpacing

        PowerButtonsConfig {
            Layout.fillWidth: true
            buttonOrder: page.cfg_powerButtonOrder
            hiddenButtons: page.cfg_powerButtonsHidden
            onEdited: (newOrder, newHidden) => {
                page.cfg_powerButtonOrder = newOrder
                page.cfg_powerButtonsHidden = newHidden
            }
        }

        Kirigami.Separator { Layout.fillWidth: true }

        QQC2.CheckBox {
            id: showActionLabels
            text: i18nd("dev.xarbit.appgrid", "Show labels on power/session buttons")
        }
    }
}
