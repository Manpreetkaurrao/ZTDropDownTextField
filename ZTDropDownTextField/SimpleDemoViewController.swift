//
//  SimpleDemoViewController.swift
//  ZTDropDownTextField
//
//  Created by Ziyang Tan on 8/18/15.
//  Copyright (c) 2015 Ziyang Tan. All rights reserved.
//

import UIKit
import MapKit
import AddressBookUI

class SimpleDemoViewController: UIViewController {
    
    // MARK: Instance Variables
    let geocoder = CLGeocoder()
    let region = CLCircularRegion(center: CLLocationCoordinate2DMake(37.7577, -122.4376), radius: 1000, identifier: "region")
    var placemarkList: [CLPlacemark] = []
    
    // Mark: Outlet
    @IBOutlet weak var fullAddressTextField: ZTDropDownTextField!
    @IBOutlet weak var addressSummaryTextView: UITextView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Simple Demo"
        
        fullAddressTextField.dataSourceDelegate = self
        fullAddressTextField.animationStyle = .Flip
        fullAddressTextField.addTarget(self, action: #selector(fullAddressTextDidChanged(textField:)), for:.editingChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Address Helper Mehtods
    @objc func fullAddressTextDidChanged(textField: UITextField) {
        
        if textField.text!.isEmpty {
            placemarkList.removeAll(keepingCapacity: false)
            fullAddressTextField.dropDownTableView.reloadData()
            return
        }
        
        geocoder.geocodeAddressString(textField.text!, in: region, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                print(error)
            } else {
                self.placemarkList.removeAll(keepingCapacity: false)
                self.placemarkList = placemarks! as [CLPlacemark]
                self.fullAddressTextField.dropDownTableView.reloadData()
            }
        })
    }
    
    private func formateedFullAddress(placemark: CLPlacemark) -> String {
        let lines = ABCreateStringWithAddressDictionary(placemark.addressDictionary!, false)
        let addressString = lines.replacingOccurrences(of: "\n", with: ", ", options: .literal, range: nil)
            
//            lines.stringByReplacingOccurrencesOfString("\n", withString: ", ", options: .LiteralSearch, range: nil)
        return addressString
    }
    
}

extension SimpleDemoViewController: ZTDropDownTextFieldDataSourceDelegate {
    func dropDownTextField(dropDownTextField: ZTDropDownTextField, numberOfRowsInSection section: Int) -> Int {
        return placemarkList.count
    }
    
    func dropDownTextField(dropDownTextField: ZTDropDownTextField, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cell = dropDownTextField.dropDownTableView.dequeueReusableCell(withIdentifier: "addressCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "addressCell")
        }
        
        cell!.textLabel!.text = formateedFullAddress(placemark: placemarkList[indexPath.row])
        cell!.textLabel?.numberOfLines = 0
        
        return cell!
    }
    
    func dropDownTextField(dropDownTextField dropdownTextField: ZTDropDownTextField, didSelectRowAtIndexPath indexPath: IndexPath) {
        fullAddressTextField.text = formateedFullAddress(placemark: placemarkList[indexPath.row])
        addressSummaryTextView.text = formateedFullAddress(placemark: placemarkList[indexPath.row])
    }
}
