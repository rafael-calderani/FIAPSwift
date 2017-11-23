//
//  CadastrarProdutoViewController.swift
//  ShoppingList
//
//  Created by Rafael dos Santos Calderani on 14/10/17.
//  Copyright © 2017 Rafael dos Santos Calderani. All rights reserved.
//

import UIKit
import CoreData

class CadastrarProdutoViewController: UIViewController {
    // MARK: - Properties
    var product:Product?
    var newImage: UIImage!
    var fetchedStatesController: NSFetchedResultsController<State>!
    var states: [State] = [State]()
    var pickerView: UIPickerView!

    
    // MARK: - IBOutlets
    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var ivPhoto: UIImageView!
    @IBOutlet weak var tfProductState: UITextField!
    @IBOutlet weak var tfProductValue: UITextField!
    @IBOutlet weak var swCard: UISwitch!
    @IBOutlet weak var btAddUpdate: UIButton!
    
    // MARK: - Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addProductImage))
        ivPhoto.addGestureRecognizer(tapGesture)
        
        //Carregar States
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        fetchedStatesController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedStatesController.delegate = self
        do {
            try fetchedStatesController.performFetch()
            
            if let fetchedObjects = fetchedStatesController.fetchedObjects {
                self.states = fetchedObjects
            }
            
        } catch {
            print(error.localizedDescription)
        }

        
        
        // Preparando a picker view e seus componetes (toolbar e buttons)
        pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self  // Definindo o delegate
        pickerView.dataSource = self  // Definindo o dataSource
        
        //confirma ou cancela a seleção
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        toolbar.items = [btCancel, btSpace, btDone]
        
        tfProductState.inputView = pickerView
        tfProductState.inputAccessoryView = toolbar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if product == nil { return } // making sure product is not null from this point
        self.title = "Editar Produto"
            
        tfProductName.text = product!.name
        ivPhoto.image = product!.photo as? UIImage
        tfProductState.text = product!.state?.name
        tfProductValue.text = "\(product!.value)"
        swCard.setOn(product!.card, animated: false)
            
        btAddUpdate.setTitle("ATUALIZAR", for: .normal)
    }
    
    // MARK: - IBActions
    
    @IBAction func addState(_ sender: Any) {
        let alertState = UIAlertController(title: "Registro de Estado", message: "Favor preencher o Nome e a Taxa (%) do estado que está incluindo.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertState.addTextField { (t) in t.placeholder = "Nome do Estado" }
        alertState.addTextField { (textField) in
            textField.placeholder = "Taxa (%)"
            textField.keyboardType = .decimalPad
        }
        
        alertState.addAction(UIAlertAction(title: "Salvar", style: .default, handler: {
            a -> Void in
            let tfState = alertState.textFields![0] as UITextField
            let tfTax = alertState.textFields![1] as UITextField
            
            if tfState.text!.isEmpty || !Validation.isNumberInRange(tfTax.text!, 0, 100) {
                //TODO Warn user fields not valid
                
            }
            else {
                let state = State(context: self.context)
                state.name = tfState.text!
                state.tax = Double(tfTax.text!)!
                
                self.states.append(state)
                
                do { try self.context.save() }
                catch { print(error.localizedDescription) }
            }
        }))
        alertState.addAction(cancelAction)
        
        
        self.present(alertState, animated: true, completion: nil)
    }
    
    @IBAction func addOrUpdate(_ sender: Any) {
        let alert = UIAlertController(title: "Registro de Produto", message: "O produto foi salvo com sucesso.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            action in
            if alert.message == "O produto foi salvo com sucesso." {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        
        if validateFields() {
            if product == nil {
                product = Product(context: context)
            }
            
            product!.name = tfProductName.text!
            if newImage != nil {
                product!.photo = newImage
            }
            let stateName = tfProductState.text!
            if let stateIndex = states.index(where: { $0.name == stateName }) {
                product!.state = states[stateIndex]
            }
            product!.value = Double(tfProductValue.text!)! //force unwrapping since the values were already validated
            product!.card = swCard.isOn
            
            do {
                try context.save()
                
            } catch {
                print(error.localizedDescription)
                alert.title = "Ocorreu um Erro"
                alert.message = error.localizedDescription
            }
        }
        else {
            alert.title = "Campos inválidos"
            alert.message = "Favor verificar os campos novamente e preenche-los, não se esqueça de selecionar a imagem."
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK:  Methods
    
    func addProductImage() {
        //Criando o alerta que será apresentado ao usuário
        let alert = UIAlertController(title: "Selecionar foto do produto", message: "De onde você quer escolher o produto?", preferredStyle: .actionSheet)
        
        //Verificamos se o device possui câmera. Se sim, adicionamos a devida UIAlertAction
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    /// Exibe o ImagePicker ao usuário
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    /// Esconde o teclado e não atribui a seleção ao textField
    func cancel() {
        tfProductState.resignFirstResponder()
    }
    
    /// Atribui ao textField a escolha feita no pickerView
    func done() {
        tfProductState.text = states[pickerView.selectedRow(inComponent: 0)].name
        
        cancel()
    }

        
    func validateFields() -> Bool {
        let result = !tfProductName.text!.isEmpty
            && ivPhoto.image != nil
            && !tfProductName.text!.isEmpty
            && !tfProductState.text!.isEmpty
            && Validation.isNumberInRange(tfProductValue.text!, 0, 99999.99)
        return result
    }
}

// MARK: - Delegates
extension CadastrarProdutoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, NSFetchedResultsControllerDelegate {
    
    //O método abaixo nos trará a imagem selecionada pelo usuário em seu tamanho original
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        
        //cria uma versão nova com tamanho correto da imagem escolhida pelo usuário
        let newSize = CGSize(width: 314, height: 179)
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ivPhoto.image = newImage //Atribui a imagem
        
        dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //Retornando o texto recuperado do objeto dataSource, baseado na linha selecionada
        return states[row].name
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count //O total de linhas será o total de itens em nosso dataSource
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetchedStates = fetchedStatesController.fetchedObjects {
            self.states = fetchedStates
        }
    }
}
