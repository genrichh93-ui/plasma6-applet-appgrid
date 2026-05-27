/*
    SPDX-FileCopyrightText: 2026 AppGrid Contributors
    SPDX-License-Identifier: GPL-2.0-or-later

    Root plasmoid item: panel icon + native Plasma popup.
    Opens near the panel icon, like Kickoff.
*/

import QtQuick
import org.kde.plasma.plasmoid

import org.kde.plasma.core as PlasmaCore

import "migrations.js" as Migrations

PlasmoidItem {
    id: kicker

    Plasmoid.status: Plasmoid.configuration.icon === "hidden" ? PlasmaCore.Types.HiddenStatus : PlasmaCore.Types.ActiveStatus

    compactRepresentation: compactRepresentationComponent
    fullRepresentation: fullRepresentationComponent
    preferredRepresentation: compactRepresentation

    activationTogglesExpanded: true
    // Keep the popup open while a drag-out is in flight so the source surface
    // doesn't disappear mid-drag (which would cancel the platform DnD before
    // the drop target accepts it).
    hideOnWindowDeactivate: !isDragInFlight

    // Shared drag source for all app drags — see DragSource.qml.
    readonly property alias dragSource: dragSourceImpl
    readonly property alias isDragInFlight: dragSourceImpl.isDragInFlight
    DragSource { id: dragSourceImpl }

    // Update checker (universal builds only) — see standalone main.qml.
    Component.onCompleted: {
        Migrations.migrateLauncherIcon(Plasmoid.configuration)
        _syncUpdateChecker()
    }
    Connections {
        target: Plasmoid.configuration
        function onCheckForUpdatesChanged() { kicker._syncUpdateChecker() }
    }
    function _syncUpdateChecker() {
        if (Plasmoid.updateChecker)
            Plasmoid.updateChecker.enabled = Plasmoid.configuration.checkForUpdates === true
    }

    Plasmoid.icon: {
        if (Plasmoid.configuration.icon === "hidden") {
            return "dev.xarbit.appgrid";
        }
        return Plasmoid.configuration.useCustomButtonImage
            ? Plasmoid.configuration.customButtonImage
            : Plasmoid.configuration.icon;
    }

    Component {
        id: compactRepresentationComponent
        CompactRepresentation {}
    }

    Component {
        id: fullRepresentationComponent
        GridPanel {
            id: panel
            nativePopup: true
            appletInterface: kicker
            opacity: 1.0
            onCloseRequested: kicker.expanded = false

            Connections {
                target: kicker
                function onExpandedChanged() {
                    if (kicker.expanded) {
                        panel.resetState()
                        if (Plasmoid.configuration.shakeOnOpen)
                            panel.shakeAllIcons()
                    } else {
                        panel.resetOnClose()
                    }
                }
            }

            Shortcut {
                sequence: "Escape"
                onActivated: kicker.expanded = false
            }
        }
    }
}
