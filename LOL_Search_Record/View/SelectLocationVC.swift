//
//  SelectLocationVC.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/19.
//

import UIKit

class SelectLocationVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var locationPicker: UIPickerView!
    
    let locations: [String] = ["Brazil", "EUN", "EUW", "JP", "KR", "LA1", "LA2", "OC", "RU", "TR"]
    
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
        let selectedLocation = locations[row]
        switch selectedLocation {
        case "Brazil":
            urlHeadPoint = .brOne
        case "EUN":
            urlHeadPoint = .eunOne
        case "EUW":
            urlHeadPoint = .euwOne
        case "JP":
            urlHeadPoint = .jpOne
        case "KR":
            urlHeadPoint = .kr
        case "LA1":
            urlHeadPoint = .laOne
        case "LA2":
            urlHeadPoint = .laTwo
        case "OC":
            urlHeadPoint = .ocOne
        case "RU":
            urlHeadPoint = .ru
        case "TR":
            urlHeadPoint = .tr1
        default:
            urlHeadPoint = .kr
        }
    }
    
}
