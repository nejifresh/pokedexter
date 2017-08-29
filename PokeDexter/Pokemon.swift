//
//  Pokemon.swift
//  PokeDexter
//
//  Created by dev thehomes on 17/08/2017.
//  Copyright © 2017 Blueray Systems & Solutions. All rights reserved.
//

import Foundation
import Alamofire
class Pokemon{
    private var _name: String!
    private var _pokeID: Int!
    private var _description: String!
    private var _type: String!
    private var _defense:String!
    private var _height:String!
    private var _weight:String!
    private var _baseAttack:String!
    private var _nextEvolutionTxt:String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId:String!
    private var _nextEvolutionLvl:String!
    private var _pokemonURL: String!
    
    
    var nextEvolutionName:String{
        if _nextEvolutionName == nil{
            _nextEvolutionName = ""
        }
        
        return _nextEvolutionName
    }
    
    var nextEvolutionId:String{
        if _nextEvolutionId == nil{
            _nextEvolutionId = ""
        }
        
        return _nextEvolutionId
    }
    
    var nextEvolutionLvl:String{
        if _nextEvolutionLvl == nil{
            _nextEvolutionLvl = ""
        }
        
        return _nextEvolutionLvl
    }
    
    
    var nextEvolutionTxt:String{
        if _nextEvolutionTxt == nil{
            _nextEvolutionTxt = ""
        }
        
        return _nextEvolutionTxt
    }
    
    var baseAttack:String{
        if _baseAttack == nil{
            _baseAttack = ""
        }
        return _baseAttack
    }
    
    var weight:String{
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    
    var height: String{
        if _height == nil{
            _height = ""
        }
        return _height
    }
    
    var defense:String{
        if _defense == nil{
            _defense = ""
        }
        
        return _defense
    }
    
    var type:String{
        if _type == nil{
            _type = ""
        }
        
        return _type
    }
    
    var description:String{
        
        if _description == nil{
            _description = ""
        }
        return _description
    }
        
    
    var name: String{
        return _name
    }
    
    var pokeID:Int{
        return _pokeID
    }
    
    init(name: String, pokeId: Int) {
        self._name = name
        self._pokeID = pokeId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokeID)/"
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete){
        Alamofire.request(self._pokemonURL).responseJSON { (response) in
           
            
           if let dict = response.result.value as? Dictionary<String, Any>{
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
            
                if let height = dict["height"] as? String{
                self._height = height
                }
            
            if let attack = dict["attack"] as? Int{
                self._baseAttack = "\(attack)"
            }
            
            if let defense = dict["defense"]as? Int{
                self._defense = "\(defense)"
            }
            
            if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0{
                if let name = types[0]["name"]{
                        self._type = name.capitalized
                }
                
                
                if types.count > 1{
                    for x in 1..<types.count{
                        if let name = types[x]["name"]{
                            self._type! += "/\(name.capitalized)"
                        }
                    }
                }
                
                
            } else{
                self._type = ""
            }
            
            if let descArray = dict["descriptions"] as? [Dictionary<String, String>], descArray.count > 0 {
                
                if let url = descArray[0]["resource_uri"]{
                    let descUrl = "\(URL_BASE)\(url)"
                    Alamofire.request(descUrl).responseJSON(completionHandler: { (response) in
                        if let descDict = response.result.value as? Dictionary<String, Any>{
                            
                            if let description = descDict["description"] as? String{
                                let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                self._description = newDescription
                                print(newDescription)
                            }
                            
                        }
                        completed()
                    })
                }
            } else{
                self._description = ""
            }
            
            if let evolutions = dict["evolutions"] as? [Dictionary<String, Any>], evolutions.count > 0{
                if let nextEvo = evolutions[0]["to"] as? String{
                    
                    if nextEvo.range(of: "mega") == nil{
                        self._nextEvolutionName = nextEvo
                        if let uri = evolutions[0]["resource_uri"] as? String{
                            let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                            let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                            
                            self._nextEvolutionId = nextEvoId
                            
                            if let lvlExists = evolutions[0]["level"]{
                               
                                if let lvl = lvlExists as? Int{
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                            }else{
                                 self._nextEvolutionLvl = ""
                            }
                        }
                    }
                }
                print(self.nextEvolutionName)
                print(self.nextEvolutionLvl)
                print(self.nextEvolutionId)
            }
            
            
           //  print(self.weight)
            // print(self.baseAttack)
           //   print(self.height)
            //   print(self.defense)
            
            
            }
             completed()
        }
       
    }
}
