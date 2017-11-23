//
//  Car.swift
//  Cars
//
//  Created by Rafael dos Santos Calderani on 04/10/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import Foundation

enum GasType: Int {
    case flex, alcohol, gasoline
}

class Car {
    var brand: String
    var name: String
    var price: Double
    var gasType: GasType
    var id: String?
    
    init(brand: String, name: String, price: Double, gasType: GasType) {
        self.brand = brand
        self.name = name
        self.price = price
        self.gasType = gasType
    }
}
