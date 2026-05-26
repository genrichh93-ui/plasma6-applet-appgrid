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

    property alias cfg_showDividers: showDividers.checked
    property alias cfg_showScrollbars: showScrollbars.checked
    property alias cfg_showTooltips: showTooltips.checked
    property alias cfg_showNewAppBadge: showNewAppBadge.checked
    property alias cfg_iconShadow: iconShadow.checked
    property alias cfg_backgroundOpacity: backgroundOpacity.value
    property alias cfg_enableBlur: enableBlur.checked
    property alias cfg_dimBackground: dimBackground.checked
    property alias cfg_overrideRadius: overrideRadius.checked
    property alias cfg_cornerRadius: cornerRadius.value

    ColumnLayout {
        anchors.left: parent.left
        anchors.leftMargin: Kirigami.Units.gridUnit
        anchors.rightMargin: Kirigami.Units.gridUnit
        anchors.right: parent.right
        spacing: Kirigami.Units.largeSpacing

        Kirigami.Heading {
            level: 3
            text: i18nd("dev.xarbit.appgrid", "Grid")
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            QQC2.CheckBox {
                id: showDividers
                text: i18nd("dev.xarbit.appgrid", "Show divider lines")
            }
            QQC2.CheckBox {
                id: showScrollbars
                text: i18nd("dev.xarbit.appgrid", "Show scrollbars")
            }
            QQC2.CheckBox {
                id: showTooltips
                text: i18nd("dev.xarbit.appgrid", "Show tooltips on hover")
            }
            QQC2.CheckBox {
                id: showNewAppBadge
                text: i18nd("dev.xarbit.appgrid", "Show new app badge")
            }
            QQC2.CheckBox {
                id: iconShadow
                text: i18nd("dev.xarbit.appgrid", "Drop shadow behind app icons")
            }
        }

        Kirigami.Separator {
            visible: !page.isPanel
            Layout.fillWidth: true
        }

        Kirigami.Heading {
            visible: !page.isPanel
            level: 3
            text: i18nd("dev.xarbit.appgrid", "Background")
        }

        Kirigami.FormLayout {
            visible: !page.isPanel
            Layout.fillWidth: true

            RowLayout {
                Kirigami.FormData.label: i18nd("dev.xarbit.appgrid", "Opacity:")
                Layout.minimumWidth: Kirigami.Units.gridUnit * 22

                QQC2.Slider {
                    id: backgroundOpacity
                    from: 10; to: 100; stepSize: 5
                    Layout.fillWidth: true
                }
                QQC2.Label {
                    text: Math.round(backgroundOpacity.value) + "%"
                    Layout.minimumWidth: Kirigami.Units.gridUnit * 2
                }
            }
        }

        ColumnLayout {
            visible: !page.isPanel
            Layout.fillWidth: true
            spacing: 0

            QQC2.CheckBox {
                id: enableBlur
                text: i18nd("dev.xarbit.appgrid", "Enable background blur")
            }
            QQC2.CheckBox {
                id: dimBackground
                text: i18nd("dev.xarbit.appgrid", "Dim background behind launcher")
            }
        }

        Kirigami.Separator {
            visible: !page.isPanel
            Layout.fillWidth: true
        }

        Kirigami.Heading {
            visible: !page.isPanel
            level: 3
            text: i18nd("dev.xarbit.appgrid", "Corner radius")
        }

        ColumnLayout {
            visible: !page.isPanel
            Layout.fillWidth: true

            QQC2.CheckBox {
                id: overrideRadius
                text: i18nd("dev.xarbit.appgrid", "Use custom corner radius")
            }

            RowLayout {
                enabled: overrideRadius.checked
                Layout.leftMargin: Kirigami.Units.gridUnit

                QQC2.SpinBox {
                    id: cornerRadius
                    from: 0; to: 60
                }
                QQC2.Label {
                    text: i18nd("dev.xarbit.appgrid", "px")
                    opacity: overrideRadius.checked ? 1.0 : 0.5
                }
            }
        }
    }
}
