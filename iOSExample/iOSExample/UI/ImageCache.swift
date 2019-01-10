// ImageCache.swift [iOSExample] created by: Adas Lesniak on: 10/01/2019
import Foundation
import UIKit


//yeah there is no need for .shared to be typed in multiple times... and statics are in many ways safer than singletons
class ImageCache {
    
    //Implementation is totally not scallable, but interface is OK even for biggest app
    private static var cache = [URL:UIImage]()
    
    
    //FIXME: could do something about duplicates, if it is called with the same adress while previous answer for this address didn't yet finished
    static func get(_ address: URL, whenReady: @escaping (UIImage) -> Void) {
        if let cached = cache[address] {
            ExecuteOnMain {
                whenReady(cached)
            }
            return
        }
        let download = URLSession.shared.dataTask(with: address) { data, response, error in
            guard let imgData = data, error == nil else {
                print("ERROR: couldn't download image")
                return
            }
            guard let image = UIImage(data: imgData) else {
                print("ERROR: wrong data, couldn't create image")
                return
            }
            cache[address] = image
            ExecuteOnMain {
                whenReady(image)
            }
        }
        ExecuteInBackground {
            download.resume()
        }
    }
    
}
