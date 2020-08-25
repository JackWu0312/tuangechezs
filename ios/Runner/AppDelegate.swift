import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    TalkingDataAppAnalyticsPlugin.pluginSessionStart("E96ADEE691E84ACB80622EA8D85B4B02", withChannelId: "1493906548")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
