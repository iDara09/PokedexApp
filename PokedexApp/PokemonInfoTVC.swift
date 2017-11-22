//
//  PokemonInfoTVC.swift
//  PokedexApp
//
//  Created by Dara Beng on 11/21/17.
//  Copyright © 2017 iDara09. All rights reserved.
//

import UIKit

class PokemonInfoTVC: UITableViewController {

    var cellIds: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellIds.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 210
        case 1: return 210
        default: return 300
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIds[indexPath.row], for: indexPath)
        cell.backgroundColor = .lightGray
        return cell
    }
    
    // MARK: - Function
    
    private func registerCells() {
        cellIds = ["\(PokeInfoCell.self)", "\(PokeEvolutionCell.self)"]
        tableView.register(PokeInfoCell.self, forCellReuseIdentifier: "\(PokeInfoCell.self)")
        tableView.register(PokeEvolutionCell.self, forCellReuseIdentifier: "\(PokeEvolutionCell.self)")
    }
}
