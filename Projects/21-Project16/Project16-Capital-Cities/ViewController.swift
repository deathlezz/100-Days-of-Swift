//
//  ViewController.swift
//  Project16-Capital-Cities
//
//  Created by deathlezz on 07/09/2022.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    let mapTypes = ["Standard": MKMapType.standard, "Satellite": MKMapType.satellite, "Hybrid": MKMapType.hybrid]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map", style: .plain, target: self, action: #selector(buttonTapped))
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olimpics.", url: "https://en.wikipedia.org/wiki/London")
        
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "It was founded over a 1000 years ago.", url: "https://en.wikipedia.org/wiki/Oslo")
        
        let paris =  Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.", url: "https://en.wikipedia.org/wiki/Paris")
        
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.", url: "https://en.wikipedia.org/wiki/Rome")
        
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.", url: "https://en.wikipedia.org/wiki/https://en.wikipedia.org/wiki/Washington,_D.C.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true

            // challenge 1
            if let pinView = annotationView as? MKPinAnnotationView {
                pinView.pinTintColor = .green
            }

            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
            
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Wikipedia", style: .default) { [weak self] _ in
            self?.openPage(capital.url)
        })
        
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // challenge 2
    @objc func buttonTapped() {
        let ac = UIAlertController(title: "Change map type", message: nil, preferredStyle: .actionSheet)
        
        for mapType in mapTypes.keys.sorted(by: >) {
            ac.addAction(UIAlertAction(title: mapType, style: .default, handler: mapTypeSelected))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func mapTypeSelected(action: UIAlertAction) {
        guard let title = action.title else { return }
        
        if let type = mapTypes[title] {
            mapView.mapType = type
        }
    }
    
    // challenge 3
    func openPage(_ url: String) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? WebViewController {
            vc.website = url
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

