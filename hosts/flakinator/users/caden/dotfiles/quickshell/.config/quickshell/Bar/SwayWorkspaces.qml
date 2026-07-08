import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.I3

import "root:/"

RowLayout {
  spacing: 0

  Repeater {
    model: I3.workspaces

    WrapperRectangle {
      id: wrapper
      required property var modelData

      color: wsArea.containsMouse ? Theme.get.surface1 : Theme.get.bgColor
      radius: 14

      leftMargin: 10
      rightMargin: 10
      bottomMargin: 5
      topMargin: 5

      child: Text {
        id: ws
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        color: modelData.active ? Theme.get.activeWorkspace : Theme.get.fgColor
        text: modelData.name

        MouseArea {
          id: wsArea
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton

          hoverEnabled: true
          onClicked: {
            wrapper.modelData.activate()
          }
        }
      }
    }
  }
}
