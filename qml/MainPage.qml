import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Particles
import Qt.labs.settings

import Game

Page {
    id: mainPageRoot

    Connections {
        function onGameOverChanged()
        {
            if (game.gameOver && settings.animation != AnimType.None)
                emitter.emitter.pulse(2000)
        }

        target: game
    }

    Dialog {
        id: confirmResetGame

        title: qsTr("Reset game?")
        anchors.centerIn: parent
        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: game.reset()
        modal: true

        Label {
            text: qsTr("Really reset the game?")
        }
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
                    text: qsTr("Add scores")
                    icon.source: Qt.resolvedUrl("plus.svg")
                    enabled: game.stagingScoresReady
                    onClicked: game.commitStagingScores()
                    ToolTip.text: text
                    display: toolBar.width < 500 ? ToolButton.IconOnly : ToolButton.TextBesideIcon
                }

                ToolButton {
                    text: qsTr("Score history")
                    icon.source: Qt.resolvedUrl("history.svg")
                    ToolTip.text: text
                    display: toolBar.width < 500 ? ToolButton.IconOnly : ToolButton.TextBesideIcon
                    // TODO: add this functionality
                    enabled: false
                }

                ToolButton {
                    text: qsTr("Reset game")
                    icon.source: Qt.resolvedUrl("reset.svg")
                    onClicked: confirmResetGame.open()
                    ToolTip.text: text
                    display: toolBar.width < 500 ? ToolButton.IconOnly : ToolButton.TextBesideIcon
                }

                Item { Layout.fillWidth: true }

                ToolButton {
                    icon.source: Qt.resolvedUrl("hamburger-menu.svg")
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
                width: parent.width
                height: parent.height
                contentWidth: mainLayout.width
                contentHeight: mainLayout.height
                anchors.margins: 10
                leftMargin: 10
                rightMargin: 10
                bottomMargin: 10
                topMargin: 10

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

                            spacing: 10
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            RowLayout {
                                spacing: 10
                                Layout.preferredWidth: del.width

                                Label {
                                    id: name

                                    font.pointSize: 16
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

                                ToolButton {
                                    icon.source: Qt.resolvedUrl("moon.svg")
                                    onClicked: game.players[index].shootTheMoon()
                                    enabled: !game.gameOver
                                    height: name.implicitHeight
                                    text: qsTr("Shoot the moon")
                                    ToolTip.text: text
                                    display: mainLayout.width / mainLayout.columns < 250 ? ToolButton.IconOnly : ToolButton.TextBesideIcon
                                }
                            }

                            Label {
                                font.pointSize: 12
                                text: game.players[index].score
                            }

                            TextField {
                                id: pointInput

                                placeholderText: qsTr("Add points")
                                validator: IntValidator { bottom: 0; top: 25 }
                                onTextChanged: game.players[index].stagingScore = text
                                enabled: !game.gameOver

                                Connections {
                                    function onStagingScoreReset() {
                                        pointInput.clear()
                                    }

                                    target: game.players[index]
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    ParticleSystem { id: sys }

    MultiStyleEmitter {
        id: emitter

        particleSystem: sys
        anchors.fill: parent
    }
}
