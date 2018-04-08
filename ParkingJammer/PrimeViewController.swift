//
//  ViewController.swift
//  ParkingJammer
//
//  Created by Prato Das on 2018-04-06.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Firebase
import MapKit
import CoreLocation
import AddressBookUI
import MapboxGeocoder
import Mapbox
import MapboxNavigation

struct Location {
    let locationName: String!
    let numberOfTickets: String!
}
class PrimeViewController: UIViewController, CLLocationManagerDelegate {

    var count = 0
    let fetchingDataBanner = NotificationBanner(title: "Fetching Data", subtitle: "This might take up to 60 seconds", style: BannerStyle.info)
    let reportBanner = StatusBarNotificationBanner(title: "Ticket Reported", style: BannerStyle.success)
    let invalidBanner = StatusBarNotificationBanner(title: "You have already reported your ticket", style: .info)
    var ticketAddress = ""
    let locationManager = CLLocationManager()
    let geocoder = Geocoder.shared
    var arrayOfLocations = [Location]()
    var numberOfTicketsReported = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(onButtonPressed))
        self.navigationItem.setRightBarButton(button, animated: true)
        
        let reportButton = UIBarButtonItem(title: "Report Ticket", style: .plain, target: self, action: #selector(onReportTapped))
        self.navigationItem.setLeftBarButton(reportButton, animated: true)
        
        view.addSubview(interactiveBackgroundMap)
        NSLayoutConstraint.activate([interactiveBackgroundMap.leftAnchor.constraint(equalTo: view.leftAnchor), interactiveBackgroundMap.rightAnchor.constraint(equalTo: view.rightAnchor), interactiveBackgroundMap.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), interactiveBackgroundMap.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        interactiveBackgroundMap.setZoomLevel(17, animated: true)
        self.fetchingDataBanner.duration = 60.0
        self.fetchingDataBanner.autoDismiss = false
        self.reportBanner.autoDismiss = true
        self.invalidBanner.autoDismiss = true
        self.fetchingDataBanner.show()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        interactiveBackgroundMap.setCenter(locValue, animated: true)
        let locationCoorindate = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)

        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            else if placemarks!.count > 0 {
                let pm = placemarks![0]
                let address = ABCreateStringWithAddressDictionary(pm.addressDictionary!, false)
                let arrayOfAddresses = address.components(separatedBy: .newlines)
                let addressToSend = arrayOfAddresses[0]
                self.ticketAddress = addressToSend
            }
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    var interactiveBackgroundMap: NavigationMapView = {
        let mt = NavigationMapView()
        mt.styleURL = MGLStyle.lightStyleURL()
        mt.translatesAutoresizingMaskIntoConstraints = false
        mt.clipsToBounds = true
        mt.isZoomEnabled = true
        mt.isScrollEnabled = true
        mt.showsUserLocation = true
        mt.isPitchEnabled = false
        mt.isUserInteractionEnabled = true
        return mt
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        count = count + 1
        if count < 2 {

            onButtonPressed()
        }
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
    }
    
    var fetchAll: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Fetch All", for: .normal)
        btn.addTarget(self, action: #selector(onButtonPressed), for: .touchUpInside)
        return btn
    }()
    
    var labelFetched: UILabel = {
        let lblFetched = UILabel()
        lblFetched.translatesAutoresizingMaskIntoConstraints = false
        lblFetched.text = ""
        lblFetched.textColor = .black
        return lblFetched
    }()
    
    @objc func onButtonPressed() {
        print("sending")
        let db = Firestore.firestore()
        
        db.collection("TotalOpens").getDocuments { (snapshot, error) in
            if error != nil {
                print("ERROR ENCOUNTERED")
                db.collection("TotalOpens").addDocument(data: ["TotalOpens": 1])
                return
            }
            else {
                snapshot?.documentChanges.forEach({ (document) in
                    var numberOFOpens = document.document.data()["TotalOpens"]! as! Int
                    var intNumber = numberOFOpens + 1
                    db.collection("TotalOpens").document(document.document.documentID).setData(["TotalOpens": intNumber])
                })
            }
        }
        readFileWithUTF8(withFileName: "LocationWiseTickets")
    }
    
    
    var buttonReportTicket: UIButton = {
        let btnRptTicket = UIButton(type: .system)
        btnRptTicket.backgroundColor = .orange
        btnRptTicket.setTitle("REPORT A TICKET", for: .normal)
        btnRptTicket.addTarget(self, action: #selector(onReportTapped), for: .touchUpInside)
        
        return btnRptTicket
    }()
    
    @objc func onReportTapped() {
        if numberOfTicketsReported < 1 {
        ticketAddress = ticketAddress.replacingOccurrences(of: "\\", with: " ", options: NSString.CompareOptions.literal, range: nil)
        
        let db = Firestore.firestore()
        let docRef = db.collection("Locations").document(ticketAddress)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let newNumber = document.data()!["numberOfTickets"] as! Int
                db.collection("Locations").document(document.documentID).setData(["numberOfTickets": newNumber + 1])
                
            } else {
                db.collection("Locations").document(self.ticketAddress).setData(["numberOfTickets": 1])
            }
            self.numberOfTicketsReported = self.numberOfTicketsReported + 1
        }
        
        reportBanner.show()
        } else {
            invalidBanner.show()
            return
        }
    }

    func readFileWithUTF8(withFileName fileName: String) {
        if arrayOfLocations.count == 0 {
        print("Reading: " + "\(fileName)")
        let fielURLProject = Bundle.main.path(forResource: fileName, ofType: "csv")
        var readStringProject = ""
        do {
            readStringProject = try String(contentsOfFile: fielURLProject!, encoding: String.Encoding.utf8)
            
        } catch let error as NSError {
            print("Failed tp read from project")
            print(error)
        }
        var ticketsArray = [String]()
        ticketsArray = readStringProject.components(separatedBy: .newlines)
        for index in 0..<ticketsArray.count {
            ticketsArray[index] = ticketsArray[index].replacingOccurrences(of: "\\", with: "", options: NSString.CompareOptions.literal, range: nil)
            let tempArray = ticketsArray[index].split(separator: ":")
            if tempArray.count > 1 {
                arrayOfLocations.append(Location(locationName: String(tempArray[0]), numberOfTickets: String(tempArray[1].replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil))))
            }
        }
            fetchingDataBanner.dismiss()
            openVC()
        } else {
            fetchingDataBanner.dismiss()
            openVC()
        }
    }
    
    func openVC() {
        let vc = LocationsViewController()
        vc.arrayOfLocations = self.arrayOfLocations
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
