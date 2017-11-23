//
//  SettingsViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 27/09/17.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var scColors: UISegmentedControl!
    @IBOutlet weak var swAutoplay: UISwitch!
    @IBOutlet weak var tfGenre: UITextField!
    
    var pickerView: UIPickerView!
    let genreList = ["Acao","Comedia","Drama","Terror","Suspense","Romance","Ficcao","Adulto", "Infantil"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.dataSource = self
        pickerView.delegate = self
        
        tfGenre.inputView = pickerView
        tfGenre.delegate = self
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        let okButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(okClick))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [cancelButton, spaceButton, okButton]
            
        tfGenre.inputAccessoryView = toolbar
    }
    
    func cancelClick() {
        tfGenre.resignFirstResponder()
    }
    
    func okClick() {
        tfGenre.text = genreList[pickerView.selectedRow(inComponent: 0)]
        
        UserDefaults.standard.set(tfGenre.text!, forKey: "genre")
        
        tfGenre.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scColors.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "color")
        swAutoplay.setOn(UserDefaults.standard.bool(forKey: "autoplay"), animated: false)
        tfGenre.text = UserDefaults.standard.string(forKey: "genre")
    }
    
    @IBAction func changeColor(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "color")
    }
    
    @IBAction func changeAutoplay(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "autoplay")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(tfGenre.text!, forKey: "genre")
    }
    
}

extension SettingsViewController : UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genreList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genreList[row]
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
