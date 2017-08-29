//
//  ViewController.swift
//  PokeDexter
//
//  Created by dev thehomes on 17/08/2017.
//  Copyright © 2017 Blueray Systems & Solutions. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    var musicPlayer: AVAudioPlayer!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
   
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done //change search to DONE
        parsePokemonCSV()
        initAudio()
    }
    
    func initAudio(){
        
        let path  = Bundle.main.path(forResource: "pokeloops", ofType: "wav")!
        
        do{
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 //loop continously
            musicPlayer.play()
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV(){
        //ACCESS THE POKEMON FILE
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")
        
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            print (rows)
            
            for row in rows{
                let rowId = Int(row["id"]!)!
                let name = row["identifier"]!
                //create a pokemon unit
                let poke = Pokemon(name: name, pokeId: rowId)
                //append to pokemon array
                pokemon.append(poke)
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
            
            let poke:Pokemon!
            //check if we are filtering via search bar
            if inSearchMode{
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)
            } else{
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)
            }
            
            
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TRIGGER SEGUE
        var poke:Pokemon!
        if inSearchMode{
            poke = filteredPokemon[indexPath.row]
            
        }else{
            poke = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokeDetailVC", sender: poke)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode{
            return filteredPokemon.count
        }
        else{
        return pokemon.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying{
            musicPlayer.pause()
            sender.alpha = 0.2 //make a bit opaque
        }else{
            musicPlayer.play()
            sender.alpha = 1.0 //make visible
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""
        {
            //we are not in search mode
            inSearchMode = false
            collection.reloadData() //just in case of deleted all
            view.endEditing(true) //hide keypad
            
        }else{
            //we are in search mode
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil}) //filter the original 
            collection.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokeDetailVC"{
            if let detailVC = segue.destination as? PokeDetailVC{
                if let poke = sender as? Pokemon{
                    detailVC.poke = poke
                }
            }
    }
    

}
}

