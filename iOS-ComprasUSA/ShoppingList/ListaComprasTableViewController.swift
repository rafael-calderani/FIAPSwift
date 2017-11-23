//
//  ListaComprasTableViewController.swift
//  ShoppingList
//
//  Created by Rafael dos Santos Calderani on 14/10/17.
//  Copyright © 2017 Rafael dos Santos Calderani. All rights reserved.
//

import UIKit
import CoreData

class ListaComprasTableViewController: UITableViewController {
    // MARK: - Properties
    var fetchedProductsController: NSFetchedResultsController<Product>!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadProducts()
    }
    
    func loadProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedProductsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedProductsController.delegate = self
        do { try fetchedProductsController.performFetch() }
        catch { print(error.localizedDescription) }
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = fetchedProductsController.fetchedObjects?.count ?? 0
        if rows > 0 {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        }
        else {
            let lbZeroRecords: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            lbZeroRecords.text = "Nenhum produto cadastrado."
            lbZeroRecords.textColor = UIColor.black
            lbZeroRecords.textAlignment = .center
            tableView.backgroundView  = lbZeroRecords
            tableView.separatorStyle  = .none
        }

        return rows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCellProduct", for: indexPath) as! ProductTableViewCell

        // Configure the cell
        let product = fetchedProductsController.object(at: indexPath)
        cell.ivProduct.image = product.photo as? UIImage
        cell.lbProduct.text = product.name
        cell.lbState.text = product.state?.name
        cell.lbValue.text = "\(product.value)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = fetchedProductsController.object(at: indexPath)
            context.delete(product)
            do { try context.save() }
            catch { print(error.localizedDescription) }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "productSegue", sender: fetchedProductsController.object(at: indexPath))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CadastrarProdutoViewController {
            if let product = sender as? Product {
                vc.product = product
            }
            else { vc.product = nil }
        }
    }
}


// MARK: - Delegates
extension ListaComprasTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

