// DetailViewCtrl.swift [iOSExample] created by: Adas Lesniak on: 10/01/2019
import Foundation
import UIKit


class DetailViewCtrl: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var label: UILabel!
    public private(set) var data: ExampleObject?
    
    
    //In my opinion knowledge about nibname should belong to viewCtrl and shouldn't be required outside
    public static func create() -> DetailViewCtrl {
        return DetailViewCtrl(nibName: "DetailView", bundle: nil)
    }
    
    func loadData(_ data: ExampleObject?) {
        self.data = data
        guard label != nil, imgView != nil else {
            print("ERROR: how on earth?")
            ExecuteOnMain(after: 0.3) { [weak self] in
                self?.loadData(data)
            }
            return
        }
        
        label.text = data?.text
        guard let newData = data else {
            imgView.image = nil
            return
        }
        ImageCache.get(newData.image) { [weak self] image in
            self?.imgView.image = image
        }
        label.text = newData.text
        newData.getTitle { [weak self] theTitle in
            ExecuteOnMain {
                self?.label.text = theTitle
            }
        }
    }
    
}
