import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt.labs.settings

Page {
    id: settingsPageRoot

    ListModel {
        id: colorModel

        ListElement { text: "Red"; value: Material.Red }
        ListElement { text: "Pink"; value: Material.Pink }
        ListElement { text: "Purple"; value: Material.Purple }
        ListElement { text: "DeepPurple"; value: Material.DeepPurple }
        ListElement { text: "Indigo"; value: Material.Indigo }
        ListElement { text: "Blue"; value: Material.Blue }
        ListElement { text: "LightBlue"; value: Material.LightBlue }
        ListElement { text: "Cyan"; value: Material.Cyan }
        ListElement { text: "Teal"; value: Material.Teal }
        ListElement { text: "Green"; value: Material.Green }
        ListElement { text: "LightGreen"; value: Material.LightGreen }
        ListElement { text: "Lime"; value: Material.Lime }
        ListElement { text: "Yellow"; value: Material.Yellow }
        ListElement { text: "Amber"; value: Material.Amber }
        ListElement { text: "Orange"; value: Material.Orange }
        ListElement { text: "DeepOrange"; value: Material.DeepOrange }
        ListElement { text: "Brown"; value: Material.Brown }
        ListElement { text: "Grey"; value: Material.Grey }
        ListElement { text: "BlueGrey"; value: Material.BlueGrey }
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

                    GridLayout {
                        id: mainLayout

                        width: Math.min(sv.width - 20, 500)
                        anchors.horizontalCenter: mainLayoutContainer.horizontalCenter
                        columns: 2
                        columnSpacing: 10
                        rowSpacing: 10

                        Label {
                            text: qsTr("Target score")
                            Layout.fillWidth: true
                        }

                        SpinBox {
                            Layout.alignment: Qt.AlignRight
                            from: 13
                            to: 2147483647 // INT_MAX according to docs.microsoft.com/en-us/cpp/cpp/integer-limits
                            value: settings.targetScore
                            onValueChanged: settings.targetScore = value
                            editable: true
                        }

                        Label {
                            text: qsTr("End-of-game animation")
                            Layout.fillWidth: true
                        }

                        ComboBox {
                            Layout.alignment: Qt.AlignRight
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

                        Label {
                            text: "App theme"
                            Layout.fillWidth: true
                        }

                        ComboBox {
                            Layout.alignment: Qt.AlignRight
                            textRole: "text"
                            valueRole: "value"
                            currentIndex: settings.theme
                            onActivated: settings.theme = currentValue
                            model: ListModel {
                                ListElement { text: qsTr("Light"); value: Material.Light }
                                ListElement { text: qsTr("Dark"); value: Material.Dark }
                                ListElement { text: qsTr("System"); value: Material.System }
                            }
                        }

                        Label {
                            text: "App primary color"
                            Layout.fillWidth: true
                        }

                        ComboBox {
                            Layout.alignment: Qt.AlignRight
                            textRole: "text"
                            valueRole: "value"
                            currentIndex: settings.primary
                            onActivated: settings.primary = currentValue
                            model: colorModel
                        }

                        Label {
                            text: "App accent color"
                            Layout.fillWidth: true
                        }

                        ComboBox {
                            Layout.alignment: Qt.AlignRight
                            textRole: "text"
                            valueRole: "value"
                            currentIndex: settings.accent
                            onActivated: settings.accent = currentValue
                            model: colorModel
                        }
                    }
                }
            }
        }
    }
}
