import Cocoa
import FlutterMacOS
import Sparkle

class MainFlutterWindow: NSWindow {
    @IBAction func checkForUpdates(_ sender: Any) {
        let updater = SUUpdater.shared()
        updater?.feedURL = URL(string: "https://sparkle-project.org/files/sparkletestcast.xml")
        updater?.checkForUpdates(self)
    }
    
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
