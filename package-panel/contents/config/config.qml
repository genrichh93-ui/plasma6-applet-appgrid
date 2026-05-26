/*
    SPDX-FileCopyrightText: 2026 AppGrid Contributors
    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18nc("@title:group", "General")
        icon: "preferences-desktop-plasma"
        source: "ConfigGeneral.qml"
    }
    ConfigCategory {
        name: i18nc("@title:group", "Appearance")
        icon: "preferences-desktop-theme-applications"
        source: "ConfigAppearance.qml"
    }
    ConfigCategory {
        name: i18nc("@title:group", "Animations")
        icon: "preferences-desktop-effects"
        source: "ConfigAnimations.qml"
    }
    ConfigCategory {
        name: i18nc("@title:group", "Search")
        icon: "system-search"
        source: "ConfigSearch.qml"
    }
    ConfigCategory {
        name: i18nc("@title:group", "Session")
        icon: "system-shutdown"
        source: "ConfigSession.qml"
    }
    ConfigCategory {
        name: i18nc("@title:group", "Hidden Apps")
        icon: "view-hidden"
        source: "ConfigHiddenApps.qml"
    }
}
