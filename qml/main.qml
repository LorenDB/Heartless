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
    Material.theme: Material.Dark

    Settings {
        id: settings

        property var animation: AnimType.Fountain
    }

    Game { id: game }

    Drawer {
        id: drawer

        edge: Qt.RightEdge
        height: rootWindow.height
        width: Math.min(300, rootWindow.width * 0.667)

        ColumnLayout {
            anchors.fill: parent

            ToolButton {
                Layout.fillWidth: true
                text: qsTr("Settings")
                onClicked: {
                    drawer.close()
                    sv.push(settingsPageComponent)
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

        SettingsPage { onGoBack: sv.pop() }
    }

    StackView {
        id: sv

        anchors.fill: parent
        initialItem: mainPageComponent
    }
}
