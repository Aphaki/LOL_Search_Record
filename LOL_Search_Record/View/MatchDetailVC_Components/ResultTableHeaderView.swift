//
//  ResultView.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/08/05.
//

import UIKit

class ResultTableHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var teamKills: UILabel!
    @IBOutlet weak var teamDeaths: UILabel!
    @IBOutlet weak var teamAssist: UILabel!
    
    @IBOutlet weak var teamDragon: UILabel!
    @IBOutlet weak var teambarron: UILabel!
    @IBOutlet weak var teamTower: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.teamDeaths.textColor = .red
    }
}
