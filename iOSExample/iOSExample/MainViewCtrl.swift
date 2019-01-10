// ViewController.swift [] created by: Adas Lesniak on: 10/01/2019 
import UIKit


class MainViewCtrl: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let cellId = "newsTableViewCellId"
    
    @IBOutlet weak var newsTable: UITableView! //it's just random name, but naming things by their class name should be punishable and means that someone don't care what he writes and does it make sense

    override func viewDidLoad() {
        super.viewDidLoad()
        newsTable.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        newsTable.delegate = self
        newsTable.dataSource = self
        DataCtrl.news.registerForUpdates(self) { [weak self] in  //TODO: in real app this should be unregistred
            self?.newsTable.reloadData()
        }
        DataCtrl.news.update()
    }
    
    
    // ======== TABLE DATA SOURCE ==========
    //simple passing info from DataCtrl to tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataCtrl.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = newsTable.dequeueReusableCell(withIdentifier: cellId) else {
            fatalError("ehmm.... it is registred so should work")
        }
        guard let cellData = DataCtrl.news[indexPath.row] else {
            print("ERROR: couldn't get data for cell at index: \(indexPath.row)") //hate that, but don't have yet proper Log in my utils
            cell.textLabel?.text = ""
            cell.imageView?.image = nil
            return cell
        }
        cell.textLabel?.text = cellData.text
        ImageCache.get(cellData.image) { image in
            guard cell.textLabel?.text == cellData.text else {
                print("too late, cell reused before we got image...")
                return //this cell was reused and displays something else now
            }
            cell.imageView?.image = image
            //that's ugly way - default cells when image is loaded async have imgView frame of size 0, need to reset it for image to be visible, but then default cells are not about beauty
            cell.imageView?.frame = CGRect( //FIXME: centering that propeprly (including case where image size is bigger than cell)
                x: 20,
                y: 4,
                width: image.size.width,
                height: image.size.height)
            cell.textLabel?.frame = CGRect(
                x: 40 + image.size.width,
                y: 0,
                width: cell.textLabel!.frame.width,
                height: cell.textLabel!.frame.height
            )
        }
        return cell
    }

}



