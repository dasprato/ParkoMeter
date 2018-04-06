//
//  ViewController.swift
//  ParkingJammer
//
//  Created by Prato Das on 2018-04-06.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit


struct Location {
    let locationName: String!
    let numberOfTickets: String!
}
class PrimeViewController: UIViewController {

    var arrayOfLocations = [Location]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(fetchAll)
        NSLayoutConstraint.activate([fetchAll.centerYAnchor.constraint(equalTo: view.centerYAnchor), fetchAll.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
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
        lblFetched.text = "sdfsf"
        lblFetched.textColor = .black
        return lblFetched
    }()
    
    @objc func onButtonPressed() {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//            for item in filesArray {
//                var fileName = item["fileName"]
//
//                // Update the text field on the main queue
//                dispatch_async(dispatch_get_main_queue()) {
//                    fileNameExportLabel.stringValue = "Exporting \(fileName).ext"
//                }
//                println("Exporting \(fileName).ext")
//
//                //--code to save the stuff goes here--
//            }
//        }
        
//        DispatchQueue.async(DispatchQueue.global(qos: DispatchQoS.QoSClass.))
        self.navigationController?.navigationBar.topItem?.title = "Fetching..."
        
        
        readFileWithUTF8(withFileName: "LocationWiseTickets")
        self.navigationController?.navigationBar.topItem?.title = "Fetched"
    }

    func readFileWithUTF8(withFileName fileName: String) {
        if arrayOfLocations.count == 0 {
        view.backgroundColor = .white
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
            openVC()
        } else {
            openVC()
        }
    }
    
    func openVC() {
        let vc = LocationsViewController()
        vc.arrayOfLocations = self.arrayOfLocations
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
