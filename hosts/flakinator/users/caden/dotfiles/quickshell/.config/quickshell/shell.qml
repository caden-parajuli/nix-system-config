//@ pragma UseQApplication
pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import "Bar"

ShellRoot {
  ReloadPopup {}

  Scope {
    Loader {
      id: barLoader
      readonly property string barPath: "Bar/Bar.qml"

      source: barPath
    }

    IpcHandler {
      target: "bar"

      function toggle(): void {
        if (barLoader.source == "") {
          barLoader.source = barLoader.barPath;
        } else {
          barLoader.source = "";
        }
      }
    }

    GlobalShortcut {
      appid: "quickbar"
      description: "Show/hide the Quickshell bar"
      name: "show"
      onPressed: {
        if (barLoader.source == "") {
          barLoader.source = barLoader.barPath;
        } else {
          barLoader.source = "";
        }
      }
    }
  }
}
