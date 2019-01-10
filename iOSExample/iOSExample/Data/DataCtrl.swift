// DataCtrl.swift [iOSExample] created by: Adas Lesniak on: 10/01/2019 


import Foundation

//DataCtrl and ModelCtrl is static entry point for all business logic. Here is the access point to all data and not mix it with UI code... and no code should be here - this is just a bridge to define what data can be accessed. Every viewCtrl should never access any data except trough what is exposed here
//In any more complicated app everything behind DataCtrl including DataCtl should be moved to separate project and DataCtrl
class DataCtrl {
    
    public private(set) static var news = ExampleChannel() //naming sucks here, but in case of exaple there is not meaning full name for whatever
    
    
}
