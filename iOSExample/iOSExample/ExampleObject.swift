// ExampleObject.swift [iOSExample] created by: Adas Lesniak on: 10/01/2019 


import Foundation

class ExampleObject {
    
    
    public private(set) var text: String
    public private(set) var image: URL
    
    //init with serialised json string
    //optional constructor as what come from backend is beyond our control so always be ready for trash data
    public init?(serialised: String) {
        return nil
    }
    
    //init with half deserialised json object
    //optional as we don't controll what comes from backend
    public init?(serialised: [String:Any]) {
        return nil
    }
}
