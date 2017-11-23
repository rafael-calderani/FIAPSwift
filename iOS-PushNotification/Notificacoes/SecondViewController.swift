//
//  SecondViewController.swift
//  Notificacoes
//
//  Created by Usuário Convidado on 11/10/17.
//  Copyright © 2017 Rafael dos Santos Calderani. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var lbMessage: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onReceive(notification:)), name: NSNotification.Name(rawValue:"Confirmed"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func onReceive(notification: Notification) {
        if let message = notification.object as? String {
            lbMessage.text = message
        }
    }

}
