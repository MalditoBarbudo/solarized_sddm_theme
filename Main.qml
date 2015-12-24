/***************************************************************************
* Copyright (c) 2014 Inti Alonso <intialonso@gmail.com>
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge,
* publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
* OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
* ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
* OR OTHER DEALINGS IN THE SOFTWARE.
*
***************************************************************************/

import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: container
    width: 1024
    height: 768

    property int sessionIndex: session.index

    TextConstants { id: textConstants }

    Connections {
        target: sddm
        onLoginSucceeded: {
        }

        onLoginFailed: {
            txtMessage.text = textConstants.loginFailed
            listView.currentItem.password.text = ""
        }
    }

    FontLoader { id: textFont; name: "Raleway" }

    Repeater {
        model: screenModel
        Background {
            x: geometry.x; y: geometry.y; width: geometry.width; height:geometry.height
            source: config.background
            fillMode: Image.PreserveAspectCrop
            onStatusChanged: {
                if (status == Image.Error && source != config.defaultBackground) {
                    source = config.defaultBackground
                }
            }
        }
    }

    Rectangle {
        property variant geometry: screenModel.geometry(screenModel.primary)
        x: geometry.x; y: geometry.y; width: geometry.width; height: geometry.height
        color: "transparent"

        Component {
            id: userDelegate

            PictureBox {
                anchors.verticalCenter: parent.verticalCenter
                name: (model.realName === "") ? model.name : model.realName
                icon: model.icon

                focus: (listView.currentIndex === index) ? true : false
                state: (listView.currentIndex === index) ? "active" : ""

                onLogin: sddm.login(model.name, password, sessionIndex);

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: listView.currentIndex = index
                    onClicked: listView.focus = true
                }
            }
        }

        Row {
            anchors.fill: parent

            Rectangle {
                width: parent.width / 3; height: parent.height
                color: "transparent"
                anchors.verticalCenter: parent.verticalCenter
                //anchors.verticalCenterOffset:-300

                Clock {
                    id: clock
                    anchors.centerIn: parent
                    color: "black"
                    timeFont.family: textFont.name
                    dateFont.family: textFont.name
                }
            }

            Rectangle {
                width: parent.width / 3; height: parent.height
                color: "transparent"
            }

            Rectangle {
                width: parent.width / 3; height: parent.height
                color: "transparent"
                clip: true
                anchors.verticalCenter: parent.verticalCenter
                //anchors.verticalCenterOffset:300

                Item {
                    id: usersContainer
                    width: parent.width; height: 200
                    anchors.margins: 5
                    anchors.verticalCenter: parent.verticalCenter

                        Column {
                        width: parent.width / 3;
                        anchors.right: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10
                        anchors.margins: 10

                            Text {
                            id: lblName
                            width: parent.width
                            text: textConstants.userName
                            font.family: textFont.name
                            font.bold: true
                            font.pixelSize: 16
                            color: "black"
                            }

                            TextBox {
                            id: name
                            width: parent.width; height: 30
                            text: userModel.lastUser
                            font.family: textFont.name
                            font.pixelSize: 14
                            color: "#25000000"
                            borderColor: "transparent"
                            textColor: "black"

                            KeyNavigation.backtab: btnReboot; KeyNavigation.tab: password

                            Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, session.index)
                                event.accepted = true
                            }
                            }
                            }
                        }

                        Column {
                        id: columnPassword
                        width: parent.width / 3;
                        anchors.left: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10
                        anchors.margins: 10

                            Text {
                            id: lblPassword
                            width: parent.width
                            text: textConstants.password
                            font.family: textFont.name
                            font.bold: true
                            font.pixelSize: 16
                            color: "black"
                            }

                            PasswordBox {
                            id: password
                            width: parent.width; height: 30
                            font.family: textFont.name
                            font.pixelSize: 14
                            color: "#25000000"
                            borderColor: "transparent"
                            tooltipBG: "lightgrey"
                            //image: "warning.svg"

                            KeyNavigation.backtab: name; KeyNavigation.tab: session

                            Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, session.index)
                                event.accepted = true
                            }
                            }
                            }
                        }
                        Button {
                        id: loginButton
                        text: textConstants.login
                        width: parent.width /6
                        anchors.right: columnPassword.right
                        anchors.top: columnPassword.bottom
                        anchors.topMargin: 20
                        color: "red"
                        textColor: "black"
                        font: textFont.name

                        onClicked: sddm.login(name.text, password.text, session.index)

                        KeyNavigation.backtab: layoutBox; KeyNavigation.tab: btnShutdown
                        }


                }


            }
        }

        Rectangle {
            id: actionBar
            anchors.top: parent.top;
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width; height: 40
            color: "#35000000"

            Row {
                anchors.left: parent.left
                anchors.margins: 5
                height: parent.height
                spacing: 10

                Text {
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter

                    text: textConstants.session
                    font.family: textFont.name
                    font.pixelSize: 16
                    verticalAlignment: Text.AlignVCenter
                    color: "#DEDEDE"
                }

                ComboBox {
                    id: session
                    width: 245
                    height: 20
                    anchors.verticalCenter: parent.verticalCenter
                    //style: ComboBoxStyle {
                    //    id: comboBox
                    //    background: Rectangle {
                    //        id: rectCategory
                    //        radius: 5
                    //        border.width: 2
                    //        color: "#fff"
                    //    }
                    //    label: Text {
                    //        verticalAlignment: Text.AlignVCenter
                    //        horizontalAlignment: Text.AlignHCenter
                    //        font.pointSize: 15
                    //        font.family: textFont.name
                    //        font.capitalization: Font.SmallCaps
                    //        color: "black"
                    //        text: control.currentText
                    //    }
                    //}

                    arrowIcon: "angle-down.png"

                    model: sessionModel
                    index: sessionModel.lastIndex
                    font.family: textFont.name
                    font.pixelSize: 14

                    KeyNavigation.tab: layoutBox
                }

                Text {
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter

                    text: textConstants.layout
                    font.family: textFont.name
                    font.pixelSize: 16
                    verticalAlignment: Text.AlignVCenter
                    color: "#DEDEDE"
                }

                LayoutBox {
                    id: layoutBox
                    width: 90
                    height: 20
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: textFont.name
                    font.pixelSize: 14

                    arrowIcon: "angle-down.png"

                    KeyNavigation.backtab: session; KeyNavigation.tab: btnShutdown
                }
            }

            Row {
                height: parent.height
                anchors.right: parent.right
                anchors.margins: 5
                spacing: 10

                ImageButton {
                    id: btnReboot
                    height: parent.height
                    source: "reboot.svg"

                    visible: sddm.canReboot

                    onClicked: sddm.reboot()

                    KeyNavigation.backtab: layoutBox; KeyNavigation.tab: btnShutdown
                }

                ImageButton {
                    id: btnShutdown
                    height: parent.height
                    source: "shutdown.svg"

                    visible: sddm.canPowerOff

                    onClicked: sddm.powerOff()

                    KeyNavigation.backtab: btnReboot;
                }
            }
        }
    }
}
