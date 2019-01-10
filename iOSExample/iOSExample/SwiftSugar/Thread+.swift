// Thread+.swift [SwiftSugar] created by: Adas Lesniak on: 04/04/2018
import Foundation


public func ExecuteInBackground(_ code: @escaping Action) {
    DispatchQueue.global().async(execute: code)
}


public func ExecuteInBackground(after: Double, _ code: @escaping Action) {
    DispatchQueue.global().asyncAfter(deadline: .now() + after, execute: code)
}

public func ExecuteInBackground(_ code: @escaping Action, whenDone: @escaping Action) {
    let isToCallbackOnMain = Thread.isMainThread
    DispatchQueue.global().async {
        code()
        if isToCallbackOnMain {
            DispatchQueue.main.async {
                whenDone()
            }
        } else {
            whenDone()
        }
    }
}

public func ExecuteOnMain(_ code: @escaping Action) {
    DispatchQueue.main.async(execute: code)
}

public func ExecuteOnMain(after delay: Double, _ code: @escaping Action) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: code)
}

public func Lock(_ obj: AnyObject, _ code:Action) {
    objc_sync_enter(obj)
    code()
    objc_sync_exit(obj)
}

public func Lock(_ obj: [Any], _ code: Action) {
    objc_sync_enter(obj)
    code()
    objc_sync_exit(obj)
}
