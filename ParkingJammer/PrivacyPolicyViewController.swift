//
//  PrivacyPolicyViewController.swift
//  ParkingJammer
//
//  Created by Prato Das on 2018-04-11.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(label)
        NSLayoutConstraint.activate([label.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), label.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), label.bottomAnchor.constraint(equalTo: view.bottomAnchor), label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)])
        
        self.navigationController?.navigationBar.topItem?.title = "ParkoMeter Privacy Policy"
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
        self.navigationItem.setLeftBarButtonItems([closeButton], animated: true)
        
    }

    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var label: UITextView = {
        let lbl = UITextView()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .gray
        lbl.text = "This privacy policy has been compiled to better serve those who are concerned with how their 'Personally Identifiable Information' (PII) is being used online. PII, as described in US privacy law and information security, is information that can be used on its own or with other information to identify, contact, or locate a single person, or to identify an individual in context. Please read our privacy policy carefully to get a clear understanding of how we collect, use, protect or otherwise handle your Personally Identifiable Information in accordance with our app." + "\n" +
        
        "What personal information do we collect from the people that visit our app?" + "\n" +
        
        "We only collect your location (latitude and longitude). No sign up procedure is involved which ensures users never enter any personal information like email, name and passwords." + "\n" +
        
        "When do we collect information?" + "\n" +
        
        "We collect your location (latitude and longitude) only when you report a parking ticket in the app." + "\n" +
        
        "How do we use your information?" + "\n" +
        
        "We may use the information we collect from you when you report a ticket to improve our analysis of safe and danger zones." + "\n" +
        
        "What happens if my location cannot be accessed?" + "\n" +
        
        "The app might not function properly as vital information will be missing. We cannot add null values to our database. Sorry." + "\n" +
        
        
        "Third-party disclosure" + "\n" +
        
        "We do not sell, trade, or otherwise transfer to outside parties your Personally Identifiable Information unless we provide users with advance notice. This does not include website hosting partners and other parties who assist us in operating our website, conducting our business, or serving our users, so long as those parties agree to keep this information confidential. We may also release information when it's release is appropriate to comply with the law, enforce our site policies, or protect ours or others' rights, property or safety." + "\n" +
        
        "However, non-personally identifiable visitor information may be provided to other parties for marketing, advertising, or other uses." + "\n" +
        
        "Third-party links" + "\n" +
        
        "We do not include or offer third-party products or services on our website." + "\n" +
        
        "Google " + "\n" +
        
        "Google's advertising requirements can be summed up by Google's Advertising Principles. They are put in place to provide a positive experience for users. https://support.google.com/adwordspolicy/answer/1316548?hl=en" + "\n" +
        
        "We have not enabled Google AdSense on our site but we may do so in the future." + "\n" +
        
        "COPPA (Children Online Privacy Protection Act)" + "\n" +
        
        "When it comes to the collection of personal information from children under the age of 13 years old, the Children's Online Privacy Protection Act (COPPA) puts parents in control. The Federal Trade Commission, United States' consumer protection agency, enforces the COPPA Rule, which spells out what operators of websites and online services must do to protect children's privacy and safety online." + "\n" +
        
        "We do not specifically market to children under the age of 13 years old." + "\n" +
        "Do we let third-parties, including ad networks or plug-ins collect PII from children under 13?" + "\n" +
        
        "Fair Information Practices" + "\n" +
        
        "The Fair Information Practices Principles form the backbone of privacy law in the United States and the concepts they include have played a significant role in the development of data protection laws around the globe. Understanding the Fair Information Practice Principles and how they should be implemented is critical to comply with the various privacy laws that protect personal information." + "\n" +
        
        "In order to be in line with Fair Information Practices we will take the following responsive action, should a data breach occur:" + "\n" +
        "• Within 1 business day" + "\n" +
        "We will notify the users via in-app notification" + "\n" +
        "• Within 1 business day" + "\n" +
        
        "We also agree to the Individual Redress Principle which requires that individuals have the right to legally pursue enforceable rights against data collectors and processors who fail to adhere to the law. This principle requires not only that individuals have enforceable rights against data users, but also that individuals have recourse to courts or government agencies to investigate and/or prosecute non-compliance by data processors." + "\n"
        return lbl
    }()

}
