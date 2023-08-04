//
//  TeamMemberSummaryCell.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/08/03.
//

import UIKit

class TeamMemberSummaryCell: UITableViewCell {
    
    @IBOutlet weak var champImg: UIImageView!
    @IBOutlet weak var spell1: UIImageView!
    @IBOutlet weak var spell2: UIImageView!
    
    @IBOutlet weak var summonerName: UILabel!
    @IBOutlet weak var kill: UILabel!
    @IBOutlet weak var death: UILabel!
    @IBOutlet weak var assist: UILabel!
    
    @IBOutlet weak var item1: UIImageView!
    @IBOutlet weak var item2: UIImageView!
    @IBOutlet weak var item3: UIImageView!
    @IBOutlet weak var item4: UIImageView!
    @IBOutlet weak var item5: UIImageView!
    @IBOutlet weak var item6: UIImageView!
    @IBOutlet weak var item7: UIImageView!
    
    @IBOutlet weak var damageBar: UIProgressView!
    @IBOutlet weak var damageText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
