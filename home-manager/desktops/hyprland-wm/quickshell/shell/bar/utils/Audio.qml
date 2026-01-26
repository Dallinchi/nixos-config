pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire


Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real volume: sink?.audio?.volume

    property string activePort

    Process {
    	  id: activePortProc
    	  command: ["sh", "-c", "~/.config/quickshell/lacrity-space/scripts/sink_info"]
    	  running: true

    	stdout: StdioCollector {
          onStreamFinished: root.activePort = this.text.trim()
	    }
    }

    function setVolume(volume: real): void {
        if (sink?.ready && sink?.audio) {
            sink.audio.muted = false;
	      sink.audio.volume = volume;
	      activePortProc.running = true
        }
    }

    PwObjectTracker {
	      objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }
}
