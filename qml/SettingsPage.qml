import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt.labs.settings

Page {
    id: settingsPageRoot

    signal goBack()

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
                    onClicked: settingsPageRoot.goBack()
                    display: toolBar.width < 500 ? ToolButton.IconOnly : ToolButton.TextBesideIcon
                }

                Item { Layout.fillWidth: true }
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
                contentWidth: mainLayout.width
                contentHeight: mainLayout.height
                anchors.margins: 10
                leftMargin: 10
                rightMargin: 10
                bottomMargin: 10
                topMargin: 10

                GridLayout {
                    id: mainLayout

                    width: sv.width
                    columns: 2

                    Label { text: qsTr("Animation") }

                    ComboBox {
                        textRole: "text"
                        valueRole: "value"
                        onActivated: settings.animation = currentValue
                        currentIndex: settings.animation
                        model: ListModel {
                            ListElement {
                                text: qsTr("Balloon")
                                value: AnimType.Balloon
                            }
                            ListElement {
                                text: qsTr("Fountain")
                                value: AnimType.Fountain
                            }
                            ListElement {
                                text: qsTr("None")
                                value: AnimType.None
                            }
                        }
                    }
                }
            }
        }
    }
}