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

              Rectangle{
                width: parent.width / 3; height: parent.height
                color: "transparent"
              }


              Rectangle {
                width: parent.width / 3; height: parent.height
                color: "transparent"
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset:200

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
                clip: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset:200

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
                      tooltipBG: "#25000000"
                      image: "warning.svg"

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
                        color: "#268bd2"
                        disabledColor: "#dc322f"
                        activeColor: "#268bd2"
                        pressedColor: "#2aa198"
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
            color: "transparent"

            Row {
                anchors.left: parent.left
                anchors.margins: 5
                height: parent.height
                spacing: 10

                Text {
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter

                    //text: textConstants.session
                    text: ""
                    font.family: textFont.name
                    font.pixelSize: 16
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                    color: "#b58900"
                }

                ComboBox {
                    id: session
                    width: 245
                    height: 20
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#25000000"
                    textColor: "#b58900"
                    borderColor: "transparent"
                    hoverColor: "#073642"
                    arrowIcon: "angle-down.svg"
                    //arrowColor: "#25000000"

                    model: sessionModel
                    index: sessionModel.lastIndex
                    font.family: textFont.name
                    font.pixelSize: 14
                    //dropDown.color: "transparent"

                    KeyNavigation.tab: layoutBox
                }

                Text {
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter

                    //text: textConstants.layout
                    text: ""
                    font.family: textFont.name
                    font.pixelSize: 16
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                    color: "#b58900"
                }

                //LayoutBox {
                //    id: layoutBox
                //    width: 90
                //    height: 20
                //    anchors.verticalCenter: parent.verticalCenter
                //    font.family: textFont.name
                //    font.pixelSize: 14
                //    color: "#25000000"
                //    textColor: "#b58900"
                //    borderColor: "transparent"

                //    arrowIcon: "angle-down.svg"

                //    KeyNavigation.backtab: session; KeyNavigation.tab: btnShutdown
                //}
                ComboBox {
                    id: layoutBox

                    model: keyboard.layouts
                    index: keyboard.currentLayout
                    width: 50
                    height: 20
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#25000000"
                    textColor: "#b58900"
                    borderColor: "transparent"
                    hoverColor: "#073642"
                    arrowIcon: "angle-down.svg"
                    //arrowColor: "#25000000"

                    onValueChanged: keyboard.currentLayout = id

                    Connections {
                        target: keyboard

                        onCurrentLayoutChanged: combo.index = keyboard.currentLayout
                    }

                    rowDelegate: Rectangle {
                        color: "transparent"

                        Text {
                            anchors.margins: 4
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom

                            verticalAlignment: Text.AlignVCenter

                            text: modelItem ? modelItem.modelData.shortName : "zz"
                            font.family: textFont.name
                            font.pixelSize: 14
                            color: "#b58900"
                        }
                    }
                    KeyNavigation.backtab: session; KeyNavigation.tab: btnShutdown
                }
            }

            Row {
                height: parent.height
                anchors.right: parent.right
                //anchors.left: actionBar.right
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
