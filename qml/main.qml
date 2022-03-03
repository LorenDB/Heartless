import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Particles
import Qt.labs.settings

import Game

Window {
    id: rootWindow

    width: 460
    height: 614
    minimumWidth: 225
    visible: true
    title: "Heartless"
    Material.theme: settings.theme
    Material.primary: settings.primary
    Material.accent: settings.accent
    // this back key handling method comes from https://stackoverflow.com/a/67357598/12533859
    Component.onCompleted: {
        contentItem.Keys.released.connect(function(event) {
            if (event.key === Qt.Key_Back && rootStackView.depth > 1) {
                event.accepted = true
                rootStackView.pop()
            }
            else
                event.accepted = false
        })
    }

    Settings {
        id: settings

        property int animation: AnimType.Fountain
        property int theme: Material.System
        property int primary: Material.Indigo
        property int accent: Material.Pink
    }

    Game { id: game }

    Drawer {
        id: drawer

        edge: Qt.RightEdge
        height: rootWindow.height
        width: Math.min(300, rootWindow.width * 0.667)

        ColumnLayout {
            anchors.fill: parent

            ItemDelegate {
                Layout.fillWidth: true
                text: qsTr("Settings")
                icon.source: Qt.resolvedUrl("settings.svg")
                onClicked: {
                    drawer.close()
                    rootStackView.push(settingsPageComponent)
                }
            }

            Item { Layout.fillHeight: true }
        }
    }

    Component {
        id: mainPageComponent

        MainPage {}
    }

    Component {
        id: settingsPageComponent

        SettingsPage {}
    }

    StackView {
        id: rootStackView

        anchors.fill: parent
        initialItem: mainPageComponent
    }
}
