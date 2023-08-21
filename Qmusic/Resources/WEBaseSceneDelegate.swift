
import Foundation
import UIKit

@objc protocol IWEBaseSceneDelegate: AnyObject {
    @objc optional func notifyAppEnterBackground()
    @objc optional func notifyAppEnterForground()
}

class WEBaseSceneDelegate {
    enum BaseSceneType {
        case Background
        case Forground
    }
    
    static let sharedInstance: WEBaseSceneDelegate = {
        let instance = WEBaseSceneDelegate()
        return instance
    }()
    
    public var listeners: [IWEBaseSceneDelegate] = [IWEBaseSceneDelegate]()
    
    func addListener(listener: IWEBaseSceneDelegate) {
        self.removeListener(listener: listener)
        self.listeners.append(listener)
    }
    
    func removeListener(listener: IWEBaseSceneDelegate) {
        listeners = listeners.filter({ $0 !== listener })
    }
    
    fileprivate func notifyToListeners(type: BaseSceneType) {
        for listener in listeners {
            switch type {
            case .Background:
                listener.notifyAppEnterBackground?()
            case .Forground:
                listener.notifyAppEnterForground?()
            }
        }
    }
    
    func StartListening() {
        self.StopListening()
        
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterForground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func StopListening() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func enterBackground() {
        self.notifyToListeners(type: .Background)
        Logger.log(message: "Application Enter Background", event: .i)
    }
    
    @objc fileprivate func enterForground() {
        self.notifyToListeners(type: .Forground)
        Logger.log(message: "Application Enter Forground", event: .i)
    }
}
