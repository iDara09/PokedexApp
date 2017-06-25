//
//  GenericTVC.swift
//  PokedexApp
//
//  Created by Dara on 4/13/17.
//  Copyright © 2017 iDara09. All rights reserved.
//

import UIKit

enum GenericCell: String {
    
    case PokedexCell = "00"
    case TypeCell = "01"
    case MoveCell = "02"
    case AbilityCell = "03"
    case TMCell = "10"
    case ItemCell = "11"
    case BerryCell = "12"
}


class GenericTVC: UITableViewController, UISearchResultsUpdating {
    
    var genericCell: GenericCell! // will be assigned when perform segue
    
    var pokemons: [Pokemon]!
    var types: [String]!
    var moves: [Move]!
    var abilities: [Ability]!
    var items: [Item]!
    
    var searchResultController: UISearchController!
    var viewLauncher: ViewLauncher!
    
    var indexPath: IndexPath! //use to deselect row on viewLauncher dismissed
    var segmentControllSelectedIndex: Int?
    
    var currentGenericCell: GenericCell { return genericCell }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNecessaryData()
        configureNavigationBar()
        configureViewLauncher()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        viewLauncher.dismiss(animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        viewLauncher.removeFromSuperview()
    }

    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch currentGenericCell {
            
        case .PokedexCell:
            return pokemons.count
            
        case .TypeCell:
            return types.count
            
        case .MoveCell:
            return moves.count
            
        case .AbilityCell:
            return abilities.count
            
        case .TMCell:
            return items.count
            
        case .ItemCell:
            return items.count
            
        case .BerryCell:
            return items.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(currentGenericCell)", for: indexPath)
        
        switch currentGenericCell {
            
        case .PokedexCell:
            if let cell = cell as? PokedexCell {
                cell.configureCell(for: pokemons[indexPath.row])
                return cell
            }
            
        case .TypeCell:
            if let cell = cell as? TypeCell {
                cell.configureCell(type: types[indexPath.row])
                return cell
            }
            
        case .MoveCell:
            if let cell = cell as? MoveCell {
                cell.configureCell(for: moves[indexPath.row])
                return cell
            }
            
        case .AbilityCell:
            if let cell = cell as? AbilityCell {
                cell.configureCell(ability: abilities[indexPath.row])
                return cell
            }
            
        case .TMCell:
            if let cell = cell as? ItemCell {
                cell.configureCell(tm: items[indexPath.row])
                return cell
            }
            
        case .ItemCell:
            if let cell = cell as? ItemCell {
                cell.configureCell(item: items[indexPath.row])
                return cell
            }
            
        case .BerryCell:
            if let cell = cell as? ItemCell {
                cell.configureCell(berry: items[indexPath.row])
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        audioPlayer.play(audio: .select)
        
        switch currentGenericCell {
            
        case .PokedexCell:
            performSegue(withIdentifier: "PokemonInfoVC", sender: pokemons[indexPath.row])
            
        case .TypeCell:
            performSegue(withIdentifier: "TypeDetailTVC", sender: types[indexPath.row])
            
        case .MoveCell:
            performSegue(withIdentifier: "MoveDetailTVC", sender: moves[indexPath.row])
            
        case .AbilityCell:
            performSegue(withIdentifier: "AbilityDetailTVC", sender: abilities[indexPath.row])
            
        case .TMCell:
            self.indexPath = indexPath
            handleSelectedItemCellRow(sender: items[indexPath.row])
            
        case .ItemCell:
            self.indexPath = indexPath
            handleSelectedItemCellRow(sender: items[indexPath.row])
            
        case .BerryCell:
            self.indexPath = indexPath
            handleSelectedItemCellRow(sender: items[indexPath.row])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch sender {
            
        case is Pokemon:
            guard let pokemonInfoVC = segue.destination as? PokemonInfoVC, let pokemon = sender as? Pokemon else { return }
            pokemonInfoVC.pokemon = pokemon
            
        case is String: // type
            guard let typeDetailTVC = segue.destination as? TypeDetailTVC, let type = sender as? String else { return }
            typeDetailTVC.type = type
            
        case is Move:
            guard let moveDetailTVC = segue.destination as? MoveDetailTVC, let move = sender as? Move else { return }
            moveDetailTVC.move = move
            
        case is Ability:
            guard let abilityDetailTVC = segue.destination as? AbilityDetailTVC, let ability = sender as? Ability else { return }
            abilityDetailTVC.ability = ability
            
        default: ()
        }
    }
    
    
    
    
    // MARK: - Protocol
    
    func viewLauncher(willDismiss dismissOrigin: CGPoint) { // currently use with AbilityCell, TMCell, and ItemCell
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    // MARK: - IBActions
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        
        present(searchResultController, animated: true) {
            self.searchResultController.searchBar.becomeFirstResponder()
        }
    }
    
    
    
    
    // MARK: - Search
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.isActive, let searchText = searchController.searchBar.text, searchText != "" {
            
            switch currentGenericCell {
                
            case .PokedexCell:
                pokemons = VARIABLE.allPokemonsSortedById.filter(for: searchText, options: .caseInsensitive)
                
            case .TypeCell:
                types = VARIABLE.allTypes.filter({$0.range(of: searchText, options: .caseInsensitive) != nil})
                
            case .MoveCell:
                moves = VARIABLE.allMoves.filter(forName: searchText, options: .caseInsensitive)
                
            case .AbilityCell:
                abilities = VARIABLE.allAbilities.filter(for: searchText, options: .caseInsensitive)
                
            case .TMCell:
                items = VARIABLE.allItems.machines.filter(for: searchText, options: .caseInsensitive)
                
            case .ItemCell:
                items = VARIABLE.allItems.excludeBerriesMachines.filter(for: searchText, options: .caseInsensitive)
                
            case .BerryCell:
                items = VARIABLE.allItems.berries.filter(for: searchText, options: .caseInsensitive)
            }
            
        } else {
            
            switch currentGenericCell {
                
            case .PokedexCell:
                if segmentControllSelectedIndex == 0 {
                    pokemons = VARIABLE.allPokemonsSortedById
                } else {
                    pokemons = VARIABLE.allPokemonsSortedByName
                }
                
            case .TypeCell:
                types = VARIABLE.allTypes
                
            case .MoveCell:
                moves = VARIABLE.allMoves
                
            case .AbilityCell:
                abilities = VARIABLE.allAbilities
                
            case .TMCell:
                items = VARIABLE.allItems.machines
                
            case .ItemCell:
                if segmentControllSelectedIndex == 0 {
                    items = VARIABLE.allItems.excludeBerriesMachines
                } else {
                    items = VARIABLE.allItems.excludeBerriesMachines
                }
                
            case .BerryCell:
                items = VARIABLE.allItems.berries
            }
        }
        
        tableView.reloadData()
    }
    
    
    
    
    // MARK: - Initializer and Handler
    
    func prepareNecessaryData() {
        
        switch currentGenericCell {
            
        case .PokedexCell:
            pokemons = VARIABLE.allPokemonsSortedById
            
        case .TypeCell:
            types = VARIABLE.allTypes
            
        case .MoveCell:
            moves = VARIABLE.allMoves
            
        case .AbilityCell:
            abilities = VARIABLE.allAbilities
                        
        case .TMCell:
            items = VARIABLE.allItems.machines
            
        case .ItemCell:
            items = VARIABLE.allItems.excludeBerriesMachines
            
        case .BerryCell:
            items = VARIABLE.allItems.berries
        }
    }
    
    func configureNavigationBar() {
        
        searchResultController = UISearchController(searchResultsController: nil)
        searchResultController.loadViewIfNeeded()
        searchResultController.searchResultsUpdater = self
        searchResultController.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchResultController.searchBar
        
        if currentGenericCell == .PokedexCell {
            searchResultController.searchBar.placeholder = "Name, ID, Type, TypeType, Ability"
            
            let segmentControll: RoundUISegmentedControl = {
                let sc = RoundUISegmentedControl(items: ["0-9", "A-Z"])
                sc.selectedSegmentIndex = 0
                sc.addTarget(self, action: #selector(handleSegmentControllValueChange), for: .valueChanged)
                
                return sc
            }()
            
            navigationItem.rightBarButtonItems?.append(UIBarButtonItem(customView: segmentControll))
            self.segmentControllSelectedIndex = segmentControll.selectedSegmentIndex
            
        } else if currentGenericCell == .ItemCell {
            let segmentControll: RoundUISegmentedControl = {
                let sc = RoundUISegmentedControl(items: ["A-Z", "Cat"])
                sc.selectedSegmentIndex = 0
                sc.addTarget(self, action: #selector(handleSegmentControllValueChange), for: .valueChanged)
                
                return sc
            }()
            
            navigationItem.rightBarButtonItems?.append(UIBarButtonItem(customView: segmentControll))
            self.segmentControllSelectedIndex = segmentControll.selectedSegmentIndex
        }
    }
    
    func configureViewLauncher() {
        
        let y = Constant.Constrain.frameUnderNavController.origin.y
        let width = self.view.frame.width
        let height = self.view.frame.height - y
        let frame = CGRect(x: 0, y: y, width: width, height: height)
        
        viewLauncher = ViewLauncher(frame: frame)
        UIApplication.shared.keyWindow?.addSubview(viewLauncher)
        viewLauncher.dismiss(animated: false)
    }
    
    func handleSelectedItemCellRow(sender: Item) {
        
        viewLauncher.launchView.removeAllSubviews()
        viewLauncher.launchView.addTextView(text: sender.effect)
        viewLauncher.launch()
    }
    
    func handleSegmentControllValueChange(_ sender: UISegmentedControl) {
        
        self.segmentControllSelectedIndex = sender.selectedSegmentIndex
        
        switch  currentGenericCell {
            
        case .PokedexCell:
            if segmentControllSelectedIndex == 0 {
                pokemons = VARIABLE.allPokemonsSortedById
            } else { //must be 1
                pokemons = pokemons.sortByAlphabet()
            }
            
        case .ItemCell:
            if segmentControllSelectedIndex == 0 { //A-Z
                items = VARIABLE.allItems.excludeBerriesMachines.sorted(by: {$0.name < $1.name})
            } else { //must be 1, Cat.
                items = VARIABLE.allItems.excludeBerriesMachines.sorted(by: {$0.category < $1.category})
            }
            
        default: ()
        }
        
        tableView.reloadData()
    }
}
