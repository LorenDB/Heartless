import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts

Page {
    id: historyPageRoot

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
                    display: toolBar.width < 500 ? ToolButton.IconOnly : ToolButton.TextBesideIcon
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

                    GridLayout {
                        id: mainLayout

                        width: Math.max(sv.width, 100) - 20
                        columnSpacing: 10
                        rowSpacing: 10
                        columns: Math.min(Math.max(width / 170, 1), 4)

                        Repeater {
                            model: 4
                            delegate: ColumnLayout {
                                id: del

                                // for the nested Repeater
                                property int playerIndex: index
                                spacing: 10
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                RowLayout {
                                    spacing: 10
                                    Layout.preferredWidth: del.width

                                    Label {
                                        id: name

                                        font.pixelSize: 22
                                        text: game.players[index].name
                                        font.bold: true
                                    }

                                    Image {
                                        Layout.preferredHeight: name.height
                                        Layout.preferredWidth: height
                                        fillMode: Image.PreserveAspectFit
                                        source: Qt.resolvedUrl("logo.svg")
                                        visible: game.players[index].winner
                                    }

                                    Item { Layout.fillWidth: true }
                                }

                                Repeater {
                                    model: game.players[del.playerIndex].scores
                                    delegate: Label {
                                        text: qsTr("Round ") + (index + 1) + ": " + game.players[del.playerIndex].scores[index]
                                    }
                                }

                                Label {
                                    font.pixelSize: 20
                                    text: qsTr("Total: ") + game.players[index].score
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
