//
//  SecondViewController.swift
//  MyPlaces
//
//  Created by user143153 on 22/9/18.
//  Copyright © 2018 UOC. All rights reserved.
//

import UIKit
import MapKit
import Foundation


class SecondViewController: UIViewController, MKMapViewDelegate, ManagerPlacesObserver  {
   
    
    @IBOutlet weak var m_map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Añadirnos como observador del ManagerPlaces.
         ManagerPlaces.shared().addObserver(object:self)
        // Cargar los makers por primera vez
        addMakers()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeMakers() {
        let lista = self.m_map.annotations.filter {!($0 is MKUserLocation)}
        self.m_map.removeAnnotations(lista)
    }

    func addMakers() {
        let provider:ManagerPlaces = ManagerPlaces.shared()
        
        for i in 0..<provider.getCount() {
            
            let p = provider.getItemAt(position: i)
            
            if (p.location != nil) {
            
                let title:String = p.name
                let id:String = p.id
                let lat:Double = p.location.latitude
                let lon:Double = p.location.longitude
                let annotation:MKMyPointAnnotation = MKMyPointAnnotation(coordinate:
                CLLocationCoordinate2D(latitude: lat,longitude: lon),title: title,place_id: id)
                self.m_map.addAnnotation(annotation)
            
            }		
        }
    }
    
    // Para el protocolo MKMapViewDelegate.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? MKMyPointAnnotation
        {
            let identifier = "CustomPinAnnotationView"
            var pinView: MKPinAnnotationView
            if let dequeuedView =
                self.m_map?.dequeueReusableAnnotationView(withIdentifier: identifier)
                    as? MKPinAnnotationView {
                        dequeuedView.annotation = annotation
                        pinView = dequeuedView
                } else {
                    pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    pinView.canShowCallout = true
                    pinView.calloutOffset = CGPoint(x: -5, y: 5)
                    pinView.rightCalloutAccessoryView = UIButton(type:.detailDisclosure) as UIView
                    pinView.setSelected(true,animated: true)
                }
              return pinView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        // Annotation has the place Id.
        let annotation:MKMyPointAnnotation = annotationView.annotation as! MKMyPointAnnotation
    
        // Implement. Accedemos al Manager Places y obtenemos el place Id.
        let wplace = ManagerPlaces.shared().getItemById(_id: annotation.place_id)
        
        // Instanciamos el DetailController y le asignamos el place. 
        let dc:DetailController = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "DetailController") as! DetailController
        dc.place = wplace
        
        // Presentacmos el elemento
        present(dc, animated: true, completion: nil)
        
    }
    
    func onPlacesChange() {
        removeMakers()
        addMakers()
    }
}

