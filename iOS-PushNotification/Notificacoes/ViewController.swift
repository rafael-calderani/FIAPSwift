//
//  ViewController.swift
//  Notificacoes
//
//  Created by Usuário Convidado on 11/10/17.
//  Copyright © 2017 Rafael dos Santos Calderani. All rights reserved.
//

import UIKit
import UserNotifications

enum NCategoria:String {
    case lembrete = "Lembrete"
    case aviso = "Aviso"
}

class ViewController: UIViewController {
    @IBOutlet weak var tfMessage: UITextField!
    @IBOutlet weak var dpFireDate: UIDatePicker!
    @IBOutlet weak var lbMessage: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onReceive(notification:)), name: NSNotification.Name(rawValue:"Confirmed"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dpFireDate.minimumDate = Date()
    }
    
    @IBAction func fireNotification(_ sender: UIButton) {
        let content = UNMutableNotificationContent()
        
        content.title = "Notification Title"
        content.subtitle = "Subtitle"
        content.body = tfMessage.text!
        //content.sound = UNNotificationSound(named: "gemidao.caf")
        content.categoryIdentifier = NCategoria.lembrete.rawValue
        
        
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dpFireDate.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: NCategoria.lembrete.rawValue, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func onReceive(notification: Notification) {
        if let message = notification.userInfo?["body"] as? String {
            lbMessage.text = message
        }
    }

    @IBAction func cancelNotifications(_ sender: UIButton) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notifications:[UNNotificationRequest]) in
            for n in notifications {
                if n.identifier == NCategoria.lembrete.rawValue {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [n.identifier])
                }
            }
        }
    }
}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

