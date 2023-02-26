import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt.labs.settings

Page {
    id: settingsPageRoot

    ListModel {
        id: colorModel

        ListElement { text: qsTr("Red"); value: Material.Red }
        ListElement { text: qsTr("Pink"); value: Material.Pink }
        ListElement { text: qsTr("Purple"); value: Material.Purple }
        ListElement { text: qsTr("Deep purple"); value: Material.DeepPurple }
        ListElement { text: qsTr("Indigo"); value: Material.Indigo }
        ListElement { text: qsTr("Blue"); value: Material.Blue }
        ListElement { text: qsTr("Light blue"); value: Material.LightBlue }
        ListElement { text: qsTr("Cyan"); value: Material.Cyan }
        ListElement { text: qsTr("Teal"); value: Material.Teal }
        ListElement { text: qsTr("Green"); value: Material.Green }
        ListElement { text: qsTr("Light green"); value: Material.LightGreen }
        ListElement { text: qsTr("Lime"); value: Material.Lime }
        ListElement { text: qsTr("Yellow"); value: Material.Yellow }
        ListElement { text: qsTr("Amber"); value: Material.Amber }
        ListElement { text: qsTr("Orange"); value: Material.Orange }
        ListElement { text: qsTr("Deep orange"); value: Material.DeepOrange }
        ListElement { text: qsTr("Brown"); value: Material.Brown }
        ListElement { text: qsTr("Grey"); value: Material.Grey }
        ListElement { text: qsTr("Blue-grey"); value: Material.BlueGrey }
    }

    ScrollView {
        id: sv

        clip: true
        anchors.fill: parent

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
                        text: qsTr("Show pass direction for each round")
                        Layout.fillWidth: true
                    }

                    Switch {
                        Layout.alignment: Qt.AlignRight
                        checked: settings.showPassDirectionPopup
                        onCheckedChanged: settings.showPassDirectionPopup = checked
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
