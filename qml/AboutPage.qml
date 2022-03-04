import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts

Page {
    id: aboutPageRoot

    ListModel {
        id: aboutInfoModel

        ListElement { fontPixelSize: 24; data: qsTr("Heartless") }
        ListElement { fontPixelSize: 16; data: qsTr("Heartless simplifies tracking scores in your Hearts games.") }
        ListElement { fontPixelSize: 16; data: qsTr("Copyright © Loren Burkholder 2022. All rights reserved. See license for details.") }
        ListElement { fontPixelSize: 24; data: qsTr("Usage") }
        ListElement { fontPixelSize: 16; data: qsTr("To add scores, type them into the score input under each user or click the shoot-the-moon button. Use the buttons at the top of the app to undo, redo, or reset the game. If you want to play to a score other than 100, simply change the target score in the settings.") }
        ListElement { fontPixelSize: 24; data: qsTr("Fun facts") }
        ListElement { fontPixelSize: 16; data: qsTr("The main functionality of Heartless was written over a two-week span.") }
        ListElement { fontPixelSize: 16; data: qsTr("Heartless includes several end-of-game animations for you to choose from!") }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        ToolBar {
            id: toolBar

            Layout.fillWidth: true

            RowLayout {
                anchors.fill: parent

                ToolButton {
                    icon.source: Qt.resolvedUrl("back.svg")
                    text: qsTr("Back")
                    ToolTip.text: text
                    ToolTip.visible: hovered
                    onClicked: rootStackView.pop()
                    display: toolBar.width < 650 ? ToolButton.IconOnly : ToolButton.TextBesideIcon
                }

                Item { Layout.fillWidth: true }

                ToolButton {
                    icon.source: Qt.resolvedUrl("hamburger-menu.svg")
                    ToolTip.text: qsTr("Menu")
                    ToolTip.visible: hovered
                    onClicked: drawer.open()
                }
            }
        }

        ScrollView {
            id: sv

            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true

            Flickable {
                width: sv.width
                height: sv.height
                contentWidth: mainLayoutContainer.width
                contentHeight: mainLayoutContainer.height
                anchors.margins: 10
                leftMargin: 10
                rightMargin: 10
                bottomMargin: 10
                topMargin: 10

                Item {
                    id: mainLayoutContainer
                    width: sv.width - 20
                    height: mainLayout.implicitHeight

                    ColumnLayout {
                        id: mainLayout

                        width: Math.min(sv.width - 20, 500)
                        anchors.horizontalCenter: mainLayoutContainer.horizontalCenter
                        spacing: 10

                        Repeater {
                            model: aboutInfoModel
                            delegate: Label {
                                required property string data
                                required property int fontPixelSize

                                Layout.fillWidth: true
                                text: data
                                wrapMode: Label.WordWrap
                                font.pixelSize: fontPixelSize
                                font.bold: fontPixelSize > 20
                            }
                        }
                    }
                }
            }
        }
    }
}
