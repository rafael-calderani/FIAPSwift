//
//  GastosTotaisViewController.swift
//  ShoppingList
//
//  Created by Rafael dos Santos Calderani on 16/10/17.
//  Copyright © 2017 Rafael dos Santos Calderani. All rights reserved.
//

import UIKit
import CoreData

class GastosTotaisViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var lbTotalUSD: UILabel!
    @IBOutlet weak var lbTotalBRL: UILabel!
    
    //MARK: - Properties
    var fetchedProductsController: NSFetchedResultsController<Product>!
    
    // MARK: - Overriden Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial values
        lbTotalUSD.text = String(format: "%.2f", 0)
        lbTotalBRL.text = String(format: "%.2f", 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "value", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedProductsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedProductsController.delegate = self
        do {
            try fetchedProductsController.performFetch()
            calcularTotal()
        }
        catch { print(error.localizedDescription) }
    }
    
    //MARK: - Functions
    func calcularTotal() {
        if let products = fetchedProductsController.fetchedObjects {
            let cotacaoUSD = UserDefaults.standard.double(forKey: "CotacaoUSD")
            let iof = UserDefaults.standard.double(forKey: "IOF")
            
            var totalUSD = 0.0
            var totalBRL = 0.0
            
            let cFormatter = NumberFormatter()
            cFormatter.numberStyle = .decimal
            for product in products {
                totalUSD += product.value
                totalBRL += product.value * cotacaoUSD * product.state!.tax * (product.card ? iof : 1.0)
            }
            
            if let formattedUSDTotal = cFormatter.string(from: totalUSD as NSNumber) {
                lbTotalUSD.text = formattedUSDTotal
            }
            if let formattedBRLTotal = cFormatter.string(from: totalBRL as NSNumber) {
                lbTotalBRL.text = formattedBRLTotal
            }
        }
    }
}


extension GastosTotaisViewController : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
}
