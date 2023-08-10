//
//  SelectLocationVC.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/19.
//

import UIKit

class SelectLocationVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var locationPicker: UIPickerView!
    
    let locations: [String] = UrlHeadPoint.allCases.map { $0.rawValue.uppercased() }

    
    var urlHeadPoint: UrlHeadPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationPicker.delegate = self
        locationPicker.dataSource = self
    }
    
    
    
    @IBAction func tapSaveBtn(_ sender: Any) {
        
        let changedHeadPoint = urlHeadPoint ?? .kr
        
        print("SelectLocationVC - \(String(describing: changedHeadPoint)) ")
        NotificationCenter.default.post(name: NSNotification.Name("UrlHead"), object: changedHeadPoint)
        
        navigationController?.popToRootViewController(animated: true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locations.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locations[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedLocation = locations[row].lowercased()
//        switch selectedLocation {
//        case "Brazil":
//            urlHeadPoint = .brazil
//        case "EUN":
//            urlHeadPoint = .eun
//        case "EUW":
//            urlHeadPoint = .euw
//        case "JP":
//            urlHeadPoint = .jp
//        case "KR":
//            urlHeadPoint = .kr
//        case "LA1":
//            urlHeadPoint = .la
//        case "LA2":
//            urlHeadPoint = .la2
//        case "OC":
//            urlHeadPoint = .oce
//        case "RU":
//            urlHeadPoint = .ru
//        case "TR":
//            urlHeadPoint = .tr
//        default:
//            urlHeadPoint = .kr
//        }
       urlHeadPoint = UrlHeadPoint(rawValue: selectedLocation)
    }
    
}
