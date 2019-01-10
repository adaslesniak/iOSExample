// DictionaryExtension.swift [SwiftSugar] created by: Adas Lesniak on: 18/01/2018
import Foundation


//designed for help working with NSDictionary understand as Tree of key value pairs,
//especially usable with JSON like structures, - NSAttributedString is good example of such structures
extension Dictionary where Key == String, Value == Any {
    public typealias Tree = [String:Any]
    
    public init?(jsonData: Data?) {
        do {
            guard let theData = jsonData else {
                throw Exception.error("no data")
            }
            guard let jsonObj = try JSONSerialization.jsonObject(with: theData, options: .allowFragments) as? Dictionary<String,Any> else {
                throw Exception.error("not a dictionary")
            }
            if let dataObj = jsonObj.valueAtPath("data") as? Dictionary<String,Any> {
                self = dataObj
            }
            self = jsonObj
        } catch {
            return nil
        }
    }
    
    public func valueAtPath(_ keyPath: String) -> Any? {
        var path: [String] = []
        
        let splited = keyPath.split(separator: ".")
        for step in splited {
            path.append(String(step))
        }
        let key = path.removeLast()
        
        var subdirectory: Tree? = self
        for step in path {
            guard let current = subdirectory else {
                return nil
            }
            subdirectory = current[String(step)] as? Tree
            if subdirectory == nil {
                return nil
            }
        }
        guard let finalAddress = subdirectory else {
            return nil
        }
        return finalAddress[key]
    }
    
    public mutating func append(_ value: Any, atKeyPath: String) {
        var path: [String] = []
        for step in atKeyPath.split(separator: ".") {
            path.append(String(step))
        }
        append(value, atPath: path)
    }
    
    private func adding(_ value: Any, at path: [String]) -> Tree {
        var changed = self
        if path.count == 1 {
            changed[path.first!] = value
            return changed
        }
        changed.append(value, atPath: path)
        return changed
    }
    
    private mutating func append(_ value: Any, atPath: [String]) {
        var path = atPath
        if path.count == 1 {
            self[path.first!] = value
            return
        }
        let subKey = path.remove(at: 0)
        let toBeReplaced = (self[subKey] as? Tree) ?? Tree()
        self[subKey] = toBeReplaced.adding(value, at: path)
    }
}


//============== TEST CODE =================
class DictionaryAppendAtKeyPathTest {
    private enum TestKeys:String {
        case abc1 = "a.b.c.1"
        case d1 = "d.1"
        case d2 = "d.2"
        case ef1 = "e.f.1"
        case ef2 = "e.f.2"
        case eg1 = "e.g.1"
        case eh1 = "e.h.1"
        case ehi1 = "e.h.i.1"
        case jklm1 = "j.k.l.m.1"
        case jklm2 = "j.k.l.m.2"
        case jkln1 = "j.k.l.n.1"
        case jko1 = "j.k.o.1"
        case jkop1 = "j.k.o.p.1"
        case r1 = "r.1"
        case rs1 = "r.s.1"
        case root1 = "one"
        case root2 = "two"
        case ab1 = "a.b.1"
        case ab2 = "a.b.2"
        case d3 = "d.3"
        
        static func all() -> [TestKeys] {
            let all: [TestKeys] = [.abc1, .d1, .d2, .ef1, .ef2, .eg1, .eh1, .jklm1, .jklm2, .jkln1, .jko1, .jkop1, .r1, .rs1, .root1, .root2, .ab1, .ab2, .d3]
            return all //would be good to randomize order for sake of tests
        }
    }
    
    
    //test code
    init() {
        var dict: [String:Any] = [:]
        let testCases = TestKeys.all()
        for key in testCases {
            dict.append("\(key)", atKeyPath: key.rawValue)
            logDict(dict)
        }
        for key in testCases {
            dict.append("\(key)_alter", atKeyPath: key.rawValue)
            logDict(dict)
        }
        for key in testCases {
            if let value = dict.valueAtPath(key.rawValue) {
                print("got value[\(type(of: value))] at: \(key.rawValue)")
            } else {
                print("no value at: \(key.rawValue)")
            }
        }
    }
    
    
    typealias KVP = (key: String, value: Any)
    func logDict(_ dict: [String:Any]) {
        print("-> \(dict.count) root elements {\(dict)}")
        var spacing = 1
        func prefix() -> String{
            var pre = " "
            for _ in 0...spacing {
                pre += "  "
            }
            return pre
        }
        
        func logKvp(_ toLog: KVP) {
            print("\(prefix())\(toLog.key) :  \(toLog.value)")
        }
        
        func logSub(_ inside: KVP) {
            guard let sub = inside.value as? [String:Any] else {
                logKvp(inside)
                return
            }
            print("\(prefix())\(inside.key):")
            spacing += 1
            for subsub in sub {
                logSub(subsub)
            }
            spacing -= 1
        }
        
        for thing in dict {
            logSub(thing)
            print("\n")
        }
    }
}
