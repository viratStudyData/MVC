//
//  APIDataModel.swift
//  TestVirat
//
//  Created by cbl16 on 7/27/18.
//  Copyright © 2018 Codebrew. All rights reserved.
//

import UIKit

class ModelClass: NSObject, NSCoding {
    
    
    var categoryName: String        =   ""
    var arrBusiness: [Detail]       =   [Detail]()
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(categoryName, forKey: "categoryName")
        aCoder.encode(arrBusiness as AnyObject , forKey: "arrBusiness")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        categoryName = aDecoder.decodeObject(forKey: "categoryName") as? String ?? ""
        arrBusiness = aDecoder.decodeObject(forKey: "arrBusiness") as? [Detail] ?? []
        
    }
    
    
    //MARK: Parser Data
    class func parserData(_ arrData: [[String: Any]]) -> [ModelClass] {
        
        var arr: [ModelClass] = [ModelClass]()
        
        for dict in arrData {
            let arrBusiness:[[String: AnyObject]] =  dict["businessList"] as! [[String: AnyObject]]
            if arrBusiness.count > 0 {
                let obj: ModelClass = ModelClass()
                obj.categoryName = dict["categoryName"] as! String
                
                for val in arrBusiness {
                    print(val)
                    let image = val["profilePic"]!["original"] as? String ?? ""
                    let city = (val["business_address"] as! [AnyObject])[0]["city"] as? String ?? ""
                    let name = val["name"] as? String ?? ""
                    let rating = val["ratings"] as? String ?? ""
                    let detailObj = Detail(name: name, city: city, rating: rating, img: image)
                    obj.arrBusiness.append(detailObj)
                    
                }
                
                arr.append(obj)
            }
        }
        
        Utility.encodeObject(objectName: arr as AnyObject, keyName: kAppData)
        
        return arr
        
    }
    
    
    
    
    class func postData(withUrl urlStr:String,withParameters params:[String: Any],success:@escaping ([ModelClass]) -> (), failure: @escaping (String) ->()) {
        
        APIHandler.callPost(url: urlStr, params: params, success: {(response) in
            print(response)
            let arr = self.parserData(response["data"] as! [[String : Any]]) as [ModelClass]
            success(arr)
        }, failure: {(error) in
            failure(error)
        })
    }
}
class Detail: NSObject, NSCoding {
    var name: String
    var city: String
    var rating: String
    var img: String
    
    init(name:String, city:String, rating:String, img: String) {
        self.name = name
        self.city = city
        self.rating = rating
        self.img = img
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(city , forKey: "city")
        aCoder.encode(rating , forKey: "rating")
        aCoder.encode(img , forKey: "img")

    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        city = aDecoder.decodeObject(forKey: "city") as? String ?? ""
        rating = aDecoder.decodeObject(forKey: "rating") as? String ?? ""
        img = aDecoder.decodeObject(forKey: "img") as? String ?? ""

        
    }
    
}


