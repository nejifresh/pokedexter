//
//  PokeDetailVC.swift
//  PokeDexter
//
//  Created by dev thehomes on 19/08/2017.
//  Copyright © 2017 Blueray Systems & Solutions. All rights reserved.
//

import UIKit

class PokeDetailVC: UIViewController {
    
    var poke:Pokemon!
    
    @IBOutlet weak var pokeId: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet var defenseLbl: UILabel!
    @IBOutlet weak var heightLbL: UILabel!
    @IBOutlet weak var pokeDexLbl: UILabel!
    
    @IBOutlet weak var weightLbL: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!

    @IBOutlet weak var nameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = poke.name.capitalized
        let img = UIImage(named: "\(self.poke.pokeID)")
        self.mainImage.image = img
        self.currentEvoImg.image = img
        
        poke.downloadPokemonDetail {
           
            //what we put here will only be called after network call is complete
            self.updateUI()
        }

        }
    
    func updateUI(){
        attackLbl.text = poke.baseAttack
        defenseLbl.text = poke.defense
       heightLbL.text = poke.height
       weightLbL.text = poke.weight
        pokeId.text = "\(poke.pokeID)"
        typeLbl.text = poke.type
        descriptionLbl.text = poke.description
        
        if poke.nextEvolutionId == ""{
            
            evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
        } else{
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: poke.nextEvolutionId)
            let str = "Next Evolution \(poke.nextEvolutionName) - LVL \(poke.nextEvolutionLvl)"
            evoLbl.text = str
        }
        
        
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
  }
