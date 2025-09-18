import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

Item {
	Text {
		text: {
		console.log("хуй залупа")
		return "123"
		}
		
	}
	Component.onCompleted: {
    		NotificationServer.root.initDone.connect(onInitDone);
	}
	function onInitDone() {
	    console.log("Notification Server initialized.");
	}


}
