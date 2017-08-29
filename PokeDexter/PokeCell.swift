//
//  PokeCell.swift
//  PokeDexter
//
//  Created by dev thehomes on 17/08/2017.
//  Copyright © 2017 Blueray Systems & Solutions. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbNail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    
    func configureCell(_ pokemon:Pokemon){
        self.pokemon = pokemon
        nameLabel.text = self.pokemon.name.capitalized
        thumbNail.image = UIImage(named: "\(self.pokemon.pokeID)")
    }
    
}
