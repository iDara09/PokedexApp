//
//  PokeInfoCell.swift
//  PokedexApp
//
//  Created by Dara Beng on 11/21/17.
//  Copyright © 2017 iDara09. All rights reserved.
//

import UIKit

class PokeInfoCell: UITableViewCell {
    
    let idLabel = SectionUILabel()
    let pokeImageView = UIImageView()
    
    let primaryTypeLabel = TypeUILabel()
    let secondaryTypeLabel = TypeUILabel()
    
    let abilityLabel = SectionUILabel()
    let firstAbilityLabel = AbilityUILabel()
    let secondAbilityLabel = AbilityUILabel()
    let hiddenAbilityLabel = AbilityUILabel()
    let defenseLabel = SectionUILabel()
    
    private var primaryTypeLabelWidthAnchor: NSLayoutConstraint!
    private var primaryTypeLabelTrailingAnchor: NSLayoutConstraint!
    
    var pokemon: DBPokemon!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: false)
    }
    
    private func configureCell() {
        configureConstraints()
        configureCell(pokemon: nil)
    }
    
    public func configureCell(pokemon: DBPokemon?) {
//        self.pokemon = pokemon
        self.pokemon = PokeData.pokemonMap["0007Squirtle"]!
        updateIdLabel()
        updatePokeImageView()
        updateTypeLabels()
        updateAbilityLabels()
        updateDefenseLabel()
    }
    
    private func updateIdLabel() {
        idLabel.text = pokemon.info.id.toPokedexId()
    }
    
    private func updatePokeImageView() {
        pokeImageView.image = UIImage(named: "\(pokemon.info.id)")
        pokeImageView.contentMode = .scaleAspectFit
    }
    
    private func updateTypeLabels() {
        primaryTypeLabel.text = pokemon.types.primary
        secondaryTypeLabel.text = pokemon.types.secondary
        switch pokemon.types.hasSecondary {
        case true:
            primaryTypeLabelWidthAnchor.isActive = false
            primaryTypeLabelTrailingAnchor.isActive = true
        case false:
            primaryTypeLabelTrailingAnchor.isActive = false
            primaryTypeLabelWidthAnchor.isActive = true
            
        }
    }
    
    private func updateAbilityLabels() {
        abilityLabel.text = "Ability"
        firstAbilityLabel.text = pokemon.abilities.first
        firstAbilityLabel.isHidden = !pokemon.abilities.hasFirst
        secondAbilityLabel.text = pokemon.abilities.second
        secondAbilityLabel.isHidden = !pokemon.abilities.hasSecond
        hiddenAbilityLabel.text = "\(pokemon.abilities.hidden) (H)"
        hiddenAbilityLabel.isHidden = !pokemon.abilities.hasHidden
    }
    
    private func updateDefenseLabel() {
        defenseLabel.text = "Defense"
    }
    
    private func configureConstraints() {
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        pokeImageView.translatesAutoresizingMaskIntoConstraints = false
        primaryTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        abilityLabel.translatesAutoresizingMaskIntoConstraints = false
        firstAbilityLabel.translatesAutoresizingMaskIntoConstraints = false
        secondAbilityLabel.translatesAutoresizingMaskIntoConstraints = false
        hiddenAbilityLabel.translatesAutoresizingMaskIntoConstraints = false
        defenseLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(idLabel)
        contentView.addSubview(pokeImageView)
        contentView.addSubview(primaryTypeLabel)
        contentView.addSubview(secondaryTypeLabel)
        contentView.addSubview(abilityLabel)
        contentView.addSubview(firstAbilityLabel)
        contentView.addSubview(secondAbilityLabel)
        contentView.addSubview(hiddenAbilityLabel)
        contentView.addSubview(defenseLabel)
        
        let spacing: CGFloat = 16
        let margin: CGFloat = 16
        let typeSpacing: CGFloat = 8
        
        // idLabel: use as reference for other labels
        idLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        idLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin).isActive = true
        idLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5, constant: -margin * 2).isActive = true
        idLabel.heightAnchor.constraint(equalToConstant: TypeUILabel.defaultSize.height).isActive = true
        
        // pokeImageView
        pokeImageView.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: spacing).isActive = true
        pokeImageView.bottomAnchor.constraint(equalTo: primaryTypeLabel.topAnchor, constant: -spacing).isActive = true
        pokeImageView.leadingAnchor.constraint(equalTo: idLabel.leadingAnchor).isActive = true
        pokeImageView.trailingAnchor.constraint(equalTo: idLabel.trailingAnchor).isActive = true
        
        // primaryTypeLabel
        primaryTypeLabel.bottomAnchor.constraint(equalTo: secondaryTypeLabel.bottomAnchor).isActive = true
        primaryTypeLabel.heightAnchor.constraint(equalTo: idLabel.heightAnchor).isActive = true
        primaryTypeLabel.leadingAnchor.constraint(equalTo: idLabel.leadingAnchor).isActive = true
        primaryTypeLabelWidthAnchor = primaryTypeLabel.widthAnchor.constraint(equalTo: idLabel.widthAnchor)
        primaryTypeLabelTrailingAnchor = primaryTypeLabel.trailingAnchor.constraint(equalTo: secondaryTypeLabel.leadingAnchor, constant: -typeSpacing)
        
        //secondaryTypeLabel
        secondaryTypeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin).isActive = true
        secondaryTypeLabel.trailingAnchor.constraint(equalTo: idLabel.trailingAnchor).isActive = true
        secondaryTypeLabel.heightAnchor.constraint(equalTo: idLabel.heightAnchor).isActive = true
        secondaryTypeLabel.widthAnchor.constraint(equalTo: idLabel.widthAnchor, multiplier: 0.5, constant: -typeSpacing / 2).isActive = true
        
        // abilityLabel
        abilityLabel.topAnchor.constraint(equalTo: idLabel.topAnchor).isActive = true
        abilityLabel.leadingAnchor.constraint(equalTo: idLabel.trailingAnchor, constant: margin).isActive = true
        abilityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin).isActive = true
        abilityLabel.heightAnchor.constraint(equalTo: idLabel.heightAnchor).isActive = true
        
        // firstAbilityLabel
        firstAbilityLabel.topAnchor.constraint(equalTo: abilityLabel.bottomAnchor, constant: spacing).isActive = true
        firstAbilityLabel.centerXAnchor.constraint(equalTo: abilityLabel.centerXAnchor).isActive = true
        firstAbilityLabel.widthAnchor.constraint(equalTo: abilityLabel.widthAnchor, constant: -spacing * 2).isActive = true
        firstAbilityLabel.heightAnchor.constraint(equalTo: idLabel.heightAnchor).isActive = true
        
        // secondAbilityLabel
        secondAbilityLabel.topAnchor.constraint(equalTo: firstAbilityLabel.bottomAnchor, constant: spacing).isActive = true
        secondAbilityLabel.centerXAnchor.constraint(equalTo: abilityLabel.centerXAnchor).isActive = true
        secondAbilityLabel.widthAnchor.constraint(equalTo: firstAbilityLabel.widthAnchor).isActive = true
        secondAbilityLabel.heightAnchor.constraint(equalTo: idLabel.heightAnchor).isActive = true
        
        // hiddenAbilityLabel
        hiddenAbilityLabel.topAnchor.constraint(equalTo: secondAbilityLabel.bottomAnchor, constant: spacing).isActive = true
        hiddenAbilityLabel.centerXAnchor.constraint(equalTo: abilityLabel.centerXAnchor).isActive = true
        hiddenAbilityLabel.widthAnchor.constraint(equalTo: firstAbilityLabel.widthAnchor).isActive = true
        hiddenAbilityLabel.heightAnchor.constraint(equalTo: idLabel.heightAnchor).isActive = true
        
        // defenseLabel
        defenseLabel.bottomAnchor.constraint(equalTo: primaryTypeLabel.bottomAnchor).isActive = true
        defenseLabel.leadingAnchor.constraint(equalTo: abilityLabel.leadingAnchor).isActive = true
        defenseLabel.trailingAnchor.constraint(equalTo: abilityLabel.trailingAnchor).isActive = true
        defenseLabel.heightAnchor.constraint(equalTo: idLabel.heightAnchor).isActive = true
    }
}
