// UIView+.swift [SwiftSugar] created by:: Adas Lesniak on 21/08/2017.
import Foundation
import UIKit


extension UIView {
    //"screenshot" of given view
    public func makeImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions((self.frame.size), false, UIScreen.main.scale)
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            fatalError("that's beyond my knowledge")
        }
        
        self.layer.render(in: currentContext)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError("FUBAR...")
        }
        UIGraphicsEndImageContext()
        //HACK - sometimes alpha is encoded in weird way for some tasks... encoding it to PNG forces correct encoding
        guard let imgData = result.pngData() else {
            //Log.error("FUBAR")
            return result
        }
        return UIImage(data: imgData)!
    }

    // ===============================================================
    // ==================== SIMPLE GESTURES  =========================
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    public enum Gesture {
        case tap
        case doubleTap
        case swipeLeft
        case swipeRight
        case swipeUp
        case swipeDown
    }

    private struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
        
    
    
    // Set our computed property type to a closure
    private var actions: [Gesture:Action?] {
        set {
            // Computed properties get stored as associated objects
            objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        get {
            guard let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? [Gesture:Action] else {
                //Log.error("no actions dictionary")
                return [Gesture:Action?]()
            }
            return tapGestureRecognizerActionInstance
        }
    }
    
    public func addAction(_ trigger: Gesture, action: Action?) {
        isUserInteractionEnabled = true
        actions[trigger] = action
        var recognizer: UIGestureRecognizer
        switch trigger {
        case .tap:
            recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        case .doubleTap:
            recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
            (recognizer as? UITapGestureRecognizer)?.numberOfTapsRequired = 2
        case .swipeLeft:
            recognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
            (recognizer as? UISwipeGestureRecognizer)?.direction = .left
        case .swipeRight:
            recognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
            (recognizer as? UISwipeGestureRecognizer)?.direction = .right
        case .swipeUp:
            recognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
            (recognizer as? UISwipeGestureRecognizer)?.direction = .up
        case .swipeDown:
            recognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
            (recognizer as? UISwipeGestureRecognizer)?.direction = .down
        }
        addGestureRecognizer(recognizer)
    }
    
    public func isActionSet(_ trigger: Gesture) -> Bool {
        return actions[trigger] != nil
    }
    
    
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        guard let executable = actions[.tap] else {
            //Log.error("how is that?!")
            return
        }
        executable?()
    }
    
    @objc fileprivate func handleSwipeGesture(sender: UISwipeGestureRecognizer) {
        func tryExecuteCallback(_ action: Gesture) {
            guard let executable = actions[action] else {
                //Log.error("can't handle swipe left gesture if there is no action defined for this gesture")
                return
            }
            executable?()
        }
        switch sender.direction {
        case .left:
            tryExecuteCallback(.swipeLeft)
        case .right:
            tryExecuteCallback(.swipeRight)
        case .up:
            tryExecuteCallback(.swipeUp)
        case .down:
            tryExecuteCallback(.swipeDown)
        default:
            //Log.error("Uhmmm... that's unexepcted: \(sender.direction)")
            print("unexpected direction of swipe gesture: \(sender.direction)")
        }
    }
    // ============ end of simple gestures ==================
}
