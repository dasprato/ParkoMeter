//
//  LocationsViewController.swift
//  ParkingJammer
//
//  Created by Prato Das on 2018-04-06.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit

class LocationsViewController: UIViewController, UISearchBarDelegate {
    
    let cellId = "cellID"
    var arrayOfLocations: [Location]? {
        didSet {
            allTicketsCollectionView.reloadData()
        }
    }
    
    var arrayOfLocationsToShow: [Location]? {
        didSet {
            allTicketsCollectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        allTicketsCollectionView.backgroundColor = .white
        view.addSubview(allTicketsCollectionView)
        
        NSLayoutConstraint.activate([allTicketsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), allTicketsCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), allTicketsCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), allTicketsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)])
        
        allTicketsCollectionView.register(allTicketsCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        allTicketsCollectionView.delegate = self
        allTicketsCollectionView.dataSource = self
        
        
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        arrayOfLocationsToShow = arrayOfLocations
    }
    

    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Editing Over")
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.navigationBar.topItem?.title = "Searching"
        arrayOfLocationsToShow?.removeAll()
        for i in 0..<arrayOfLocations!.count {
            guard let locationName = arrayOfLocations![i].locationName else { return }
            guard let numberOfTickets = arrayOfLocations![i].numberOfTickets else { return }
            if locationName.containsIgnoringCase(searchBar.text!) {
                arrayOfLocationsToShow?.append(Location(locationName: locationName, numberOfTickets: numberOfTickets))
            }
        }
        self.navigationController?.navigationBar.topItem?.title = "Searching..."
        

    }
    var searchBar: UISearchBar = {
        let sb = UISearchBar(frame: CGRect.zero)
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.barStyle = .black
        let textFieldInsideSearchBar = sb.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        sb.keyboardAppearance = .dark
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
        ccv.keyboardDismissMode = .interactive
        ccv.tag = 0
        ccv.isScrollEnabled = true
        ccv.bounces = true
        ccv.alwaysBounceVertical = true
        ccv.backgroundColor = .clear
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
        return CGSize(width: collectionView.frame.width, height: 20)
    }

}



class allTicketsCollectionViewCell: UICollectionViewCell {
    
    var location: Location? {
        didSet {
            label.text = " " + (location?.numberOfTickets)! + " tickets at " + (location?.locationName)!
            if Int(location!.numberOfTickets)! > 40 {
                self.backgroundColor = UIColor.red.withAlphaComponent(0.5)
            } else {
                self.backgroundColor = UIColor.green.withAlphaComponent(0.5)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        label.textColor = .black
        
        NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: topAnchor), label.bottomAnchor.constraint(equalTo: bottomAnchor), label.rightAnchor.constraint(equalTo: rightAnchor), label.leftAnchor.constraint(equalTo: leftAnchor)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var label: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
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
