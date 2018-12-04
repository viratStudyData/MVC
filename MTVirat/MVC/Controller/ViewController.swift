
import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var clcVw: UICollectionView!
    
    var arrData:[ModelClass]!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getData()
        self.decodedData()
    }

    func getData() {
        LoaderView.addOn(View: self.view)
        let params: [String: Any] = ["languageId":"57db712ea202dc0eb1ee0f93", "currentLocation":"[30,76]"]
        ModelClass.postData(withUrl: kAPI, withParameters: params, success: {(response) in
            LoaderView.hide()
            self.decodedData()
            
        }, failure: {(error) in
             LoaderView.hide()
        })

    }
    
    //MARK: CollectionView Data source and Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if arrData != nil {
            return arrData!.count
        }else {
            return 0
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrData!.count > 0 {
            return arrData[section].arrBusiness.count
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView,viewForSupplementaryElementOfKind kind: String,at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "Header",for: indexPath) as! CollectionHeaderView
            headerView.lbl.text = arrData[indexPath.section].categoryName
            headerView.backgroundColor = UIColor.lightGray
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        let imgUrlStr = arrData[indexPath.section].arrBusiness[indexPath.row].img
        cell.img.imageURL = URL(string: imgUrlStr)
        cell.lblCity.text = arrData[indexPath.section].arrBusiness[indexPath.row].city
        cell.lblHeading.text = arrData[indexPath.section].arrBusiness[indexPath.row].name
        cell.lblRating.text = "rating:" + arrData[indexPath.section].arrBusiness[indexPath.row].rating
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.size.width/3.0) - 8, height: 160)
    }

    
    //MARK: decodedData
    func decodedData() {
        
        if defaults.value(forKey: kAppData) != nil {
            if arrData != nil {
                arrData.removeAll()
            }
            LoaderView.hide()
            arrData = Utility.decodedObjecte(kAppData) as! [ModelClass]
            if self.arrData.count > 0 {
                self.clcVw.reloadData()
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

