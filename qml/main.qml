import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Game

Window {
    width: 640
    height: 480
    visible: true
    title: "Heartless"

    Game { id: game }

    Page {
        anchors.fill: parent

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            ColumnLayout {
                spacing: 10
                Layout.fillWidth: true
                Layout.fillHeight: true

                Row {
                    spacing: 10
                    Layout.fillWidth: true

                    Label {
                        font.pointSize: 16
                        text: game.player1.name
                    }

                    Image {
                        height: parent.height
                        width: height
                        fillMode: Image.PreserveAspectFit
                        source: Qt.resolvedUrl("logo.svg")
                        visible: game.player1.winner
                    }
                }

                Button {
                    text: qsTr("Shoot the moon")
                    onClicked: game.player1.shootTheMoon()
                }
            }
        }

//        Image {
//            anchors.centerIn: parent
//            width: 350
//            height: 300
//            fillMode: Image.PreserveAspectFit
//            source: Qt.resolvedUrl("logo.svg")
//        }
    }
}
