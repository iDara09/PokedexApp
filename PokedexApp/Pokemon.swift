//
//  Pokemon.swift
//  PokedexApp
//
//  Created by Dara on 3/27/17.
//  Copyright © 2017 iDara09. All rights reserved.
//

import Foundation

class Pokemon {
    
    private var _name: String = ""
    private var _id: Int = 0
    private var _form: String = ""
    
    private var _hp: Int = 0
    private var _attack: Int = 0
    private var _defense: Int = 0
    private var _spAttack: Int = 0
    private var _spDefense: Int = 0
    private var _speed: Int = 0
    
    private var _primaryType: String = ""
    private var _secondaryType: String = ""
    
    private var _firstAbility: String = ""
    private var _secondAbility: String = ""
    private var _hiddenAbility: String = ""
    
    private var _height: [String] = []
    private var _weight: [String] = []
    
    private var _evolveFrom: String = ""
    private var _evolveTo: String = ""
    
    private var _hasCompletedInfo: Bool = false //true if parseCompletedInfo() is called once
    
    var hasCompletedInfo: Bool { return _hasCompletedInfo }
    
    var name: String { return _name }
    var id: Int { return _id }
    var form: String { return _form }
    
    var hp: Int { return _hp }
    var attack: Int { return _attack }
    var defense: Int { return _defense }
    var spAttack: Int { return _spAttack }
    var spDefense: Int { return _spDefense }
    var speed: Int { return _speed }
    
    var primaryType: String { return _primaryType }
    var secondaryType: String { return _secondaryType }
    
    var firstAbility: String { return _firstAbility }
    var secondAbility: String { return _secondAbility }
    var hiddenAbility: String { return _hiddenAbility }
    
    var evolveFrom: String { return _evolveFrom }
    var evolveTo: String { return _evolveTo }
    
    func getHeight(as unit: Unit) -> String { return _height[unit.rawValue] }
    func getWeight(as unit: Unit) -> String { return _weight[unit.rawValue] }
    
    
    init(name: String, id: Int, form: String, types: [String], hasCompletedInfo: Bool = false) {
        _name = name
        _id = id
        _form = form
        _hasCompletedInfo = hasCompletedInfo
        
        switch types.count {
        case 1:
            _primaryType = types[0]
        default:
            _primaryType = types[0]
            _secondaryType = types[1]
        }
    }
    
    
    func parseCompletedInfo() {
        
        parseStatsTypes()
        parseAbilities()
        parseMeasurement()
        parseEvolution()
        
        _hasCompletedInfo = true
    }
    
    private func parseStatsTypes() {
        
        if let pokeInfo = CONSTANTS.pokemonsJSON[name],
            let hp = pokeInfo["hp"] as? Int,
            let attack = pokeInfo["attack"] as? Int,
            let defense = pokeInfo["defense"] as? Int,
            let spAttack = pokeInfo["sp-attack"] as? Int,
            let spDefense = pokeInfo["sp-defense"] as? Int,
            let speed = pokeInfo["speed"] as? Int {
            
            _hp = hp
            _attack = attack
            _defense = defense
            _spAttack = spAttack
            _spDefense = spDefense
            _speed = speed
        }
    }
    
    private func parseAbilities() {
        
        if let abilities = CONSTANTS.pokemonAbilitiesJSON[name],
            let ability01 = abilities["ability01"] as? String,
            let ability02 = abilities["ability02"] as? String,
            let hiddenAbility = abilities["hidden"] as? String {
            
            _firstAbility = ability01
            _secondAbility = ability02
            _hiddenAbility = hiddenAbility
        }
    }
    
    private func parseMeasurement() {
        
        if let measurements = CONSTANTS.measurementsJSON[name],
            let height = measurements["height"] as? String,
            let weight = measurements["weight"] as? String {
            
            _height = height.components(separatedBy: ", ")
            _weight = weight.components(separatedBy: ", ")
        }
    }
    
    private func parseEvolution() {
        
        var name = self.name
        
        if self.hasForm {
            if self.form.contains("mega") || self.form.contains("primal"), let selfNoForm = CONSTANTS.allPokemonsSortedById.filter({$0.id == self.id}).first {
                name = selfNoForm.name
            }
        }
        
        if let evolutions = CONSTANTS.evolutionsJSON[name] as? [DictionarySS] {
            if let evolution = evolutions.first,
                let evolveFrom = evolution["evolve-from"],
                let evolveTo = evolution["evolve-to"] {
                
                _evolveFrom = evolveFrom
                _evolveTo = evolveTo
            }
        }
        
        // TODO: - case where pokemon is a mega evolution, other forms, or not in json
    }
}


// MARK: - Extension for Pokemon
extension Pokemon {
    
    var hasSecondType: Bool {
        
        return self.secondaryType != ""
    }
    
    var hasSecondAbility: Bool {
        
        return self.secondAbility != ""
    }
    
    var hasHiddenAbility: Bool {
        
        return self.hiddenAbility != ""
    }
    
    var hasForm: Bool {
        
        return self.form != ""
    }
    
    var hasNoEvolution: Bool {
        
        return self.evolveFrom == "" && self.evolveTo == ""
    }
    
    var isBaseEvolution: Bool {
        
        return self.evolveFrom == "" && self.evolveTo != ""
    }
    
    var isMidEvolution: Bool {
        
        return self.evolveFrom != "" && self.evolveTo != ""
    }
    
    var isLastEvolution: Bool {
        
        return self.evolveFrom != "" && self.evolveTo == ""
    }
    
    var imageName: String {
        
        return self.hasForm ? "\(self.id)-\(self.form)" : "\(self.id)"
    }
    
    var crySound: String {
        
        let id = String(format: "%03d-", self.id)
        var crySound = self.name
        
        if CONSTANTS.crySoundSepcialCaseName.keys.contains(crySound),
            let name = CONSTANTS.crySoundSepcialCaseName[crySound] {
            
            crySound = name
        }
        
        return "\(id)\(crySound)"
    }
    
    
    var evolutions: [Pokemon] {
        
        var evolutions = [Pokemon]()
        var selfNoForm = self
        
        if self.hasForm {
            if CONSTANTS.evolutionSpecialCaseForm.contains(self.form),
                let noFormPokemon = CONSTANTS.allPokemonsSortedById.filter({$0.id == self.id}).first {
                selfNoForm = noFormPokemon
            }
        }
        
        if !selfNoForm.hasCompletedInfo {
            selfNoForm.parseCompletedInfo()
        }
        
        evolutions = [selfNoForm]
        
        if selfNoForm.isBaseEvolution { // MARK: - isBaseEvolution
            if let evolveToPokemon = CONSTANTS.allPokemonsSortedById.filter({$0.name == selfNoForm.evolveTo}).first {
                if !evolveToPokemon.hasCompletedInfo {
                    evolveToPokemon.parseCompletedInfo()
                }
                
                if evolveToPokemon.isLastEvolution {
                    evolutions = [selfNoForm, evolveToPokemon]
                } else { //isMidEvolution
                    if let lastEvolution = CONSTANTS.allPokemonsSortedById.filter({$0.name == evolveToPokemon.evolveTo}).first {
                        evolutions = [selfNoForm, evolveToPokemon, lastEvolution]
                    }
                }
            }
        } else if selfNoForm.isMidEvolution { // MARK: - isMidEvolution
            if !self.hasCompletedInfo {
                self.parseCompletedInfo()
            }
            
            if let baseEvolution = CONSTANTS.allPokemonsSortedById.filter({$0.name == selfNoForm.evolveFrom}).first, let lastEvolution = CONSTANTS.allPokemonsSortedById.filter({$0.name == selfNoForm.evolveTo}).first {
                evolutions = [baseEvolution, selfNoForm, lastEvolution]
            }
        } else if selfNoForm.isLastEvolution { // MARK: - isLastEvolution
            if let evolveFromPokemon = CONSTANTS.allPokemonsSortedById.filter({$0.name == selfNoForm.evolveFrom}).first {
                if !evolveFromPokemon.hasCompletedInfo {
                    evolveFromPokemon.parseCompletedInfo()
                }
                
                if evolveFromPokemon.isBaseEvolution {
                    evolutions = [evolveFromPokemon, selfNoForm]
                } else { //isMidEvollution
                    if let baseEvolution = CONSTANTS.allPokemonsSortedById.filter({$0.name == evolveFromPokemon.evolveFrom}).first {
                        evolutions = [baseEvolution, evolveFromPokemon, selfNoForm]
                    }
                }
            }
        }

        return evolutions //return an array with one element which is itself
    }
    
    var weaknesses: DictionarySS {
        
        var weaknessesDict = DictionarySS()
        
        if primaryType != "" {
            if let weaknesses = CONSTANTS.weaknessesJSON["\(primaryType)\(secondaryType)"] as? DictionarySS {
                for (type, effective) in weaknesses where effective != "" {
                    weaknessesDict.updateValue(effective, forKey: type)
                }
            }
        }
        
        return weaknessesDict
    }
    
    var pokedexEntry: String {
        
        if let pokedexEntry = CONSTANTS.pokedexEntriesJSON["\(self.id)"] as? DictionarySS {
            if let omegaEntry = pokedexEntry["omega"], let alphaEntry = pokedexEntry["alpha"] {
                if omegaEntry != alphaEntry {
                    return "OR:\n\(omegaEntry)\n\nAS:\n\(alphaEntry)"
                } else {
                    return "ORAS:\n\(omegaEntry)"
                }
            }
        }
        
        return "\(self.name)..."
    }
}


// MARK: - Extension for [Pokemon]
extension Array where Element: Pokemon {
    
    func sortById() -> [Pokemon] {
        
        return self.sorted(by: {"\($0.id.toPokedexId())\($0.form)" < "\($1.id.toPokedexId())\($1.form)"})
    }
    
    func sortByAlphabet() -> [Pokemon] {
        
        return self.sorted(by: {$0.name < $1.name})
    }
    
    func filter(forName name: String, options: String.CompareOptions) -> [Pokemon] {
        
        return self.filter({$0.name.range(of: name, options: options) != nil})
    }
    
    func filter(forType type: String) -> [Pokemon] {
        
        return self.filter({$0.primaryType == type || $0.secondaryType == type})
    }
}
