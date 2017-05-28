//
//  MoveDetailTVC.swift
//  PokedexApp
//
//  Created by Dara on 4/20/17.
//  Copyright © 2017 iDara09. All rights reserved.
//

import UIKit

class MoveDetailTVC: UITableViewController, TypeUILabelDelegate {
    
    var move: Move! //will be assigned during segue
    var moves: [Move]!
    var pokemons: [Pokemon]!
    
    var segmentControl: RoundUISegmentedControl!
    
    let moveDetailCellSection = 0
    let pokemonCellSection = 1

    var moveDetailCellHeight: CGFloat = 240
    
    var currentSCIndex: Move.LearnMethod {
        return Move.LearnMethod(rawValue: segmentControl.selectedSegmentIndex)!
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = move.name
        
        moves = CONSTANTS.allMoves.filter(forType: move.type)
        pokemons = move.pokemonsLearn(by: .any)

        configureSegmentControl()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case moveDetailCellSection:
            return 1
            
        case pokemonCellSection:
            return pokemons.count
            
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case moveDetailCellSection:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MoveDetailCell", for: indexPath) as? MoveDetailCell {
                cell.configureCell(for: moves[indexPath.row])
                moveDetailCellHeight = cell.height
                return cell
            }
            
        case pokemonCellSection:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PokedexCell", for: indexPath) as? PokedexCell {
                cell.configureCell(for: pokemons[indexPath.row])
                return cell
            }
            
        default:()
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
            
        case moveDetailCellSection:
            return moveDetailCellHeight
            
        default:
            return UITableViewCell().frame.height
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return sectionHeaderViewHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
            
        case moveDetailCellSection:
            let sectionHeaderView: SectionUILabel = {
                let label = SectionUILabel(frame: CGRect(x: 0, y: 0, width: sectionHeaderViewWidth, height: sectionHeaderViewHeight))
                label.layer.cornerRadius = 0
                label.text = "Move Detail"
                return label
            }()
            
            return sectionHeaderView
            
        case pokemonCellSection:
            let sectionHeaderView: UIView = {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: sectionHeaderViewWidth, height: sectionHeaderViewHeight))
                view.backgroundColor = UIColor.myColor.sectionBackground
                return view
            }()
            
            sectionHeaderView.addSubview(segmentControl)
            return sectionHeaderView
            
        default:
            return UIView()
        }
    }
    
    
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let typeDetailTVC = segue.destination as? TypeDetailTVC, let type = sender as? String {
            typeDetailTVC.type = type
        }
    }
    
    
    
    
    // MARK: - Protocol
    
    func typeUILabel(didTap tapGesture: UITapGestureRecognizer) {
        
        performSegue(withIdentifier: "TypeDetailTVC", sender: move.type)
    }
    
    
    
    
    // MARK: - Initializer and Handler
    
    func configureSegmentControl() {
        
        let spacing: CGFloat = 8
        
        segmentControl = {
            let sc = RoundUISegmentedControl(items: ["All", "Level Up", "Breed / Others"])
            sc.frame.origin = CGPoint(x: spacing, y: spacing)
            sc.frame.size.width = sectionHeaderViewWidth - spacing * 2
            sc.tintColor = UIColor.myColor.get(from: move.type)
            sc.layer.borderColor = sc.tintColor.cgColor
            sc.backgroundColor = UIColor.white
            
            sc.selectedSegmentIndex = 0
            
            sc.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
            return sc
        }()
    }
    
    func segmentControlValueChanged(_ sender: RoundUISegmentedControl) {
        
        
            switch currentSCIndex {
            case .any:
                pokemons = move.pokemonsLearn(by: .any)
                
            case .levelup:
                pokemons = move.pokemonsLearn(by: .levelup)
                
            case .breedOrMachine:
                pokemons = move.pokemonsLearn(by: .breedOrMachine)
            }
        
        tableView.reloadData()
        
        let pokemonCellSectionRows = tableView.numberOfRows(inSection: pokemonCellSection)
        
        if pokemonCellSectionRows != 0 {
            tableView.scrollToRow(at: IndexPath.init(row: 0, section: pokemonCellSection), at: .top, animated: true)
            //tableView.separatorColor = UIColor.myColor.tableViewSeparator
            
        } else {
            tableView.scrollToRow(at: IndexPath.init(row: 0, section: moveDetailCellSection), at: .top, animated: true)
            //tableView.separatorColor = UIColor.clear
        }
    }
}




// MARK: Computed Property
extension MoveDetailTVC {
    
    var sectionHeaderViewWidth: CGFloat {
        return tableView.frame.width
    }
    
    var sectionHeaderViewHeight: CGFloat {
        return CONSTANTS.constrain.sectionHeaderViewHeight
    }
}
