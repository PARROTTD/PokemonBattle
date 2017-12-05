//
//  randomPokemon.swift
//  PokedexClass
//
//  Created by Duncan Parrott on 12/4/17.
//  Copyright © 2017 Gallaugher. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class randomPokemon {
    var pokemon = Pokemon()
    var randomPokemonURL = "https://pokeapi.co/api/v2/pokemon/"
    var randPokeImage = ""
    var randPokeName = ""
    var originalPokemon = 151
    
    
    
    
    
    
    func getRandomPokemon(completed: @escaping () -> () ) {
        let randomPokemonNumber = String(arc4random_uniform(UInt32(originalPokemon)))
        Alamofire.request(randomPokemonURL+randomPokemonNumber).responseJSON {response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.randPokeName = json["forms"][0]["name"].stringValue
                self.randPokeImage = json["sprites"]["front_default"].stringValue
                print("Here's the data for pokemon \(self.randPokeName) and \(self.randomPokemonURL) ")
            case .failure(let error):
                print("ERROR: \(error) failed to get data from url\(self.randomPokemonURL)")
            }
            completed()
        }
    }
}
    












