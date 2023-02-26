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
    minimumWidth: 320
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
        // TODO: do same with mouse back button
    }

    Settings {
        id: settings

        property int animation: AnimType.Fountain
        property int theme: Material.System
        property int primary: Material.Indigo
        property int accent: Material.Pink
        property int targetScore: 100
        property bool showPassDirectionPopup: true
    }

    Game {
        id: game

        targetScore: settings.targetScore
    }

    Drawer {
        id: drawer

        edge: Qt.RightEdge
        height: rootWindow.height
        width: Math.min(300, rootWindow.width * 0.667)

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            ItemDelegate {
                Layout.fillWidth: true
                text: qsTr("Settings")
                icon.source: Qt.resolvedUrl("settings.svg")
                onClicked: {
                    drawer.close()
                    rootStackView.push(settingsPageComponent)
                }
            }

            ItemDelegate {
                Layout.fillWidth: true
                text: qsTr("View license online")
                icon.source: Qt.resolvedUrl("license.svg")
                onClicked: {
                    drawer.close()
                    // TODO: figure out how to open actual license file in QML
                    Qt.openUrlExternally("https://github.com/LorenDB/Heartless/blob/master/LICENSE")
                }
            }

            ItemDelegate {
                Layout.fillWidth: true
                text: qsTr("View code online")
                icon.source: Qt.resolvedUrl("code.svg")
                onClicked: {
                    drawer.close()
                    Qt.openUrlExternally("https://github.com/LorenDB/Heartless")
                }
            }

            ItemDelegate {
                Layout.fillWidth: true
                text: qsTr("About Heartless")
                icon.source: Qt.resolvedUrl("info.svg")
                onClicked: {
                    drawer.close()
                    rootStackView.push(aboutPageComponent)
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

    Component {
        id: aboutPageComponent

        AboutPage {}
    }

    ToolBar {
        id: toolBar

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        RowLayout {
            anchors.fill: parent

            ToolButton {
                icon.source: Qt.resolvedUrl("back.svg")
                text: qsTr("Back")
                visible: rootStackView.depth > 1
                ToolTip.text: text
                ToolTip.visible: hovered
                ToolTip.delay: 1000
                onClicked: rootStackView.pop()
                display: toolBar.width < 650 ? ToolButton.IconOnly : ToolButton.TextBesideIcon
            }

            Repeater {
                model: rootStackView.currentItem.toolbarButtons ?? 0
                delegate: Loader { sourceComponent: rootStackView.currentItem.toolbarButtons[index] }
            }

            Item { Layout.fillWidth: true }

            ToolButton {
                icon.source: Qt.resolvedUrl("hamburger-menu.svg")
                ToolTip.text: qsTr("Menu")
                ToolTip.visible: hovered
                ToolTip.delay: 1000
                onClicked: drawer.open()
            }
        }
    }

    StackView {
        id: rootStackView

        anchors.top: toolBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        initialItem: mainPageComponent
    }
}
