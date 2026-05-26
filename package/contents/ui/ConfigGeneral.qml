/*
    SPDX-FileCopyrightText: 2026 AppGrid Contributors
    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.draganddrop as DragDrop
import org.kde.iconthemes as KIconThemes
import org.kde.kcmutils as KCMUtils
import org.kde.kirigami as Kirigami
import org.kde.ksvg as KSvg
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

KCMUtils.SimpleKCM {
    id: page

    readonly property bool isPanel: Plasmoid.pluginName === "dev.xarbit.appgrid.panel"
    readonly property string defaultIcon: "dev.xarbit.appgrid"

    property string cfg_icon: Plasmoid.configuration.icon
    property bool cfg_useCustomButtonImage: Plasmoid.configuration.useCustomButtonImage
    property string cfg_customButtonImage: Plasmoid.configuration.customButtonImage
    property string cfg_menuLabel: Plasmoid.configuration.menuLabel
    property alias cfg_gridColumns: gridColumns.value
    property alias cfg_gridRows: gridRows.value
    property alias cfg_iconSize: iconSize.currentIndex
    property alias cfg_sortMode: sortMode.currentIndex
    property alias cfg_showCategoryBar: showCategoryBar.checked
    property alias cfg_startWithFavorites: startWithFavorites.checked
    property alias cfg_hideLabelsOnFavorites: hideLabelsOnFavorites.checked
    property alias cfg_sortFavoritesAlphabetically: sortFavoritesAlphabetically.checked
    property alias cfg_showRecentApps: showRecentApps.checked
    property alias cfg_useSystemCategories: useSystemCategories.checked
    property alias cfg_hideEmptyCategories: hideEmptyCategories.checked
    property alias cfg_openOnActiveScreen: openOnActiveScreen.checked
    property alias cfg_verticalOffset: verticalOffset.value
    property alias cfg_checkForUpdates: checkForUpdates.checked
    property string cfg_terminalShell: Plasmoid.configuration.terminalShell

    ColumnLayout {
        anchors.left: parent.left
        anchors.leftMargin: Kirigami.Units.gridUnit
        anchors.rightMargin: Kirigami.Units.gridUnit
        anchors.right: parent.right
        spacing: Kirigami.Units.largeSpacing

        Kirigami.Heading {
            level: 3
            text: i18nd("dev.xarbit.appgrid", "Identity")
        }

        Kirigami.FormLayout {
            Layout.fillWidth: true

            QQC2.Button {
                id: iconButton
                Kirigami.FormData.label: i18nd("dev.xarbit.appgrid", "Icon:")
                implicitWidth: previewFrame.width + Kirigami.Units.smallSpacing * 2
                implicitHeight: previewFrame.height + Kirigami.Units.smallSpacing * 2
                checkable: true
                checked: dropArea.containsAcceptableDrag
                onPressed: iconMenu.opened ? iconMenu.close() : iconMenu.open()

                DragDrop.DropArea {
                    id: dropArea
                    property bool containsAcceptableDrag: false
                    anchors.fill: parent

                    onDragEnter: event => {
                        const urlString = event.mimeData.url.toString();
                        const extensions = [".png", ".xpm", ".svg", ".svgz"];
                        containsAcceptableDrag = urlString.startsWith("file:///")
                            && extensions.some(ext => urlString.endsWith(ext));
                        if (!containsAcceptableDrag) event.ignore();
                    }
                    onDragLeave: containsAcceptableDrag = false
                    onDrop: event => {
                        if (containsAcceptableDrag)
                            iconDialog.setCustomButtonImage(event.mimeData.url.toString().substr("file://".length));
                        containsAcceptableDrag = false;
                    }
                }

                KIconThemes.IconDialog {
                    id: iconDialog
                    function setCustomButtonImage(image) {
                        page.cfg_customButtonImage = image || page.cfg_icon || page.defaultIcon
                        page.cfg_useCustomButtonImage = true;
                    }
                    onIconNameChanged: iconName => setCustomButtonImage(iconName)
                }

                KSvg.FrameSvgItem {
                    id: previewFrame
                    anchors.centerIn: parent
                    imagePath: Plasmoid.location === PlasmaCore.Types.Vertical
                               || Plasmoid.location === PlasmaCore.Types.Horizontal
                               ? "widgets/panel-background" : "widgets/background"
                    width: Kirigami.Units.iconSizes.large + fixedMargins.left + fixedMargins.right
                    height: Kirigami.Units.iconSizes.large + fixedMargins.top + fixedMargins.bottom

                    Kirigami.Icon {
                        anchors.centerIn: parent
                        width: Kirigami.Units.iconSizes.large
                        height: width
                        source: page.cfg_useCustomButtonImage
                                ? page.cfg_customButtonImage
                                : page.cfg_icon
                    }
                }

                QQC2.Menu {
                    id: iconMenu
                    y: parent.height
                    onClosed: iconButton.checked = false

                    QQC2.MenuItem {
                        text: i18ndc("dev.xarbit.appgrid", "@item:inmenu Open icon chooser dialog", "Choose…")
                        icon.name: "document-open-folder"
                        onClicked: iconDialog.open()
                    }
                    QQC2.MenuItem {
                        text: i18ndc("dev.xarbit.appgrid", "@item:inmenu Reset icon to default", "Clear Icon")
                        icon.name: "edit-clear"
                        onClicked: {
                            page.cfg_icon = page.defaultIcon
                            page.cfg_customButtonImage = ""
                            page.cfg_useCustomButtonImage = false
                        }
                    }
                }
            }

            Kirigami.ActionTextField {
                id: menuLabel
                Kirigami.FormData.label: i18nd("dev.xarbit.appgrid", "Text label:")
                Layout.fillWidth: true
                placeholderText: i18nd("dev.xarbit.appgrid", "Type here to add a text label")
                text: page.cfg_menuLabel
                onTextChanged: page.cfg_menuLabel = text
                enabled: Plasmoid.formFactor !== PlasmaCore.Types.Vertical
                rightActions: Kirigami.Action {
                    icon.name: "edit-clear"
                    visible: menuLabel.text.length > 0
                    onTriggered: page.cfg_menuLabel = ""
                }
            }
        }

        Kirigami.Separator { Layout.fillWidth: true }

        Kirigami.Heading {
            level: 3
            text: i18nd("dev.xarbit.appgrid", "Grid")
        }

        Kirigami.FormLayout {
            Layout.fillWidth: true

            QQC2.SpinBox {
                id: gridColumns
                visible: !page.isPanel
                Kirigami.FormData.label: i18nd("dev.xarbit.appgrid", "Icons per row:")
                from: 3; to: 10
            }

            QQC2.SpinBox {
                id: gridRows
                visible: !page.isPanel
                Kirigami.FormData.label: i18nd("dev.xarbit.appgrid", "Visible rows:")
                from: 2; to: 10
            }

            QQC2.ComboBox {
                id: iconSize
                Kirigami.FormData.label: i18nd("dev.xarbit.appgrid", "Icon size:")
                model: [i18nd("dev.xarbit.appgrid", "Small"), i18nd("dev.xarbit.appgrid", "Medium"), i18nd("dev.xarbit.appgrid", "Large")]
            }

            QQC2.ComboBox {
                id: sortMode
                Kirigami.FormData.label: i18nd("dev.xarbit.appgrid", "Sort order:")
                model: [i18nd("dev.xarbit.appgrid", "Alphabetical"), i18nd("dev.xarbit.appgrid", "Most Used"), i18nd("dev.xarbit.appgrid", "By Category")]
            }
        }

        Kirigami.Separator { Layout.fillWidth: true }

        Kirigami.Heading {
            level: 3
            text: i18nd("dev.xarbit.appgrid", "Behavior")
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            QQC2.CheckBox {
                id: showCategoryBar
                text: i18nd("dev.xarbit.appgrid", "Show category bar")
            }
            QQC2.CheckBox {
                id: startWithFavorites
                text: i18nd("dev.xarbit.appgrid", "Start with favorites tab")
                enabled: showCategoryBar.checked
            }
            QQC2.CheckBox {
                id: hideLabelsOnFavorites
                text: i18nd("dev.xarbit.appgrid", "Hide app labels on favorites tab")
                enabled: showCategoryBar.checked
            }
            QQC2.CheckBox {
                id: sortFavoritesAlphabetically
                text: i18nd("dev.xarbit.appgrid", "Sort favorites alphabetically")
            }
            QQC2.CheckBox {
                id: showRecentApps
                text: i18nd("dev.xarbit.appgrid", "Show recently used applications")
                enabled: sortMode.currentIndex !== 1 || startWithFavorites.checked
            }
            QQC2.CheckBox {
                id: useSystemCategories
                text: i18nd("dev.xarbit.appgrid", "Use system categories (supports KDE Menu Editor)")
                enabled: showCategoryBar.checked
            }
            QQC2.CheckBox {
                id: hideEmptyCategories
                text: i18nd("dev.xarbit.appgrid", "Hide empty categories")
                enabled: showCategoryBar.checked
            }
            QQC2.CheckBox {
                id: openOnActiveScreen
                visible: !page.isPanel
                text: i18nd("dev.xarbit.appgrid", "Open on screen with mouse focus (otherwise on panel screen)")
            }
        }

        Kirigami.Separator {
            visible: !page.isPanel
            Layout.fillWidth: true
        }

        Kirigami.Heading {
            visible: !page.isPanel
            level: 3
            text: i18nd("dev.xarbit.appgrid", "Position")
        }

        Kirigami.FormLayout {
            visible: !page.isPanel
            Layout.fillWidth: true

            RowLayout {
                Kirigami.FormData.label: i18nd("dev.xarbit.appgrid", "Vertical position:")
                Layout.minimumWidth: Kirigami.Units.gridUnit * 22

                QQC2.Slider {
                    id: verticalOffset
                    from: -100; to: 100; stepSize: 25
                    snapMode: QQC2.Slider.SnapAlways
                    Layout.fillWidth: true
                }
                QQC2.Label {
                    text: verticalOffset.value === 0
                          ? i18nd("dev.xarbit.appgrid", "Centered")
                          : verticalOffset.value < 0
                            ? i18nd("dev.xarbit.appgrid", "Up %1%", Math.round(-verticalOffset.value))
                            : i18nd("dev.xarbit.appgrid", "Down %1%", Math.round(verticalOffset.value))
                    Layout.minimumWidth: Kirigami.Units.gridUnit * 5
                }
            }
        }

        Kirigami.Separator { Layout.fillWidth: true }

        Kirigami.Heading {
            level: 3
            text: i18nd("dev.xarbit.appgrid", "Terminal")
        }

        Kirigami.FormLayout {
            Layout.fillWidth: true

            QQC2.ComboBox {
                id: terminalShell
                Kirigami.FormData.label: i18nd("dev.xarbit.appgrid", "Shell:")
                Layout.fillWidth: true
                model: {
                    var shells = Plasmoid.availableShells ? Plasmoid.availableShells() : []
                    return [i18nd("dev.xarbit.appgrid", "Default (/bin/sh)")].concat(shells)
                }
                currentIndex: {
                    if (!page.cfg_terminalShell) return 0
                    var shells = Plasmoid.availableShells ? Plasmoid.availableShells() : []
                    var idx = shells.indexOf(page.cfg_terminalShell)
                    return idx >= 0 ? idx + 1 : 0
                }
                onActivated: function(index) {
                    if (index === 0) {
                        page.cfg_terminalShell = ""
                    } else {
                        var shells = Plasmoid.availableShells ? Plasmoid.availableShells() : []
                        page.cfg_terminalShell = shells[index - 1] || ""
                    }
                }
            }
        }

        Kirigami.Separator {
            visible: Plasmoid.isUniversalBuild === true
            Layout.fillWidth: true
        }

        Kirigami.Heading {
            visible: Plasmoid.isUniversalBuild === true
            level: 3
            text: i18nd("dev.xarbit.appgrid", "Updates")
        }

        QQC2.CheckBox {
            id: checkForUpdates
            visible: Plasmoid.isUniversalBuild === true
            text: i18nd("dev.xarbit.appgrid", "Check the AppGrid website for new releases")
            QQC2.ToolTip.text: i18nd("dev.xarbit.appgrid", "Anonymous request once per day to %1. Shows an indicator near the session buttons when a new version is available; no automatic install.").arg("https://appgrid.xarbit.dev/api/latest.json")
            QQC2.ToolTip.visible: hovered
            QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
        }
    }
}
