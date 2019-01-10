// ExampleObject.swift [iOSExample] created by: Adas Lesniak on: 10/01/2019 


import Foundation

class ExampleObject: CustomStringConvertible {
    
    
    public private(set) var text: String
    public private(set) var image: URL
    private var title: String? = nil
    
    //init with half deserialised json object
    //optional as we don't controll what comes from backend
    public init?(serialised: [String:Any]) {
        guard let theName = serialised.valueAtPath("name") as? String else {
            return nil
        }
        guard let imgString = serialised.valueAtPath("image") as? String else {
            return nil
        }
        guard let imgAddress = URL(string: imgString) else {
            return nil
        }
        text = theName
        image = imgAddress
    }
    
    //that is just weird - there is no internal logic to task, so not sure how to deal with this
    func getTitle(whenReady: @escaping (String) -> Void) {
        if let title = title {
            whenReady(title)
            return
        }
        Backend.getTitle(for: self) { [weak self] title in
            self?.title = title
            whenReady(title ?? "")
        }
    }
    
    //custom string convertible protocol implementation
    var description: String {
        return "\(text) [at: \(image)]"
    }
}
