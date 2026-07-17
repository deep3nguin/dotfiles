/***************************************************************************
* Copyright (c) 2013 Abdurrahman AVCI <abdurrahmanavci@gmail.com>
* Copyright (c) 2026 QN37X Light Editorial SDDM Theme
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
    width: 640
    height: 480

    // Set text direction mirroring based on locale settings
    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int sessionIndex: session.index

    TextConstants { id: textConstants }

    // Connect SDDM login signals to error message states
    Connections {
        target: sddm

        onLoginSucceeded: {
            errorMessage.color = "#41a1cf" // Use Signal Blue for success text
            errorMessage.text = textConstants.loginSucceeded
        }
        onLoginFailed: {
            passwordField.text = "" // Reset password input on login failure
            errorMessage.color = "#1f1f29" // Use Dusk color for failure text
            errorMessage.text = textConstants.loginFailed
        }
        onInformationMessage: {
            errorMessage.color = "#1f1f29" // Use Dusk color for messages
            errorMessage.text = message
        }
    }

    // Load the background configured in theme.conf, fallback if error
    Background {
        anchors.fill: parent
        source: Qt.resolvedUrl(config.background)
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            var defaultBackground = Qt.resolvedUrl(config.defaultBackground)
            if (status == Image.Error && source != defaultBackground) {
                source = defaultBackground
            }
        }
    }

    // Main layout container holding clock and card
    Rectangle {
        anchors.fill: parent
        color: "transparent"

        // Elegant clock at the top right of the screen
        Clock {
            id: clock
            anchors.margins: 24 // Increased margins for spaciousness
            anchors.top: parent.top
            anchors.right: parent.right
            color: "#ffffff" // Softer white text for contrast on wallpaper
            timeFont.family: "ppmondwest, Fraunces, Georgia, serif" // Serif font for clock
            timeFont.pixelSize: 48 // Large display style size
        }

        // Subtle shadow representation under the login card
        Rectangle {
            id: shadowRect
            anchors.fill: loginCard
            anchors.topMargin: 4
            anchors.leftMargin: 4
            anchors.bottomMargin: -4
            anchors.rightMargin: -4
            color: "#0c000000" // 5% black transparency for soft shadow
            radius: 12 // Matches card corner radius
            z: loginCard.z - 1
        }

        // The White Content Card containing login interface
        Rectangle {
            id: loginCard
            anchors.centerIn: parent
            width: 380 // Comfortable card width
            height: mainColumn.implicitHeight + 56 // Dynamic height with comfortable padding
            radius: 12 // 12px border-radius as per DESIGN.md
            color: "#ffffff" // Paper background
            border.color: "#dee2de" // Mist border color
            border.width: 1 // 1px border

            Column {
                id: mainColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 28 // Spacious internal padding
                spacing: 20 // Standard spacing between form elements

                // Card Heading section
                Column {
                    width: parent.width
                    spacing: 4

                    Text {
                        width: parent.width
                        text: textConstants.welcomeText.arg(sddm.hostName)
                        font.family: "ppmondwest, Fraunces, Georgia, serif" // Main display serif font
                        font.pixelSize: 24 // Subheading size
                        color: "#2c2c2c" // Graphite text color
                        horizontalAlignment: Text.AlignLeft
                        wrapMode: Text.WordWrap
                    }

                    Text {
                        width: parent.width
                        text: "Sign in to your workspace"
                        font.family: "af, Inter, sans-serif" // Utility sans font
                        font.pixelSize: 13 // Caption size
                        color: "#646464" // Ash text color
                        horizontalAlignment: Text.AlignLeft
                    }
                }

                // Username input field container
                Column {
                    width: parent.width
                    spacing: 6

                    Text {
                        text: textConstants.userName
                        font.family: "af, Inter, sans-serif"
                        font.pixelSize: 12 // Small label size
                        font.weight: Font.Medium
                        color: "#646464" // Ash label color
                    }

                    FocusScope {
                        id: usernameField
                        width: parent.width
                        height: 38

                        property alias text: textInput.text

                        Rectangle {
                            anchors.fill: parent
                            color: "#f9faf7" // Linen background
                            radius: 0 // Flat edges (0px border-radius)

                            // Underline only border
                            Rectangle {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                height: 1
                                color: "#444141" // Charcoal border
                            }
                        }

                        TextInput {
                            id: textInput
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            verticalAlignment: TextInput.AlignVCenter
                            color: "#444141" // Charcoal text color
                            font.family: "af, Inter, sans-serif"
                            font.pixelSize: 14
                            focus: true
                            clip: true

                            KeyNavigation.tab: passwordField // Tab navigation to password field

                            Keys.onPressed: function(event) {
                                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                    sddm.login(usernameField.text, passwordField.text, sessionIndex)
                                    event.accepted = true
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.IBeamCursor
                            onClicked: usernameField.focus = true
                        }
                    }
                }

                // Password input field container
                Column {
                    width: parent.width
                    spacing: 6

                    Text {
                        text: textConstants.password
                        font.family: "af, Inter, sans-serif"
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        color: "#646464"
                    }

                    FocusScope {
                        id: passwordField
                        width: parent.width
                        height: 38

                        property alias text: passwordInput.text

                        Rectangle {
                            anchors.fill: parent
                            color: "#f9faf7" // Linen background
                            radius: 0 // Flat edges (0px border-radius)

                            // Underline only border
                            Rectangle {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                height: 1
                                color: "#444141" // Charcoal border
                            }
                        }

                        TextInput {
                            id: passwordInput
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            verticalAlignment: TextInput.AlignVCenter
                            color: "#444141"
                            font.family: "af, Inter, sans-serif"
                            font.pixelSize: 14
                            echoMode: TextInput.Password // Mask password input
                            passwordCharacter: "\u25cf" // Dot character
                            clip: true

                            KeyNavigation.backtab: usernameField
                            KeyNavigation.tab: session

                            Keys.onPressed: function(event) {
                                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                    sddm.login(usernameField.text, passwordField.text, sessionIndex)
                                    event.accepted = true
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.IBeamCursor
                            onClicked: passwordField.focus = true
                        }
                    }
                }

                // Session selector row (includes keyboard layout selection if active)
                Row {
                    width: parent.width
                    spacing: 12

                    Column {
                        width: (keyboard.enabled && keyboard.layouts.length > 0) ? (parent.width - 12) * 0.6 : parent.width
                        spacing: 6

                        Text {
                            text: textConstants.session
                            font.family: "af, Inter, sans-serif"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            color: "#646464"
                        }

                        ComboBox {
                            id: session
                            width: parent.width
                            height: 36
                            color: "#f9faf7" // Linen background for selector box
                            borderColor: "#dee2de" // Mist border color
                            focusColor: "#41a1cf" // Signal Blue focus color
                            hoverColor: "#f9faf7"
                            menuColor: "#ffffff" // Paper menu background
                            textColor: "#444141" // Charcoal text
                            arrowIcon: Qt.resolvedUrl("angle-down.png")
                            model: sessionModel
                            index: sessionModel.lastIndex
                            font.family: "af, Inter, sans-serif"
                            font.pixelSize: 14

                            KeyNavigation.backtab: passwordField
                            KeyNavigation.tab: (keyboard.enabled && keyboard.layouts.length > 0) ? layoutBox : shutdownButton
                        }
                    }

                    Column {
                        width: (parent.width - 12) * 0.4
                        spacing: 6
                        visible: keyboard.enabled && keyboard.layouts.length > 0

                        Text {
                            text: textConstants.layout
                            font.family: "af, Inter, sans-serif"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            color: "#646464"
                        }

                        LayoutBox {
                            id: layoutBox
                            width: parent.width
                            height: 36
                            color: "#f9faf7"
                            borderColor: "#dee2de"
                            focusColor: "#41a1cf"
                            hoverColor: "#f9faf7"
                            menuColor: "#ffffff"
                            textColor: "#444141"
                            arrowIcon: Qt.resolvedUrl("angle-down.png")
                            font.family: "af, Inter, sans-serif"
                            font.pixelSize: 14

                            KeyNavigation.backtab: session
                            KeyNavigation.tab: shutdownButton
                        }
                    }
                }

                // Error message output
                Text {
                    id: errorMessage
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: textConstants.prompt
                    font.family: "af, Inter, sans-serif"
                    font.pixelSize: 12
                    color: "#646464"
                    wrapMode: Text.WordWrap
                }

                // Buttons container block (Shutdown, Reboot, Login)
                Row {
                    width: parent.width
                    spacing: 8

                    // Outlined Shutdown button (Secondary action)
                    FocusScope {
                        id: shutdownButton
                        width: (parent.width - 16) / 3
                        height: 36

                        Rectangle {
                            id: shutdownRect
                            anchors.fill: parent
                            radius: 8 // 8px radius as per DESIGN.md
                            color: shutdownButton.activeFocus ? "#f9faf7" : "transparent"
                            border.color: "#282834" // Twilight border color
                            border.width: shutdownButton.activeFocus ? 2 : 1

                            Text {
                                anchors.centerIn: parent
                                text: textConstants.shutdown
                                color: "#282834" // Twilight text color
                                font.family: "af, Inter, sans-serif"
                                font.pixelSize: 13
                                font.weight: Font.Medium
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: sddm.powerOff()
                            onEntered: shutdownRect.opacity = 0.7
                            onExited: shutdownRect.opacity = 1.0
                        }

                        Keys.onPressed: function(event) {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.powerOff()
                                event.accepted = true
                            }
                        }

                        KeyNavigation.backtab: (keyboard.enabled && keyboard.layouts.length > 0) ? layoutBox : session
                        KeyNavigation.tab: rebootButton
                    }

                    // Outlined Reboot button (Secondary action)
                    FocusScope {
                        id: rebootButton
                        width: (parent.width - 16) / 3
                        height: 36

                        Rectangle {
                            id: rebootRect
                            anchors.fill: parent
                            radius: 8
                            color: rebootButton.activeFocus ? "#f9faf7" : "transparent"
                            border.color: "#282834" // Twilight border color
                            border.width: rebootButton.activeFocus ? 2 : 1

                            Text {
                                anchors.centerIn: parent
                                text: textConstants.reboot
                                color: "#282834" // Twilight text color
                                font.family: "af, Inter, sans-serif"
                                font.pixelSize: 13
                                font.weight: Font.Medium
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: sddm.reboot()
                            onEntered: rebootRect.opacity = 0.7
                            onExited: rebootRect.opacity = 1.0
                        }

                        Keys.onPressed: function(event) {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.reboot()
                                event.accepted = true
                            }
                        }

                        KeyNavigation.backtab: shutdownButton
                        KeyNavigation.tab: loginButton
                    }

                    // Outlined Login button (Primary action)
                    FocusScope {
                        id: loginButton
                        width: (parent.width - 16) / 3
                        height: 36

                        Rectangle {
                            id: loginRect
                            anchors.fill: parent
                            radius: 8
                            color: loginButton.activeFocus ? "#f9faf7" : "transparent"
                            border.color: "#41a1cf" // Signal Blue border color
                            border.width: loginButton.activeFocus ? 2 : 1

                            Text {
                                anchors.centerIn: parent
                                text: textConstants.login
                                color: "#41a1cf" // Signal Blue text color
                                font.family: "af, Inter, sans-serif"
                                font.pixelSize: 13
                                font.weight: Font.Medium
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: sddm.login(usernameField.text, passwordField.text, sessionIndex)
                            onEntered: loginRect.opacity = 0.7
                            onExited: loginRect.opacity = 1.0
                        }

                        Keys.onPressed: function(event) {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(usernameField.text, passwordField.text, sessionIndex)
                                event.accepted = true
                            }
                        }

                        KeyNavigation.backtab: rebootButton
                        KeyNavigation.tab: usernameField
                    }
                }
            }
        }
    }

    // Set initial keyboard focus based on last logged-in user
    Component.onCompleted: {
        if (userModel.lastUser === "") {
            usernameField.focus = true
        } else {
            usernameField.text = userModel.lastUser
            passwordField.focus = true
        }
    }
}
