/*
 * Copyright (C) 2026 renzard politakis
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * notes is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9
import Lomiri.Components 1.3
import QtQuick.Window 2.2
import Morph.Web 0.1
import QtWebEngine 1.7
import Qt.labs.settings 1.0
import QtSystemInfo 5.5
import Lomiri.Content 1.3
import QtQuick.Controls.Suru 2.2

MainView {
  id: mainView

  objectName: "mainView"

  property color b_color: "#000000"
  property color b_colorDark: "#000000"

  readonly property color headerColor: Suru.theme === 0 ? b_color : b_colorDark

  readonly property color accentColor: "#FF4500"

  width: units.gu(45)
  height: units.gu(75)

  applicationName: "reddit.unofficial"
  backgroundColor: "black"

  anchors {
    fill: parent
    bottomMargin: LomiriApplication.inputMethod.visible ? LomiriApplication.inputMethod.keyboardRectangle.height/(units.gridUnit / 8) : 0
  }

  Behavior on anchors.bottomMargin {
    NumberAnimation {
      duration: 175
      easing.type: Easing.OutQuad
    }
  }

  PageStack {
    id: mainPageStack
    anchors.fill: parent
    Component.onCompleted: mainPageStack.push(pageMain)

    Page {
      id: pageMain
      anchors.fill: parent

      header: PageHeader {
        visible: false
        height: 0
        title: ""
      }

      WebEngineView {
        id: webview
        anchors {
          top: parent.top
          left: parent.left
          right: parent.right
          bottom: parent.bottom
        }
        focus: true

        Behavior on opacity {
          NumberAnimation { duration: 280; easing.type: Easing.OutCubic }
        }

        settings.pluginsEnabled: true
        settings.accelerated2dCanvasEnabled: true
        settings.webGLEnabled: true
        settings.showScrollBars: false
        settings.playbackRequiresUserGesture: false

        property bool hasError: false

        profile: WebEngineProfile {
          id: webContext
          httpUserAgent: "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.5845.163 Mobile Safari/537.36"
          storageName: "reddit.unofficial"
          persistentCookiesPolicy: WebEngineProfile.ForcePersistentCookies
          httpCacheType: WebEngineProfile.DiskHttpCache
          httpCacheMaximumSize: 157286400
        }

        userScripts: WebEngineScript {
          injectionPoint: WebEngineScript.DocumentReady
          worldId: WebEngineScript.MainWorld
          name: "scrollbartheme"
          sourceUrl: "scrollBarTheme.js"
        }

        url: "https://www.reddit.com/"

        onFeaturePermissionRequested: function(securityOrigin, feature) {
            if (feature === WebEngineView.Notifications ||
                feature === WebEngineView.MediaAudioCapture ||
                feature === WebEngineView.MediaVideoCapture ||
                feature === WebEngineView.MediaAudioVideoCapture) {
                grantFeaturePermission(securityOrigin, feature, true);
            }
        }

        onFileDialogRequested: function(request) {
          request.accepted = true;
          var importPage = mainPageStack.push(Qt.resolvedUrl("ImportPage.qml"), {
            "contentType": ContentType.All,
            "handler": ContentHandler.Source,
            "pageStack": mainPageStack
          })
          importPage.imported.connect(function(fileUrl) {
            request.dialogAccept([String(fileUrl).replace("file://", "")]);
            mainPageStack.pop();
          })
          importPage.canceled.connect(function() {
            request.dialogReject();
            mainPageStack.pop();
          })
        }

        onNewViewRequested: {
            request.action = WebEngineNavigationRequest.IgnoreRequest
            if (request.userInitiated) {
                Qt.openUrlExternally(request.requestedUrl)
            }
        }

        onJavaScriptConsoleMessage: function(level, message, lineNumber, sourceID) {
          if (message.indexOf("RD-") === 0) console.log(message);
        }

        onLoadingChanged: function(loadRequest) {
          webview.opacity = (loadRequest.status === WebEngineView.LoadStartedStatus) ? 0.35 : 1;
          if (loadRequest.status === WebEngineView.LoadFailedStatus) {
            webview.hasError = true;
          } else if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
            webview.hasError = false;
          }
        }
      }

      Rectangle {
        anchors { top: parent.top; left: parent.left }
        height: units.gu(0.3)
        width: parent.width * (webview.loadProgress / 100)
        color: mainView.accentColor

        opacity: (webview.loadProgress > 0 && webview.loadProgress < 100 && !webview.hasError) ? 1 : 0
        visible: opacity > 0
        Behavior on opacity { NumberAnimation { duration: 300 } }
        Behavior on width { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
      }

      Rectangle {
        id: offlineScreen
        anchors { top: parent.top; left: parent.left; right: parent.right; bottom: parent.bottom }
        color: theme.palette.normal.background
        opacity: webview.hasError ? 1 : 0
        visible: opacity > 0
        Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

        Column {
          anchors.centerIn: parent
          spacing: units.gu(2)
          width: parent.width * 0.8

          transform: Translate { y: (1 - offlineScreen.opacity) * units.gu(4) }

          Rectangle {
            id: offlineIcon
            width: units.gu(9)
            height: units.gu(9)
            radius: width / 2
            anchors.horizontalCenter: parent.horizontalCenter
            color: Qt.rgba(mainView.accentColor.r, mainView.accentColor.g, mainView.accentColor.b, 0.15)

            SequentialAnimation on scale {
              loops: Animation.Infinite
              running: offlineScreen.visible
              NumberAnimation { to: 1.1; duration: 900; easing.type: Easing.InOutSine }
              NumberAnimation { to: 1.0; duration: 900; easing.type: Easing.InOutSine }
            }

            Label {
              anchors.centerIn: parent
              text: "⚠"
              textSize: Label.XLarge
              color: mainView.accentColor
            }
          }

          Label {
            text: i18n.tr("Δεν υπάρχει σύνδεση στο διαδίκτυο")
            textSize: Label.Large
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            wrapMode: Text.WordWrap
          }

          Label {
            text: i18n.tr("Έλεγξε τη σύνδεσή σου και δοκίμασε ξανά.")
            textSize: Label.Small
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            wrapMode: Text.WordWrap
            opacity: 0.7
          }

          Button {
            id: retryButton
            text: i18n.tr("Δοκίμασε ξανά")
            anchors.horizontalCenter: parent.horizontalCenter
            color: mainView.accentColor

            scale: pressed ? 0.94 : 1
            Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutQuad } }
            onClicked: {
              webview.hasError = false;
              webview.reload();
            }
          }
        }
      }

      FabMenu {
        anchors {
          fill: parent
          topMargin: 0
        }
        z: 500
        accentColor: mainView.accentColor
        canGoBack: webview.canGoBack

        readonly property bool wanted: true
        opacity: wanted ? 1 : 0
        visible: opacity > 0
        Behavior on opacity { NumberAnimation { duration: 250 } }
        onWantedChanged: if (!wanted) expanded = false

        onNavigate: {
          if (target === "back") { webview.goBack(); return; }
          if (target === "reload") { webview.reload(); return; }
          webview.runJavaScript("window.__rdGo && window.__rdGo(" + JSON.stringify(target) + ")");
        }
      }

      Rectangle {
        id: splashScreen
        anchors.fill: parent
        z: 1000
        color: mainView.headerColor
        opacity: 1
        visible: opacity > 0

        Behavior on opacity {
          NumberAnimation { duration: 450; easing.type: Easing.OutCubic }
        }

        Column {
          anchors.centerIn: parent
          spacing: units.gu(2)

          scale: 1 + (1 - splashScreen.opacity) * 0.15

          Image {
            id: splashLogo
            source: Qt.resolvedUrl("../assets/logo.png")
            width: units.gu(14)
            height: units.gu(14)
            fillMode: Image.PreserveAspectFit
            smooth: true
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0
            scale: 0.55
          }

          Label {
            id: splashText
            text: "reddit"
            textSize: Label.XLarge
            font.bold: true
            font.pixelSize: units.gu(5)
            color: mainView.accentColor
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0
            transform: Translate { id: splashTextShift; y: units.gu(2.5) }
          }

          Rectangle {
            width: units.gu(10)
            height: units.gu(0.3)
            radius: height / 2
            color: Qt.rgba(1, 1, 1, 0.12)
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true

            Rectangle {
              id: splashSeg
              width: parent.width * 0.4
              height: parent.height
              radius: height / 2
              color: mainView.accentColor

              SequentialAnimation on x {
                loops: Animation.Infinite
                running: splashScreen.visible
                NumberAnimation {
                  from: -splashSeg.width
                  to: splashSeg.parent.width
                  duration: 900
                  easing.type: Easing.InOutQuad
                }
              }
            }
          }
        }

        ParallelAnimation {
          running: true
          NumberAnimation { target: splashLogo; property: "opacity"; to: 1; duration: 350 }
          NumberAnimation {
            target: splashLogo; property: "scale"; to: 1
            duration: 600; easing.type: Easing.OutBack; easing.overshoot: 1.8
          }
          SequentialAnimation {
            PauseAnimation { duration: 200 }
            ParallelAnimation {
              NumberAnimation { target: splashText; property: "opacity"; to: 1; duration: 350 }
              NumberAnimation { target: splashTextShift; property: "y"; to: 0; duration: 420; easing.type: Easing.OutCubic }
            }
          }
        }

        Connections {
          target: webview
          onLoadingChanged: function(loadRequest) {
            if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
              splashScreen.opacity = 0;
            }
          }
        }

        Timer {
          interval: 6000
          running: true
          onTriggered: splashScreen.opacity = 0
        }
      }
    }
  }
}
