//
//  ViewController.swift
//  Cars
//
//  Created by Eric.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var ivCars: UIImageView!
    
    var car: Car!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        REST.daowloadImage(url: "http://lorempixel.com/400/200/sports/1/") { (image: UIImage?) in
            self.ivCars.image = image
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //TODO: Edit e
        
        if car == nil {return}
        
        tfBrand.text = car.brand
        tfName.text = car.name
        tfPrice.text = "\(car.price)"
        scGasType.selectedSegmentIndex = car.gasType.rawValue
        title = "Atualizando \(car.name)"
        
    }
    
    @IBAction func saveCar(_ sender: UIButton) {
        
        if car == nil {
            let car = Car(brand: tfBrand.text!, name: tfName.text!, price: Double(tfPrice.text!)!, gasType: GasType(rawValue: scGasType.selectedSegmentIndex)!)
            REST.saveCar(car) { (success:Bool) in
                print(success)
            
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        else {
            self.car = Car(brand: tfBrand.text!, name: tfName.text!, price: Double(tfPrice.text!)!, gasType: GasType(rawValue: scGasType.selectedSegmentIndex)!)

            REST.updateCar(car) { (success:Bool) in
                print(success)
                
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}



