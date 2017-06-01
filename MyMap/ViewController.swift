//
//  ViewController.swift
//  MyMap
//
//  Created by 米田 央 on 2017/05/29.
//  Copyright © 2017年 Swift-Yoneda. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,UITextFieldDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    inputText.delegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  @IBAction func pushedChangeButton(_ sender: Any) {
    
    dispMap.mapType = .satellite
    
    var target:CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    
    var randomLat = Double(arc4random_uniform(90))
    var randomLongi = Double(arc4random_uniform(180))
    
    if arc4random_uniform(1) == 0 {
      randomLat = randomLat * -1
    }
    if arc4random_uniform(1) == 0 {
      randomLongi = randomLongi * -1
    }
    
    target.latitude = randomLat
    target.longitude = randomLongi
    
    let strLat: String = String(format: "%.2f", randomLat)
    let strLongi: String = String(format: "%.2f", randomLongi)
    

    inputText.text = strLat + "," + strLongi
    
    
    
    let pin = MKPointAnnotation()
    
    pin.coordinate = target
    
    self.dispMap.addAnnotation(pin)
    
    self.dispMap.region = MKCoordinateRegionMakeWithDistance(target, 50000.0, 50000.0)
  }
  
  
  @IBOutlet weak var inputText: UITextField!

  @IBOutlet weak var dispMap: MKMapView!
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    textField.resignFirstResponder()
    
    let searchKeyword = textField.text
    
    print(searchKeyword ?? "値が入っていません")
    
    let geocoder = CLGeocoder()
    
    geocoder.geocodeAddressString(searchKeyword!, completionHandler: {(placemarks:[CLPlacemark]?,error:Error?)in
      
      if let placemark = placemarks?[0]{
        
        if let targetCoordinate = placemark.location?.coordinate{
          
          print(targetCoordinate)
          
          let pin = MKPointAnnotation()
          
          pin.coordinate = targetCoordinate
          
          pin.title = searchKeyword
          
          self.dispMap.addAnnotation(pin)
          
          self.dispMap.region = MKCoordinateRegionMakeWithDistance(targetCoordinate, 500.0, 500.0)
        }
      }
    })
    
    return true
    
  }

  @IBAction func changeMapButtonAction(_ sender: Any) {
    
    if dispMap.mapType == .standard {
      dispMap.mapType = .satellite
    } else if dispMap.mapType == .satellite {
      dispMap.mapType = .hybrid
    } else if dispMap.mapType == .hybrid {
      dispMap.mapType = .satelliteFlyover
    } else if dispMap.mapType == .satelliteFlyover {
      dispMap.mapType = .hybridFlyover
    } else {
      dispMap.mapType = .standard
    }
    
  }
  
  
  
}

