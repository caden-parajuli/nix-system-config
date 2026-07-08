pragma Singleton

import QtQuick
import Quickshell

Singleton {
	property Item get: main

	Item {
		id: main

		readonly property string bgColor: "#ff313244"
		readonly property string fgColor: "#ffcfcfff"
		readonly property string surface1: "#ff585b7f"

		readonly property string batNeutral: fgColor
		readonly property string batCharge: "#ffafefaf"
		readonly property string batLow: "#ffcfcf00"
		readonly property string batCritical: "#ffefafaf"

		readonly property string muted: "#ffefafaf"

		readonly property string activeWorkspace: "#ff94e2d5"
	}
}
