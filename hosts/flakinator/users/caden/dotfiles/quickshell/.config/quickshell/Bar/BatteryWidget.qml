import QtQuick
import Quickshell.Services.UPower

import "root:/"

Text {
  property var battery: UPower.displayDevice

  property var icon: {
    switch (battery.state) {
      case UPowerDeviceState.Charging:
        return "";
      case UPowerDeviceState.PendingCharge:
        return "";
      case UPowerDeviceState.FullyCharged:
        return "  ";
      default: {
        let percent_icons = ["", "", "", "", ""];
        let index = Math.min(
          percent_icons.length - 1,
          Math.floor(battery.percentage * (percent_icons.length))
        );
        return percent_icons[index]
      }
    }
  }

  font.pointSize: 10

  color: {
    if (battery.state == UPowerDeviceState.Charging) {
      return Theme.get.batCharge
    } else if (battery.percentage < 0.2) {
      return Theme.get.batCritical
    } else if (battery.percentage < 0.5) {
      return Theme.get.batLow
    }
    return Theme.get.batNeutral
  }

  text: {
    if (battery.ready) {
      return Math.round(battery.percentage * 100) + "% " + icon
    }
    return "❌"
  }
}
