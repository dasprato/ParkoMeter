//
//  LocationsViewController.swift
//  ParkingJammer
//
//  Created by Prato Das on 2018-04-06.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import MapboxGeocoder


class LocationsViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
    let searchBanner = StatusBarNotificationBanner(title: "Searching", style: .success)
    let minimumCharacterReminder = NotificationBanner(title: "At least three characters", subtitle: "For faster searches, enter more characters", style: .info)
    let interfaceInfoBanner = StatusBarNotificationBanner(title: "Danger zones have a background")
    let cellId = "cellID"
    var arrayOfLocations = [Location]()
    var firstSearch = ""
    var secondSearch = ""
    var arrayOfLocationsToShow: [Location]? {
        didSet {
            DispatchQueue.main.async {
                self.allTicketsCollectionView.reloadData()
                if self.searchBanner.isDisplaying {
                    self.searchBanner.dismiss()
                }
            }

            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        allTicketsCollectionView.backgroundColor = .white
        view.addSubview(allTicketsCollectionView)
        
        view.addSubview(allTicketsCollectionView)
        [
            allTicketsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            allTicketsCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            allTicketsCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            allTicketsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { (constraint) in
                constraint.isActive = true
        }
        allTicketsCollectionView.register(allTicketsCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        allTicketsCollectionView.delegate = self
        allTicketsCollectionView.dataSource = self

        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        arrayOfLocationsToShow = arrayOfLocations
        interfaceInfoBanner.show()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchFieldText = searchBar.text!
        if searchFieldText.count > 3 {
            if firstSearch == "" {
                firstSearch = searchFieldText
            } else if firstSearch != "" && secondSearch == "" {
                secondSearch = searchFieldText
            } else {
                firstSearch = secondSearch
                secondSearch = searchFieldText
            }
            if firstSearch != secondSearch {
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        if !self.searchBanner.isDisplaying {
                            self.searchBanner.show()
                        }
                    }
                    self.arrayOfLocationsToShow?.removeAll()
                    for i in 0..<self.arrayOfLocations.count {
                        guard let locationName = self.arrayOfLocations[i].locationName else { return }
                        guard let numberOfTickets = self.arrayOfLocations[i].numberOfTickets else { return }
                        if locationName.containsIgnoringCase(searchFieldText) {
                            self.arrayOfLocationsToShow?.append(Location(locationName: locationName, numberOfTickets: numberOfTickets))
                        }
                    }
                }
            }
        } else {
            minimumCharacterReminder.show()
        }
    }
    
    var searchBar: UISearchBar = {
        let sb = UISearchBar(frame: CGRect.zero)
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.barStyle = .default
        let textFieldInsideSearchBar = sb.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .darkGray
        textFieldInsideSearchBar?.font = UIFont(name: "Avenir", size: 16)
        sb.keyboardAppearance = .light
        sb.placeholder = "Search"
        return sb
    }()
    
    
    
    var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    
    var allTicketsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        layout.sectionHeadersPinToVisibleBounds = true
        let ccv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ccv.translatesAutoresizingMaskIntoConstraints = false
        ccv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        ccv.keyboardDismissMode = .onDrag
        ccv.tag = 0
        ccv.isScrollEnabled = true
        ccv.bounces = true
        ccv.alwaysBounceVertical = true
        ccv.backgroundColor = .clear
        ccv.showsVerticalScrollIndicator = false
        return ccv
    }()
}

extension LocationsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrayOfLocationsToShow?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = allTicketsCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! allTicketsCollectionViewCell
        let location = arrayOfLocationsToShow![indexPath.row]
        cell.location =  location
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }

}



class allTicketsCollectionViewCell: UICollectionViewCell {
    
    var location: Location? {
        didSet {
            
            let numberOfTickets = (location?.numberOfTickets)!
            let attr1 = [ NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: UIFont(name: "Avenir", size: 18) ]
            let AttrNumberOfTickets = NSAttributedString(string: numberOfTickets, attributes: attr1)

            
            let locationName = (location!.locationName)!
            let attr2 = [ NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.font: UIFont(name: "Avenir", size: 18)]
            let AttrLocationName = NSAttributedString(string: locationName, attributes: attr2)
            
            
            let attr3 = [ NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.font: UIFont(name: "Avenir", size: 16)]
            let AttrAt = NSAttributedString(string: " at ", attributes: attr2)
            
            let labelText = NSMutableAttributedString()
            labelText.append(AttrNumberOfTickets)
             labelText.append(AttrAt)
            labelText.append(AttrLocationName)
            
            label.attributedText = labelText
            if let numOfTickets = location!.numberOfTickets {
                let numberOfTickets = Int(numOfTickets)
                if numberOfTickets != nil {
                if numberOfTickets! > 40 {
                    self.backgroundColor = UIColor.red.withAlphaComponent(0.5)
                } else {
                    self.backgroundColor = .white
                }
                }
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        label.textColor = .black
        
        NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: topAnchor), label.bottomAnchor.constraint(equalTo: bottomAnchor), label.rightAnchor.constraint(equalTo: rightAnchor), label.leftAnchor.constraint(equalTo: leftAnchor), label.heightAnchor.constraint(equalTo: heightAnchor)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var label: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Avenir", size: lbl.font.pointSize)
        lbl.textAlignment = .center
        lbl.textColor = .darkGray
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
}


extension String {
    
    func contains(_ find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(_ find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
