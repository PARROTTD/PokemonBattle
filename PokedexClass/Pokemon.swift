//
//  Pokemon.swift
//  PokedexClass
//
//  Created by John Gallaugher on 11/7/17.
//  Copyright © 2017 Gallaugher. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Pokemon {
    struct PokeData {
        var name: String
        var url: String
    }
    var pokeArray = [PokeData]()
    var totalPokemon = 0
    var urlsRetrieved = [String]()
    var pokemonURL = "https://pokeapi.co/api/v2/pokemon/"
    
    func getPokemon(completed: @escaping () -> () ) {
        
        urlsRetrieved.append(pokemonURL)
        Alamofire.request(pokemonURL).responseJSON {response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.totalPokemon = json["count"].intValue
                self.pokemonURL = json["next"].stringValue
                let numberOfPokemon = json["results"].count
                for index in 0...numberOfPokemon-1 {
                    let name = json["results"][index]["name"].stringValue
                    let url = json["results"][index]["url"].stringValue
                    self.pokeArray.append(PokeData(name: name, url: url))
                    print("\(index). \(name) \(url)")
                }
            case .failure(let error):
                print("ERROR: \(error) failed to get data from url\(self.pokemonURL)")
            }
            completed()
        }
    }
}
