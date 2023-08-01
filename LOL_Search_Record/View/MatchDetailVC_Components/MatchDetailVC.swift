//
//  MatchDetailVC.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/26.
//

import UIKit

class MatchDetailVC: UIViewController {
    
    //승 or 패
    @IBOutlet weak var ResultsLable: UILabel!
    
    
    
    var summonerInfo: SummonerInfo?
    var participant: [Participant] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
