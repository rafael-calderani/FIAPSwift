//
//  ViewController.swift
//  ShoppingList
//
//  Created by Rafael dos Santos Calderani on 11/10/17.
//  Copyright © 2017 Rafael dos Santos Calderani. All rights reserved.
//

import UIKit
import CoreData

class AjustesViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var cotacaoUSD: UITextField!
    @IBOutlet weak var iof: UITextField!
    @IBOutlet weak var tvStates: UITableView!
    
    // MARK: - Properties
    var fetchedStatesController: NSFetchedResultsController<State>!
    
    // MARK: - Overriden Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvStates.delegate = self
        tvStates.dataSource = self
        
        //Load the states
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedStatesController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedStatesController.delegate = self
        do { try fetchedStatesController.performFetch() }
        catch { print(error.localizedDescription) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cotacaoUSD.text = UserDefaults.standard.string(forKey: "CotacaoUSD")
        iof.text = UserDefaults.standard.string(forKey: "IOF")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UserDefaults.standard.set(cotacaoUSD.text!, forKey: "CotacaoUSD")
        UserDefaults.standard.set(iof.text!, forKey: "IOF")
    }
    
    // MARK: - IBActions
    @IBAction func addState(_ sender: Any) {
        showUIAlert(nil)
    }
    
    
    // MARK: - Functions
    func showUIAlert(_ state:State?) {
        let alertState = UIAlertController(title: "Registro de Estado", message: "Favor preencher o Nome e a Taxa (%) do estado que está incluindo.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertState.addTextField { (t) in
            t.placeholder = "Nome do Estado"
            t.text = state?.name
        }
        alertState.addTextField { (t) in
            t.placeholder = "Taxa (%)"
            t.keyboardType = .decimalPad
            t.text = (state == nil) ? "" : "\(state!.tax)"
        }
        
        alertState.addAction(UIAlertAction(title: "Salvar", style: .default, handler: {
            a -> Void in
            let tfState = alertState.textFields![0] as UITextField
            let tfTax = alertState.textFields![1] as UITextField
            
            if tfState.text!.isEmpty || !Validation.isNumberInRange(tfTax.text!, 0, 100) {
                //TODO Warn user fields not valid
            }
            else {
                let stateToSave = state ?? State(context: self.context)
                
                stateToSave.name = tfState.text!
                stateToSave.tax = Double(tfTax.text!)!
                
                do {
                    try self.context.save()
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }))
        alertState.addAction(cancelAction)
        
        self.present(alertState, animated: true, completion: nil)
    }
}

extension AjustesViewController: UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = fetchedStatesController.fetchedObjects?.count ?? 0
        if rows == 0 { // set up Zero Records
            let lbZeroRecords: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            lbZeroRecords.text = "Nenhum estado cadastrado."
            lbZeroRecords.textColor = UIColor.black
            lbZeroRecords.textAlignment = .center
            tableView.backgroundView  = lbZeroRecords
            tableView.separatorStyle  = .none
        }
        else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        }
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCellState", for: indexPath)
        
        let state = fetchedStatesController.object(at: indexPath)
        cell.textLabel?.text = state.name
        cell.detailTextLabel?.text = "\(state.tax)"
        cell.detailTextLabel?.textColor = UIColor.blue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Show UIAlert to Edit the selected State
        let state = fetchedStatesController.object(at: indexPath)
        showUIAlert(state)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let state = fetchedStatesController.object(at: indexPath)
            context.delete(state)
            do { try context.save() }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tvStates.reloadData()
    }
}

