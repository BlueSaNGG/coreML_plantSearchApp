//
//  netRequest.swift
//  plantDetector
//
//  Created by jinqi on 2021/6/23.
//

import Foundation
import Alamofire
import SwiftyJSON
import SDWebImage

protocol netRequestDelegate{
    func setLabelAndImageInMainQueue(flowerDescription: String, imageURLString: String)
}

class netRequest {
    var delegate: netRequestDelegate?
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    func makeSearchRequest(flowerName: String) {
        let parameters : [String:String] = [
        "format" : "json",
        "action" : "query",
        "prop" : "extracts|pageimages",
        "exintro" : "",
        "explaintext" : "",
        "titles" : flowerName,
        "indexpageids" : "",
        "redirects" : "1",
        "pithumbsize": "500",
        ]
        AF.request(wikipediaURl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseJSON { response in

            switch response.result {
            case .success(let value):
                let flowerJson: JSON = JSON(value)
                let pageID = flowerJson["query"]["pageids"][0].stringValue
                let flowerDescription = flowerJson["query"]["pages"][pageID]["extract"].stringValue
                let flowerImageURL = flowerJson["query"]["pages"][pageID]["thumbnail"]["source"].stringValue
                self.delegate?.setLabelAndImageInMainQueue(flowerDescription: flowerDescription, imageURLString: flowerImageURL)
            case .failure:
                print("failed to request")
            }
        }
    
    }
    
}
