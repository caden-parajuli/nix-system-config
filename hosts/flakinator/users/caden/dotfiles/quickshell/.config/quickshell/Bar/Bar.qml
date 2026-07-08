import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

import "root:/"

Variants {
  model: Quickshell.screens

  PanelWindow {
    id: window
    property var modelData
    screen: modelData

    Component.onCompleted: {
    if (this.WlrLayershell != null) {
      this.WlrLayershell.layer = WlrLayer.Top;
    }
  }

    anchors {
      top: true
      left: true
      right: true
    }

    margins {
      left: 15
      right: 15
    }

    implicitHeight: 30
    color: "transparent"

    RowLayout {
      anchors.fill: parent
      uniformCellSizes: true
      spacing: 50

      // Left side
      Group {
        alignment: Qt.AlignLeft | Qt.AlignVCenter
        TempWidget { id: temperature }
      }

      // Center
      Group {
        alignment: Qt.AlignHCenter | Qt.AlignVCenter
        SwayWorkspaces { id: workspaces }
      }

      // Right side
      RowLayout {
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        Layout.preferredHeight: parent.height - 5
        spacing: 20

        Group {
          alignment: Qt.AlignRight | Qt.AlignVCenter

          AudioWidget { id: audio }

          BatteryWidget { id: battery }

          ClockWidget {
            id: clock
            time: Time.time
          }
        }

        Group {
          alignment: Qt.AlignRight | Qt.AlignVCenter
          Tray { }
          Swaync { }
        }
      }
    }
  }
}
