import Quickshell
import QtQuick
import Quickshell.Services.Pipewire
import QtQuick.Layouts

import "root:/"

RowLayout {
  id: root
  property var sink: Pipewire.defaultAudioSink
  property var source: Pipewire.defaultAudioSource

  PwObjectTracker { objects: [ sink, source ] }

  Text {
    id: sinkText
    color: root.sink && root.sink.audio.muted ? Theme.get.muted : Theme.get.fgColor

    text: {
      if (root.sink && root.sink.ready && root.sink.audio) {
        if (root.sink.audio.muted) {
          return ""
        } else {
          let volume = Math.round(root.sink.audio.volume * 100)
          return volume + "% "
        }
      }
      return "No audio"
    }
  }

  Text {
    id: sourceText
    color: root.source && root.source.audio.muted ? Theme.get.muted : Theme.get.fgColor

    text: {
      if (root.source && root.source.ready && root.source.audio) {
        if (root.source.audio.muted) {
          return ""
        } else {
          let volume = Math.round(root.source.audio.volume * 100)
          return volume + "% "
        }
      }
      return "No mic"
    }

  }
}
