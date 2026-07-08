import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets

import "root:/"

WrapperRectangle {
  default property alias content: rowLayout.children
  required property var alignment

  color: Theme.get.bgColor
  radius: 14
  Layout.alignment: alignment
  Layout.preferredHeight: parent.height - 5

  child: RowLayout {
    id: rowLayout
    spacing: 25
    anchors.fill: parent
  }
}
