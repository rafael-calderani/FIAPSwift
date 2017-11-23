//
//  CarsTableViewController.swift
//  Cars
//
//  Created by Eric.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit

class CarsTableViewController: UITableViewController {
    var cars:[Car] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        REST.loadCars(onComplete: onComplete)
    }
    
    func onComplete(cars:[Car]?) -> Void {
        self.cars = (cars == nil) ? [] : cars!
        
        DispatchQueue.main.async { // executa esse trecho na main thread pois toda atualizacao de UI deve ser feita na main
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            let vc = segue.destination as! ViewController
            vc.car = cars[tableView.indexPathForSelectedRow!.row]
        }
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let car = cars[indexPath.row]
        
        cell.textLabel?.text = car.name
        cell.detailTextLabel?.text = "R$ \(car.price)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let car = cars[indexPath.row]
            REST.deleteCar(car, onComplete: { (success:Bool) in
                if success {
                    self.cars.remove(at: indexPath.row)
                    
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                    }
                }
            })
        }
    }

}





