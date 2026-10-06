<<<<<<< HEAD
/*
=======
/* 
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
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

<<<<<<< HEAD
=======

>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
MainView {
  id: mainView

  objectName: "mainView"

<<<<<<< HEAD
=======
  // Μαύρο φόντο στο splash και στο παράθυρο, και στα δύο themes.
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
  property color b_color: "#000000"
  property color b_colorDark: "#000000"

  readonly property color headerColor: Suru.theme === 0 ? b_color : b_colorDark
<<<<<<< HEAD

=======
  // Το χαρακτηριστικό πορτοκαλί του Reddit για κουμπιά, progress bar κ.λπ.
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
  readonly property color accentColor: "#FF4500"

  width: units.gu(45)
  height: units.gu(75)

  applicationName: "reddit.unofficial"
  backgroundColor: "black"

  anchors {
    fill: parent
    bottomMargin: LomiriApplication.inputMethod.visible ? LomiriApplication.inputMethod.keyboardRectangle.height/(units.gridUnit / 8) : 0
  }

<<<<<<< HEAD
=======
  // FIX: Το "Behavior on X" πρέπει να δηλώνεται ΕΚΤΟΣ του grouped property
  // block (anchors {...}). Μέσα στο group επιτρέπονται μόνο απλές τιμές
  // ιδιοτήτων, όχι δηλώσεις αντικειμένων σαν το Behavior - όπως ήταν πριν,
  // το animation ποτέ δεν εφαρμοζόταν στην πραγματικότητα.
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
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

<<<<<<< HEAD
=======
      // Χωρίς top bar: το webview πιάνει όλη την οθόνη
      // Το header=null ΔΕΝ το κρύβει στο Lomiri (μένει μια μαύρη μπάρα που
      // σκεπάζει το πάνω μέρος του X). Το κρύβουμε ρητά με μηδενικό ύψος.
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
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

<<<<<<< HEAD
=======
        // Απαλό "βούτηγμα" της διαφάνειας όταν ξεκινά νέα φόρτωση σελίδας
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
        Behavior on opacity {
          NumberAnimation { duration: 280; easing.type: Easing.OutCubic }
        }

        settings.pluginsEnabled: true
        settings.accelerated2dCanvasEnabled: true
        settings.webGLEnabled: true
        settings.showScrollBars: false
        settings.playbackRequiresUserGesture: false

<<<<<<< HEAD
=======
        // Κρατάμε ένα flag για να ξέρουμε αν η τελευταία φόρτωση απέτυχε
        // (π.χ. δεν υπάρχει σύνδεση στο ίντερνετ), ώστε να δείξουμε τη δική
        // μας, μοντέρνα οθόνη σφάλματος αντί για την άσχημη προεπιλεγμένη
        // του Chromium.
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
        property bool hasError: false

        profile: WebEngineProfile {
          id: webContext
          httpUserAgent: "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.5845.163 Mobile Safari/537.36"
          storageName: "reddit.unofficial"
          persistentCookiesPolicy: WebEngineProfile.ForcePersistentCookies
          httpCacheType: WebEngineProfile.DiskHttpCache
<<<<<<< HEAD
          httpCacheMaximumSize: 157286400
=======
          httpCacheMaximumSize: 157286400 // 150MB - λιγότερα ξαναφορτώματα σε επόμενα ανοίγματα
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
        }

        userScripts: WebEngineScript {
          injectionPoint: WebEngineScript.DocumentReady
          worldId: WebEngineScript.MainWorld
          name: "scrollbartheme"
          sourceUrl: "scrollBarTheme.js"
        }

        url: "https://www.reddit.com/"

<<<<<<< HEAD
=======
        // Δικαιώματα για Ειδοποιήσεις, Μικρόφωνο και Κάμερα
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
        onFeaturePermissionRequested: function(securityOrigin, feature) {
            if (feature === WebEngineView.Notifications ||
                feature === WebEngineView.MediaAudioCapture ||
                feature === WebEngineView.MediaVideoCapture ||
                feature === WebEngineView.MediaAudioVideoCapture) {
                grantFeaturePermission(securityOrigin, feature, true);
            }
        }

<<<<<<< HEAD
=======
        // Επιλογή και αποστολή φωτογραφίας/βίντεο σε νέο tweet/DM
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
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

<<<<<<< HEAD
=======
      // ---- Λεπτή μπάρα προόδου φόρτωσης, κάτω από το header ----
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
      Rectangle {
        anchors { top: parent.top; left: parent.left }
        height: units.gu(0.3)
        width: parent.width * (webview.loadProgress / 100)
        color: mainView.accentColor
<<<<<<< HEAD

=======
        // Σβήνει σιγά-σιγά όταν τελειώσει η φόρτωση, αντί να εξαφανίζεται απότομα
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
        opacity: (webview.loadProgress > 0 && webview.loadProgress < 100 && !webview.hasError) ? 1 : 0
        visible: opacity > 0
        Behavior on opacity { NumberAnimation { duration: 300 } }
        Behavior on width { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
      }

<<<<<<< HEAD
=======
      // ---- Δική μας οθόνη "χωρίς σύνδεση", αντί για το προεπιλεγμένο,
      // άσχημο error page του Chromium ----
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
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
<<<<<<< HEAD

=======
          // Ανεβαίνει απαλά από κάτω καθώς εμφανίζεται
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
          transform: Translate { y: (1 - offlineScreen.opacity) * units.gu(4) }

          Rectangle {
            id: offlineIcon
            width: units.gu(9)
            height: units.gu(9)
            radius: width / 2
            anchors.horizontalCenter: parent.horizontalCenter
            color: Qt.rgba(mainView.accentColor.r, mainView.accentColor.g, mainView.accentColor.b, 0.15)

<<<<<<< HEAD
=======
            // Ήρεμο "αναπνέει" όσο είναι ορατή η οθόνη
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
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
<<<<<<< HEAD

=======
            // Μικρό "πάτημα" όταν το αγγίζεις
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
            scale: pressed ? 0.94 : 1
            Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutQuad } }
            onClicked: {
              webview.hasError = false;
              webview.reload();
            }
          }
        }
      }

<<<<<<< HEAD
=======
      // ---- Floating κουμπί με το λογότυπο με ημικυκλικό μενού συντομεύσεων ----
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
      FabMenu {
        anchors {
          fill: parent
          topMargin: 0
        }
        z: 500
        accentColor: mainView.accentColor
        canGoBack: webview.canGoBack
<<<<<<< HEAD

=======
        // Εμφανίζεται πάντα, σε όλες τις σελίδες
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
        readonly property bool wanted: true
        opacity: wanted ? 1 : 0
        visible: opacity > 0
        Behavior on opacity { NumberAnimation { duration: 250 } }
        onWantedChanged: if (!wanted) expanded = false

<<<<<<< HEAD
=======
        // Πλοήγηση ΜΕΣΑ στη σελίδα (SPA), χωρίς πλήρες reload
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
        onNavigate: {
          if (target === "back") { webview.goBack(); return; }
          if (target === "reload") { webview.reload(); return; }
          webview.runJavaScript("window.__rdGo && window.__rdGo(" + JSON.stringify(target) + ")");
        }
      }

<<<<<<< HEAD
=======
      // ---- Splash screen κατά το πρώτο άνοιγμα ----
      // Απλό μαύρο φόντο με το λογότυπο και πορτοκαλί "reddit" κείμενο - σβήνει μόλις
      // φορτώσει η πρώτη σελίδα.
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
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
<<<<<<< HEAD

=======
          // Όταν το splash φεύγει, το περιεχόμενο μεγαλώνει ελαφρά ενώ σβήνει
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
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

<<<<<<< HEAD
=======
          // Μικρή μπάρα φόρτωσης που τρέχει όσο φαίνεται το splash
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
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

<<<<<<< HEAD
=======
        // Είσοδος: το λογότυπο "πετάγεται" με ελατήριο, μετά ανεβαίνει το κείμενο
>>>>>>> 6c60eaed8daa7a950f5472a525263e56f470d587
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
