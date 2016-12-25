import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
  
  private var controllers: [MVTimerController] = []

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let controller = MVTimerController()
    controllers.append(controller)
    
    NSUserNotificationCenter.default.delegate = self
    
    let nc = NotificationCenter.default
    nc.addObserver(self, selector: #selector(handleClose), name: NSNotification.Name.NSWindowWillClose, object: nil)
  }
  
  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    for controller in controllers {
      controller.window?.makeKeyAndOrderFront(self)
    }
    return true
  }

  func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
    return true
  }
  
  func newDocument(_ sender: AnyObject?) {
    let lastController = self.controllers.last
    let controller = MVTimerController(closeToWindow: lastController?.window)
    controllers.append(controller)
  }
  
  func handleClose(_ notification: Notification) {
    if controllers.count <= 1 {
      return
    }
    if let window = notification.object as? NSWindow {
      let controller = self.controllerForWindow(window)
      if controller != nil {
        let index = controllers.index(of: controller!)
        if index != nil {
          controllers.remove(at: index!)
        }
      }
    }
  }
  
  private func controllerForWindow(_ window: NSWindow) -> MVTimerController? {
    for controller in controllers {
      if controller.window == window {
        return controller
      }
    }
    return nil
  }

}

