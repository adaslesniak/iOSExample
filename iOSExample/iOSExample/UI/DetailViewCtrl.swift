// DetailViewCtrl.swift [iOSExample] created by: Adas Lesniak on: 10/01/2019
import Foundation
import UIKit


class DetailViewCtrl: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var label: UILabel!
    private var data: ExampleObject!
    
    
    public static func create(_ data: ExampleObject) -> DetailViewCtrl {
        let ctrl = DetailViewCtrl(nibName: "DetailView", bundle: nil)
        ctrl.data = data
        ctrl.loadData()
        return ctrl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    
    //that is probably just my bad experience, but I am never sure about order of execution - viewDidLoad vs assigning ctrl.data = data in factory
    private func loadData() {
        if data == nil || label == nil || label.text == data.text {
            return //was already loaded or there is no data yet or view is not yet loaded
        }
        ImageCache.get(data.image) { [weak self] image in
            self?.imgView.image = image
        }
        label.text = data.text
        data.getTitle { [weak self] theTitle in
            print("setting title: \(theTitle)")
            self?.label.text = theTitle
        }
    }
    
}
