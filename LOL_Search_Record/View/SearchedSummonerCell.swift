//
//  SearchedSummonerCell.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/24.
//

import UIKit

class SearchedSummonerCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var summonerName: UILabel!
    @IBOutlet weak var tierImage: UIImageView!
    @IBOutlet weak var tierText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
