import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

// Bar widget showing whether a NetworkManager VPN is up. Left click toggles it
// via `vpn-toggle`, which is the same script SUPER+SHIFT+V runs, so the two
// paths cannot drift.
//
// The connection name is configurable from shell.json:
//   { "id": "jmayaalv.vpn", "connection": "kane-fra" }
BarWidget {
  id: root
  moduleName: "jmayaalv.vpn"

  readonly property string connName: setting("connection", "kane-fra")
  readonly property int pollSeconds: setting("pollSeconds", 10)

  property bool connected: false
  property string tunnelIp: ""
  // Set while a toggle is in flight so the icon reflects the pending action
  // instead of sitting on a stale state for a poll interval.
  property bool busy: false

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function refresh() {
    if (!probe.running) probe.running = true
  }

  // One reading of state plus address, tab-separated, so a connect shows the
  // address it actually got rather than just "connected".
  Process {
    id: probe
    running: true
    command: ["bash", "-c",
      "if nmcli -g NAME connection show --active 2>/dev/null | grep -qxF " + Util.shellQuote(root.connName) + "; then " +
      "printf 'up\\t%s\\n' \"$(nmcli -g IP4.ADDRESS connection show " + Util.shellQuote(root.connName) +
      " 2>/dev/null | head -1 | cut -d/ -f1)\"; else echo down; fi"]
    stdout: SplitParser {
      onRead: function (line) {
        var parts = String(line).trim().split("\t")
        root.connected = parts[0] === "up"
        root.tunnelIp = root.connected && parts.length > 1 ? parts[1] : ""
        root.busy = false
      }
    }
  }

  Timer {
    interval: root.pollSeconds * 1000
    running: true
    repeat: true
    onTriggered: root.refresh()
  }

  // A connect takes a few seconds to negotiate, so re-read a couple of times
  // after a click rather than waiting for the next poll tick.
  Timer {
    id: settle
    interval: 1500
    repeat: true
    property int ticks: 0
    onTriggered: {
      root.refresh()
      if (++ticks >= 6) { stop(); ticks = 0 }
    }
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󱇱"
    // Same convention as the other bar widgets: full foreground when the thing
    // is on, dimmed when it is off. `active` is deliberately not used — it
    // paints with the theme's urgent colour, which reads as an alert.
    dimmed: !root.connected
    tooltipText: root.busy
      ? ("VPN working… · " + root.connName)
      : (root.connected
         ? ("VPN connected · " + root.connName + (root.tunnelIp ? " · " + root.tunnelIp : ""))
         : ("VPN disconnected · " + root.connName))
    onPressed: function (b) {
      // Left and right both toggle; middle opens the editor for the rare case
      // of changing credentials or adding a profile.
      if (b === Qt.MiddleButton) {
        root.bar.run("nm-connection-editor")
        return
      }
      root.busy = true
      root.bar.run("vpn-toggle " + Util.shellQuote(root.connName))
      settle.ticks = 0
      settle.restart()
    }
  }
}
