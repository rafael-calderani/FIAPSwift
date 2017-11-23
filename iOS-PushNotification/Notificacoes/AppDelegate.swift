//
//  AppDelegate.swift
//  Notificacoes
//
//  Created by Usuário Convidado on 11/10/17.
//  Copyright © 2017 Rafael dos Santos Calderani. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var center = UNUserNotificationCenter.current()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        center.delegate = self
        center.getNotificationSettings { (settings: UNNotificationSettings) in
            switch settings.authorizationStatus {
            case .notDetermined:
                let options: UNAuthorizationOptions = [.alert, .sound, .badge, .carPlay]
                
                self.center.requestAuthorization(options: options, completionHandler: { (success: Bool, error:Error?) in
                    if error == nil {
                        print(success)
                    }
                    else {
                        print(error!.localizedDescription)
                    }
                })
            case .denied:
                print("Porra mano...")
            case .authorized:
                    print("Valeu Jao.")
                    break
            }
        }
        
        let confirmAction = UNNotificationAction(identifier: "Confirm", title: "Confirmar", options: [.foreground])
        let cancelAction = UNNotificationAction(identifier: "Cancel", title: "Cancelar", options: [])
        let category = UNNotificationCategory(identifier: NCategoria.lembrete.rawValue, actions: [confirmAction, cancelAction], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
extension AppDelegate:UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print(">> didReceive")
        
        print(response.notification.request.content.body) //Temos acesso a todo o conteudo
        
        switch response.actionIdentifier {
        case "Confirm":
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Confirmed"), object: response.notification.request.content.title, userInfo: [
                "title" : response.notification.request.content.title,
                "subtile" : response.notification.request.content.subtitle,
                "body" : response.notification.request.content.body])
            
            print("Ze biscoito confirmou.")
        case "Cancel":
            print("Ze biscoito cancelou.")
        case UNNotificationDefaultActionIdentifier:
            print("outra acao")
        case UNNotificationDefaultActionIdentifier:
            print("deu dismiss (nego cagou pra notificacao.)")
        default:
            break
        }
        
        completionHandler()
    }
    
    /// Chamado qdo usuario esta com o app aberto
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print(">> willPresent")
        completionHandler([.alert, .sound])
    }
}

