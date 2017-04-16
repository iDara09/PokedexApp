//
//  LoadData.swift
//  PokedexApp
//
//  Created by Dara on 3/27/17.
//  Copyright © 2017 iDara09. All rights reserved.
//

import Foundation

enum PokemonSortedOption {
    case id
    case name
}

enum TypesSortedOption {
    case name
    case category
}

class LoadData {
    
    func pokemonsJSON() -> DictionarySA {
        
        return loadDataFromFile(name: "pokemons", ofType: "json")
    }
    
    func abilitiesJSON() -> DictionarySA {
        
        return loadDataFromFile(name: "abilites", ofType: "json")
    }
    
    func pokemonAbilitiesJSON() -> DictionarySA {
        
        return loadDataFromFile(name: "pokemon-abilities", ofType: "json")
    }
    
    func measurementsJSON() -> DictionarySA {
        
        return loadDataFromFile(name: "measurements", ofType: "json")
    }
    
    func weaknessesJSON() -> DictionarySA {
        
        return loadDataFromFile(name: "weaknesses", ofType: "json")
    }
    
    func pokedexEnteriesJSON() -> DictionarySA {
        
        return loadDataFromFile(name: "pokedex-enteries", ofType: "json")
    }
    
    func movesJSON() -> DictionarySA {
        
        return loadDataFromFile(name: "moves", ofType: "json")
    }
    
    func allPokemons(by option: PokemonSortedOption) -> [Pokemon] {
        
        var pokemons = [Pokemon]()
        let json = pokemonsJSON()
        let names = json.keys
        
        for name in names {
            if let pokemonInfo = json[name] as? DictionarySA, let id = pokemonInfo["id"] as? Int, let form = pokemonInfo["form"] as? String {
                pokemons.append(Pokemon(name: name, id: id, form: form))
            }
        }
        
        switch option {
        case .id:
            pokemons = pokemons.sorted(by: {"\($0.id.toPokedexId())\($0.form)" < "\($1.id.toPokedexId())\($1.form)"})
        case .name:
            pokemons = pokemons.sorted(by: {$0.name < $1.name})
        }
        
        return pokemons
    }
    
    func allMoves() -> [Move] {
        
        let moveJSON = movesJSON()
        var moves = [Move]()
        
        for name in moveJSON.keys.sorted() {
            if let moveDict = moveJSON[name] as? DictionarySS,
                let type = moveDict["type"],
                let category = moveDict["category"] {
                
                moves.append(Move(name: name, type: type, category: category))
            }
        }
        
        return moves
    }
    
    func allAbilities(by option: TypesSortedOption) -> [Ability] {
        
        return [Ability]()
    }
    
    func allType() -> [String] {
        
        let plist = loadDataFromFile(name: "constants", ofType: "plist")
        if let types = plist["PokemonTypes"] as? [String] {
            
            return types
        }
        
        return [String]()
    }
    
    func homeMenuSections() -> [String] {
        
        let plist = loadDataFromFile(name: "constants", ofType: "plist")
        if let homeMenu = plist["HomeMenu"] as? DictionarySA, let sections = homeMenu["Sections"] as? [String] {
            
            return sections
        }
        
        return [""]
    }
    
    func homeMenuRowsInSections() -> [[String]] {
        
        let plist = loadDataFromFile(name: "constants", ofType: "plist")
        if let homeMenu = plist["HomeMenu"] as? DictionarySA, let rowsInSection = homeMenu["RowsInSections"] as? [[String]] {
            
            return rowsInSection
        }
        
        return [[""]]
    }
    
    func pokemonTypes() -> [String] {
        
        let plist = loadDataFromFile(name: "constants", ofType: "plist")
        if let types = plist["PokemonTypes"] as? [String] {
            
            return types
        }
        
        return [String]()
    }
    
    private func loadDataFromFile(name: String, ofType type: String) -> DictionarySA {
        
        if let path = Bundle.main.path(forResource: name, ofType: type), let data = NSData(contentsOfFile: path) as Data? {
            do {
                if type == "json" {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? DictionarySA {
                        
                        return json
                    }
                } else {
                    if let plist = NSDictionary(contentsOfFile: path) as? DictionarySA {
                        
                        return plist
                    }
                }
            } catch { print(error) }
        }
        
        return DictionarySA()
    }
}
