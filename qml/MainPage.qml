import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Particles
import Qt.labs.settings

import Game

Page {
    id: mainPageRoot

    Component.onCompleted: {
        if (game.savedGameAvailable())
        {
            let dialog = restoreSavedGameDlg.createObject(mainPageRoot)
            dialog.open()
        }
    }

    Connections {
        function onGameOverChanged()
        {
            if (game.gameOver && (settings.animation !== AnimType.None) && (rootStackView.currentItem === mainPageRoot))
                emitter.emitter.pulse(2000)
        }

        target: game
    }

    Component {
        id: historyPageComponent

        HistoryPage {}
    }

    Component {
        id: confirmResetGame

        Dialog {
            title: qsTr("Reset game?")
            anchors.centerIn: parent
            standardButtons: Dialog.Ok | Dialog.Cancel
            onAccepted: game.reset()
            modal: true

            Label {
                text: qsTr("Really reset the game?")
            }
        }
    }

    Component {
        id: restoreSavedGameDlg

        Dialog {
            title: qsTr("Restore saved game?")
            anchors.centerIn: mainPageRoot
            standardButtons: Dialog.Ok | Dialog.Cancel
            onAccepted: game.restoreSavedGame()
            onRejected: game.deleteSavedGame()
            modal: true

            Label {
                text: qsTr("It looks like you didn't finish your last game. Do you want to pick up where you left off?")
                wrapMode: Label.WordWrap
                width: parent.width
            }
        }
    }

    Component {
        id: changePlayerNameDialog

        Dialog {
            id: changePlayerNameDialogImpl

            property int index

            title: qsTr("Change player's name")
            anchors.centerIn: mainPageRoot
            standardButtons: Dialog.Ok | Dialog.Cancel
            onAccepted: game.players[index].name = nameInput.text
            modal: true
            focus: true

            TextField {
                id: nameInput

                text: game.players[index].name
                anchors.fill: parent
                onAccepted: changePlayerNameDialogImpl.accept()
                selectByMouse: true
                Component.onCompleted: selectAll()
                focus: true
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        ToolBar {
            id: toolBar

            property int buttonDisplay: toolBar.width < 650 ? ToolButton.IconOnly : ToolButton.TextBesideIcon

            Layout.fillWidth: true

            RowLayout {
                anchors.fill: parent

                ToolButton {
                    text: qsTr("Add scores")
                    icon.source: Qt.resolvedUrl("plus.svg")
                    enabled: game.stagingScoresReady
                    onClicked: game.commitStagingScores()
                    ToolTip.text: text
                    ToolTip.visible: hovered
                    ToolTip.delay: 1000
                    display: toolBar.buttonDisplay
                }

                ToolButton {
                    text: qsTr("Score history")
                    icon.source: Qt.resolvedUrl("history.svg")
                    ToolTip.text: text
                    ToolTip.visible: hovered
                    ToolTip.delay: 1000
                    display: toolBar.buttonDisplay
                    onClicked: rootStackView.push(historyPageComponent)
                }

                ToolButton {
                    text: qsTr("Undo")
                    icon.source: Qt.resolvedUrl("undo.svg")
                    enabled: game.players[0].scores.length > 0
                    onClicked: game.undoLastMove()
                    ToolTip.text: text
                    ToolTip.visible: hovered
                    ToolTip.delay: 1000
                    display: toolBar.buttonDisplay
                }

                ToolButton {
                    text: qsTr("Redo")
                    icon.source: Qt.resolvedUrl("redo.svg")
                    enabled: game.players[0].redoScores.length > 0
                    onClicked: game.redo()
                    ToolTip.text: text
                    ToolTip.visible: hovered
                    ToolTip.delay: 1000
                    display: toolBar.buttonDisplay
                }

                ToolButton {
                    text: qsTr("Reset game")
                    icon.source: Qt.resolvedUrl("reset.svg")
                    onClicked: {
                        let dialog = confirmResetGame.createObject(mainPageRoot)
                        dialog.open()
                    }
                    ToolTip.text: text
                    ToolTip.visible: hovered
                    ToolTip.delay: 1000
                    display: toolBar.buttonDisplay
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

                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            RowLayout {
                                id: userControlRow

                                Layout.preferredWidth: del.width
                                spacing: 0

                                Label {
                                    id: name

                                    Layout.fillWidth: true
                                    // TODO: I set this to + 1 so "North" won't elide at startup. Fix this.
                                    Layout.maximumWidth: implicitWidth + 1
                                    font.pixelSize: 20
                                    text: game.players[index].name
                                    font.bold: true
                                    elide: Text.ElideRight
                                }

                                ToolButton {
                                    icon.source: Qt.resolvedUrl("edit.svg")
                                    ToolTip.text: qsTr("Edit name")
                                    ToolTip.visible: hovered
                                    ToolTip.delay: 1000
                                    onClicked: {
                                        let dialog = changePlayerNameDialog.createObject(mainPageRoot, {
                                            "index": index
                                        })
                                        dialog.open()
                                    }
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
                                    text: qsTr("Shoot the moon")
                                    ToolTip.text: text
                                    ToolTip.visible: hovered
                                    ToolTip.delay: 1000
                                    display: mainLayout.width / mainLayout.columns < 305 ? ToolButton.IconOnly : ToolButton.TextBesideIcon
                                }
                            }

                            Label {
                                font.pixelSize: 20
                                text: game.players[index].score
                            }

                            TextField {
                                id: pointInput

                                placeholderText: qsTr("Add points")
                                validator: IntValidator { bottom: 0; top: 25 }
                                onTextChanged: game.players[index].stagingScore = text
                                enabled: !game.gameOver
                                inputMethodHints: Qt.ImhDigitsOnly

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
