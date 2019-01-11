// ViewController.swift [] created by: Adas Lesniak on: 10/01/2019 
import UIKit


class MainViewCtrl: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var iSelectedRow: IndexPath! = nil
    private var detailCtrl: DetailViewCtrl!
    private var detailContainer: UIView! { return detailCtrl.view }
    
    @IBOutlet weak var newsTable: UITableView! //it's just random name, but naming things by their class name should be punishable and means that someone don't care what he writes and does it make sense

    //because knowledge about what nibName belongs here
    public static func instantiate() -> MainViewCtrl {
        return MainViewCtrl(nibName: "MainView", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTable.register(ExampleObjectCell.self, forCellReuseIdentifier: ExampleObjectCell.reusableId)
        newsTable.delegate = self
        newsTable.dataSource = self

        detailCtrl = DetailViewCtrl.create()
        addChild(detailCtrl)
        view.addSubview(detailCtrl.view)
        detailCtrl.view.frame = CGRect(x: view.frame.width, y: 0, width: 0, height: 0)
        detailContainer.addAction(.tap) { [weak self] in
            self?.detailCtrl.loadData(nil)
            self?.updateDetailViewFrame()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateDetailViewFrame), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        DataCtrl.news.registerForUpdates(self) { [weak self] in  //TODO: in real app this should be unregistred
            self?.newsTable.reloadData()
            let iZero = IndexPath(row: 0, section: 0)
            print("autoSelcting row: \(iZero.row)")
            ExecuteOnMain(after: 0.1) { //that is HACK
                self?.newsTable.selectRow(at: iZero, animated: false, scrollPosition: .none)
            }
        }
        DataCtrl.news.update()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self) //better safe than sorry
        DataCtrl.news.unregisterFromUpdates(self) //as above
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataCtrl.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = newsTable.dequeueReusableCell(withIdentifier: ExampleObjectCell.reusableId) else {
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
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select row: \(indexPath.row)")
        guard let cellData = DataCtrl.news[indexPath.row] else {
            print("ERROR: ....")
            return
        }
        defer {
            iSelectedRow = indexPath
        }
        guard let oldSelection = iSelectedRow else {
            return //first selction, no user triggered, don't open detail view
        }
        if oldSelection != indexPath {
            table.deselectRow(at: oldSelection, animated: true)
        }
        detailCtrl.loadData(cellData)
        updateDetailViewFrame()
    }
    
    private func detailFrame() -> CGRect {
        if detailCtrl?.data == nil {
            return CGRect(x: view.frame.width, y: 0, width: 0, height: 0) //hide to top right corner
        } else if UIDevice.current.orientation.isLandscape {
            return CGRect(x: view.frame.width/2, y: 0, width: view.frame.width/2, height: view.frame.height)
        } else {
            return CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        }
    }
    
    //objc beacuase notification system is still ancient
    @objc private func updateDetailViewFrame() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.detailContainer.frame = self.detailFrame()
        }
    }

}



