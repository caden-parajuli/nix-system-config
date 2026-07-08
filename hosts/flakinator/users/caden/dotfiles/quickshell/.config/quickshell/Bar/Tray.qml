import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.SystemTray

import "root:/"

RowLayout {
  spacing: 10

  Repeater {
    model: SystemTray.items

    WrapperRectangle {
      id: wrapper
      required property var modelData

      color: itemArea.containsMouse ? Theme.get.surface1 : Theme.get.bgColor
      radius: 14

      leftMargin: 10
      rightMargin: 10
      bottomMargin: 5
      topMargin: 5

      child: Text {
        id: item
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        color: Theme.get.fgColor

        IconImage {
          id: icon
          source: modelData.icon
          height: parent.height
          width: parent.width
        }

        MouseArea {
          id: itemArea
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

          hoverEnabled: true

          onClicked: event => {
            if (event.button === Qt.RightButton) {
              console.log("Activating " + wrapper.modelData.title);
              wrapper.modelData.activate();
            } else if (event.button === Qt.MiddleButton) {
              console.log("Activating secondary " + wrapper.modelData.title);
              wrapper.modelData.secondaryActivate();
            } else if (wrapper.modelData.hasMenu) {
              console.log("Opening menu for " + wrapper.modelData.title);
              menu.open();
            }
          }

          QsMenuAnchor {
            id: menu

            menu: wrapper.modelData.menu
            anchor.item: item
            anchor.edges: Edges.Bottom | Edges.Right
            anchor.gravity : Edges.Bottom | Edges.Left
          }
        }
      }
    }
  }
}
