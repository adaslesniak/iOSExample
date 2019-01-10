// ExampleObjectCell.swift [iOSExample] created by: Adas Lesniak on: 10/01/2019 
import UIKit
import Foundation


class ExampleObjectCell: UITableViewCell {
    public static let reusableId = "ExampleObjectCellView"
    
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        textLabel?.textColor = highlighted ? UIColor.white : UIColor.black
        contentView.backgroundColor = highlighted ? UIColor.blue : UIColor.clear //
        super.setHighlighted(highlighted, animated: animated)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        textLabel?.textColor = selected ? UIColor.white : UIColor.black
        contentView.backgroundColor = selected ? UIColor.red : UIColor.clear
    }
}
