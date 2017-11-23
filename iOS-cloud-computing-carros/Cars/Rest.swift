//
//  Rest.swift
//  Cars
//
//  Created by Rafael dos Santos Calderani on 04/10/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import Foundation
import UIKit
class REST {
    static let basePath = "https://fiapcars.herokuapp.com/cars"
    
    static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        
        config.allowsCellularAccess = true //config para permitir ou nao acesso via 3G
        config.timeoutIntervalForRequest = 45.0
        config.httpMaximumConnectionsPerHost = 5
        config.httpAdditionalHeaders = ["Context-Type": "application/json"]  //define header padrao
        
        return config
    }()
    
    static let session = URLSession(configuration: configuration)
    
    static func loadCars(onComplete: @escaping ([Car]?) -> Void) {
        guard let url = URL(string: basePath) else {
            onComplete(nil)
            return
        }
        
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("deu zica manolo")
                onComplete(nil)
            }
            else {
                guard let response = response as? HTTPURLResponse else {
                    onComplete(nil)
                    return
                }
                if response.statusCode == 200 {
                    guard let data = data else {
                        onComplete(nil)
                        return
                    }
                    
                    do {
                    
                        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! [[String:Any]]
                        
                        var cars: [Car] = []
                        for item in json {
                            let brand = item["brand"] as! String
                            let name = item["name"] as! String
                            let price = item["price"] as! Double
                            let gasType = GasType(rawValue: item["gasType"] as! Int)!
                            let id = item["_id"] as! String
                            
                            let car = Car(brand: brand, name: name, price: price, gasType: gasType)
                            car.id = id
                            
                            cars.append(car)
                        }
                        
                        onComplete(cars)
                    }
                    catch {
                        print("erro")
                        onComplete(nil)
                    }
                }
                else {
                    print("Erro no servidor", response.statusCode)
                    onComplete(nil)
                }
            }
        }
            
        dataTask.resume()
    }
    
    static func existsCar() {
        
    }
    
    static func insertCar() {
        
    }
    
    static func updateCar(_ car: Car, onComplete: @escaping (Bool) -> Void) {
        let path = "\(basePath)/\(car.id!)"
        
        guard let url = URL(string: path) else {
            onComplete(false)
            return
        }
        let carDic: [String:Any] = [
            "brand": car.brand,
            "name": car.name,
            "price": car.price,
            "gasType": car.gasType.rawValue,
            "id": car.id!
        ]
        let json = try! JSONSerialization.data(withJSONObject: carDic, options: JSONSerialization.WritingOptions())
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = json
        
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("deu zica manolo")
                onComplete(false)
            }
            else {
                guard let response = response as? HTTPURLResponse else {
                    onComplete(false)
                    return
                }
                if response.statusCode == 200 {
                    guard let _ = data else {
                        onComplete(false)
                        return
                    }
                    
                    onComplete(true)
                }
                else {
                    print("Erro no servidor", response.statusCode)
                    onComplete(false)
                }
            }
            }.resume()
        
    }
    
    static func saveCar(_ car: Car, onComplete: @escaping (Bool) -> Void) {
        guard let url = URL(string: basePath) else {
            onComplete(false)
            return
        }
        let carDic: [String:Any] = [
            "brand": car.brand,
            "name": car.name,
            "price": car.price,
            "gasType": car.gasType.rawValue
        ]
        let json = try! JSONSerialization.data(withJSONObject: carDic, options: JSONSerialization.WritingOptions())
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = json
        
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("deu zica manolo")
                onComplete(false)
            }
            else {
                guard let response = response as? HTTPURLResponse else {
                    onComplete(false)
                    return
                }
                if response.statusCode == 200 {
                    guard let _ = data else {
                        onComplete(false)
                        return
                    }
                    
                    onComplete(true)
                }
                else {
                    print("Erro no servidor", response.statusCode)
                    onComplete(false)
                }
            }
        }.resume()
    }
    
    static func deleteCar(_ car: Car, onComplete: @escaping (Bool) -> Void) {
        let path = "\(basePath)/\(car.id!)"
        
        guard let url = URL(string: path) else {
            onComplete(false)
            return
        }
        let carDic: [String:Any] = [ "id": car.id! ]
        let json = try! JSONSerialization.data(withJSONObject: carDic, options: JSONSerialization.WritingOptions())
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.httpBody = json
        
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("deu zica manolo")
                onComplete(false)
            }
            else {
                guard let response = response as? HTTPURLResponse else {
                    onComplete(false)
                    return
                }
                if response.statusCode == 200 {
                    guard let _ = data else {
                        onComplete(false)
                        return
                    }
                    
                    onComplete(true)
                }
                else {
                    print("Erro no servidor", response.statusCode)
                    onComplete(false)
                }
            }
            }.resume()
        
    }
    
    static func daowloadImage(url: String, onComplete: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else {
            onComplete(nil)
            return
        }
        session.downloadTask(with: url) { (imageURL: URL?, response: URLResponse?, error: Error?) in
            if let response = response as? HTTPURLResponse, response.statusCode == 200, let imageURL = imageURL {
                let imageData = try! Data(contentsOf: imageURL)
                let image = UIImage(data: imageData)
                onComplete(image)
            }
            else { onComplete(nil) }
        }.resume()
    }
}
