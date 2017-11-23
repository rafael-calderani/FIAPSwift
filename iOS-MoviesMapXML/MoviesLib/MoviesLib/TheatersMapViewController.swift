//
//  TheatersMapViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 06/09/17.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit
import MapKit

class TheatersMapViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    var currentElement: String!
    var theater: Theater!
    var theaters: [Theater] = []
    lazy var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        //print(theaters.count)
        super.viewDidLoad()
        mapView.delegate = self
        loadXML()
        requestUserLocationAuthorization()
    }
    
    func requestUserLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            searchBar.delegate = self
            
            //locationManager.desiredAccuracy = kCLLocationAccuracyHundred
            //locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.allowsBackgroundLocationUpdates = false
            locationManager.pausesLocationUpdatesAutomatically = true
            
            switch CLLocationManager.authorizationStatus() {
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Usuario é fmz")
                case .denied:
                    print("Usuario fdp")
                case .notDetermined:
                    print("Deu ruim")
                    locationManager.requestWhenInUseAuthorization()
                case .restricted:
                    print("Mano...to sem acesso ao GPS")
            }
        }
    }
    
    func addTheaters() {
        for t in theaters {
            let coordinate = CLLocationCoordinate2D(latitude: t.latitude, longitude: t.longitude)
            let annotation = TheaterAnnotation(coordinate: coordinate)
            annotation.title = t.name
            annotation.subtitle = t.address
            mapView.addAnnotation(annotation)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func loadXML() {
        if let xmlURL = Bundle.main.url(forResource: "theaters", withExtension: "xml"), let xmlParser = XMLParser(contentsOf: xmlURL) {
            xmlParser.delegate = self
            xmlParser.parse()
        }
    }
}


extension TheatersMapViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        //print("Início:", elementName)
        
        currentElement = elementName
        if elementName == "Theater" {
            theater = Theater()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //        print("Conteúdo:", string)
        
        let content = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if !content.isEmpty {
            switch currentElement {
            case "name":
                theater.name = content
            case "address":
                theater.address = content
            case "latitude":
                theater.latitude = Double(content)!
            case "longitude":
                theater.longitude = Double(content)!
            case "url":
                theater.url = content
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        //print("Fim:", elementName)
        
        if elementName == "Theater" {
            theaters.append(theater)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        addTheaters()
    }
}

extension TheatersMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView!
        
        if annotation is TheaterAnnotation { //modifica apenas as views que sao do tipo especificado
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Theater")
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Theater")
                annotationView.image = UIImage(named: "theaterIcon")
                annotationView.canShowCallout = true
            }
            else {
                annotationView.annotation = annotation
            }
        }
        else {
            //annotationView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: nil)
        }
        
        return annotationView
    }
}

extension TheatersMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // location changed
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        // user moved
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 100, 100)
        mapView.setRegion(region, animated: true)
    }
}

extension TheatersMapViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchBar.text
    }
}
