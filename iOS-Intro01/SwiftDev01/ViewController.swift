//
//  ViewController.swift
//  SwiftDev01
//
//  Created by Usuário Convidado on 28/08/17.
//  Copyright © 2017 No Organization. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var ivAvatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ivAvatar.image = UIImage(named: "worldmap")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfName {
            tfEmail.becomeFirstResponder()
        }
        else if textField == tfEmail {
            tfPassword.becomeFirstResponder()
        }
        else {
            doSignUp()
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        var result = true
        if (textField == tfEmail) {
            result = validateEmail(email: textField.text!)
        }
        
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func validateEmail(email: String) -> Bool {
        return false
    }

    @IBAction func doSignUp() {
        print("Fazendo o cadastro")
        view.endEditing(true)
    }
}
