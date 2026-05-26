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

    readonly property bool isPanel: Plasmoid.pluginName === "dev.xarbit.appgrid.panel"

    property alias cfg_openAnimation: openAnimation.currentIndex
    property alias cfg_hoverAnimation: hoverAnimation.currentIndex
    property alias cfg_shakeOnOpen: shakeOnOpen.checked

    ColumnLayout {
        anchors.left: parent.left
        anchors.leftMargin: Kirigami.Units.gridUnit
        anchors.rightMargin: Kirigami.Units.gridUnit
        anchors.right: parent.right
        spacing: Kirigami.Units.largeSpacing

        Kirigami.Heading {
            visible: !page.isPanel
            level: 3
            text: i18nd("dev.xarbit.appgrid", "Open/close")
        }

        Kirigami.FormLayout {
            visible: !page.isPanel
            Layout.fillWidth: true

            QQC2.ComboBox {
                id: openAnimation
                Kirigami.FormData.label: i18nd("dev.xarbit.appgrid", "Animation:")
                model: [
                    i18nd("dev.xarbit.appgrid", "None"),
                    i18nd("dev.xarbit.appgrid", "Fade"),
                    i18nd("dev.xarbit.appgrid", "Scale"),
                    i18nd("dev.xarbit.appgrid", "Pop"),
                    i18nd("dev.xarbit.appgrid", "Slide Up"),
                    i18nd("dev.xarbit.appgrid", "Slide Down"),
                    i18nd("dev.xarbit.appgrid", "Glide"),
                    i18nd("dev.xarbit.appgrid", "Buzz"),
                    i18nd("dev.xarbit.appgrid", "Twist"),
                    i18nd("dev.xarbit.appgrid", "Slam"),
                    i18nd("dev.xarbit.appgrid", "Grow Up")
                ]
            }
        }

        Kirigami.Separator {
            visible: !page.isPanel
            Layout.fillWidth: true
        }

        Kirigami.Heading {
            level: 3
            text: i18nd("dev.xarbit.appgrid", "Icons")
        }

        Kirigami.FormLayout {
            Layout.fillWidth: true

            QQC2.ComboBox {
                id: hoverAnimation
                Kirigami.FormData.label: i18nd("dev.xarbit.appgrid", "Hover animation:")
                model: [
                    i18nd("dev.xarbit.appgrid", "None"),
                    i18nd("dev.xarbit.appgrid", "Shake"),
                    i18nd("dev.xarbit.appgrid", "Grow"),
                    i18nd("dev.xarbit.appgrid", "Bounce"),
                    i18nd("dev.xarbit.appgrid", "Spin"),
                    i18nd("dev.xarbit.appgrid", "Shuffle")
                ]
            }
        }

        QQC2.CheckBox {
            id: shakeOnOpen
            text: i18nd("dev.xarbit.appgrid", "Animate icons when the launcher opens")
            enabled: hoverAnimation.currentIndex > 0
        }
    }
}
