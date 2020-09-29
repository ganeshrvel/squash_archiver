import Cocoa
import FlutterMacOS
import Sparkle

class MainFlutterWindow: NSWindow {
    var SUFeedURL: String? {
        return Bundle.main.object(forInfoDictionaryKey: "SUFeedURL") as? String
    }

	@IBAction func checkForUpdates(_ sender: Any) {
        if SUFeedURL != nil {
            let updater = SUUpdater.shared()
            updater?.feedURL = URL(string: SUFeedURL!)
            updater?.checkForUpdates(self)
        }
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
