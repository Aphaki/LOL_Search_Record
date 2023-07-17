//
//  MatchSummaryCell.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/06.
//

import UIKit

class MatchSummaryCell: UITableViewCell {
    
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var champImg: UIImageView!
    
    @IBOutlet weak var spellOne: UIImageView!
    @IBOutlet weak var spellTwo: UIImageView!
    
    @IBOutlet weak var summonerName: UILabel!
    
    @IBOutlet weak var kill: UILabel!
    @IBOutlet weak var death: UILabel!
    @IBOutlet weak var assist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
