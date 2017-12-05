//
//  PokeDetail.swift
//  PokedexClass
//
//  Created by John Gallaugher on 11/12/17.
//  Copyright © 2017 Gallaugher. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PokeDetail {
    var name = ""
    var weight = 0.0
    var height = ""
    var imageURL = ""
    var imageURLTwo = ""
    var pokeURL = ""
    var moveOne = ""
    var moveTwo = ""
    var moveThree = ""
    var moveFour = ""
    
    func getPokeDetail(completed: @escaping () -> () ) {
        Alamofire.request(pokeURL).responseJSON {response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.weight = json["weight"].doubleValue
                //self.height = json["height"].doubleValue
                self.moveOne = json["moves"][1]["move"]["name"].stringValue
                self.moveTwo = json["moves"][2]["move"]["name"].stringValue
                self.moveThree = json["moves"][3]["move"]["name"].stringValue
                self.moveFour = json["moves"][4]["move"]["name"].stringValue
                self.imageURL = json["sprites"]["back_default"].stringValue
                self.imageURLTwo = json["sprites"]["front_default"].stringValue
                print("Here's the data for pokemon \(self.name), \(self.weight),\(self.height) and \(self.pokeURL) ")
            case .failure(let error):
                print("ERROR: \(error) failed to get data from url\(self.pokeURL)")
            }
            completed()
        }
    }
}
