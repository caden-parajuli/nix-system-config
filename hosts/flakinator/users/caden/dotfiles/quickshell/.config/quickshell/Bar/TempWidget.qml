import Quickshell
import QtQuick
import Quickshell.Io

import "root:/"

Text {
  id: tempWidget
  property int temp: 0

  color: Theme.get.fgColor
  text: temp + "°C"

  Process {
    id: tempProcess
    running: true
    command: [ "cat", "/sys/class/thermal/thermal_zone0/temp" ]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        tempWidget.temp = Math.round(text / 1000)
      }
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true

    onTriggered: tempProcess.running = true
  }
}
