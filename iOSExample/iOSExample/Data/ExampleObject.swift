// ExampleObject.swift [iOSExample] created by: Adas Lesniak on: 10/01/2019 


import Foundation

class ExampleObject: CustomStringConvertible {
    
    
    public private(set) var text: String
    public private(set) var image: URL
    
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
    
    //custom string convertible protocol implementation
    var description: String {
        return "\(text) [at: \(image)]"
    }
}