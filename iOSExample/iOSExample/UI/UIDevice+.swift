// UIDevice+.swift [iOSExample] created by: Adas Lesniak on: 10/01/2019
import Foundation
import UIKit


extension UIDevice {

    //that is pretty dumb, but that's how task definition goes: "iPad and iPhone 6+ in landscape mode"
    var isDoubleViewSupportedInLandscape: Bool {
        let id: String = {
            if let simId = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                return simId
            }
            var sysinfo = utsname()
            uname(&sysinfo)
            return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        }()
        // https://www.theiphonewiki.com/wiki/Models
        if id.contains("iPad") {
            return true
        }
        if id.contains("iPhone7,1") { //iPhone6+
            return true
        }
        //other plus models are: "iPhone8,2", "iPhone9,2", "iPhone9,4", "iPhone10,3", "iPhone10,6" - and not mentioning all those Xcrap
        return false
    }
}
