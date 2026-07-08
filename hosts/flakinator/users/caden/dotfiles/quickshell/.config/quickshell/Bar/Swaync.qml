import Quickshell
import QtQuick
import Quickshell.Io

import "root:/"

Text {
  id: swayncWidget

  color: Theme.get.fgColor
  text: " "
  font.pointSize: 12

  Process {
    id: swayncProcess
    running: false
    command: [ "swaync-client", "-t" ]
  }

  MouseArea {
    anchors.fill: parent
    onClicked: {
      swayncProcess.running = true;
    }
  }
}
