// ExampleChannel.swift [iOSExample] created by: Adas Lesniak on: 10/01/2019
import Foundation


//whatever ExampleObject news are - this is DataSoruce for main viewController, and viewCtrl should not be dataSource - separation of business logic/data managment and serving UI
public class ExampleChannel {
    
    private var data = [ExampleObject]()
    private var callbacks = [AnyHashable:Action]()//this
    
    subscript(atIndex: Int) -> ExampleObject? {
        guard atIndex < data.count else {
            return nil
        }
        return data[atIndex]
    }
    var count: Int { return data.count }
    
    func registerForUpdates(_ listener: AnyHashable, action: @escaping Action) {
        callbacks[listener] = action
    }
    func unregisterFromUpdates(_ listener: AnyHashable) {
        callbacks[listener] = nil
    }
    
    //should check only for first X number of records
    func update() {
        ExecuteInBackground {
            Backend.getExampleObjects() { [weak self] answer in
                guard let self = self else { return }
                Lock(self.data) {
                    self.data.removeAll()
                    self.data.append(contentsOf: answer)
                }
                ExecuteOnMain {
                    self.fireUpdateEvent()
                }
            }
        }
    }
    
    /* would implement if data would need to be pulled in pages
     public pullMore() {
    
    }*/
    
    private func fireUpdateEvent() {
        for listener in callbacks {
            listener.value()
        }
    }
}
