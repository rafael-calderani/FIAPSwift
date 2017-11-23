//
//  Validation.swift
//  ShoppingList
//
//  Created by Rafael dos Santos Calderani on 15/10/17.
//  Copyright © 2017 Rafael dos Santos Calderani. All rights reserved.

class Validation {    
    static func isNumberInRange(_ text: String, _ minValue:Double, _ maxValue:Double) -> Bool {
        var result = false
        let nbr = Double(text)
        
        if nbr != nil  && nbr! >= minValue && nbr! <= maxValue {
            result = true
        }
        
        return result
    }
}
