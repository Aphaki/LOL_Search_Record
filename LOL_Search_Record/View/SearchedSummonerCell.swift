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
    
    var delegate: SearchedSummonerCellDelegate?
    var summonerModel: SummonerModel?
    
    @IBAction func pressedXBtn(_ sender: UIButton) {
        guard let aSummonerInfo = summonerModel else { fatalError("SearchedSummonerCell - summonerModel is nil") }
        delegate?.pressedXBtn(summonerModel: aSummonerInfo)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func drawUI() {
        // 프로필 아이콘
        guard let aSummonerInfo = summonerModel else { fatalError("SearchedSummonerCell - summonerModel is nil") }
        let iconCode = aSummonerInfo.iconImgId.intToString()
        let iconURL = ImageUrlRouter.icon(code: iconCode).imgUrl
        iconImage.loadImage(from: iconURL, folderName: Constants.folderName.icon.rawValue, imgName: iconCode)
        
        // 소환사 이름
        let aSummonerName = aSummonerInfo.name
        summonerName.text = aSummonerName
        // 티어 이미지
        let tierImg = aSummonerInfo.tierText
        tierImage.image = UIImage(named: tierImg.lowercased())
        tierImage.backgroundColor = UIColor.theme.pureWhite?.withAlphaComponent(0.7)
        tierImage.layer.cornerRadius = 5
        // 티어 텍스트
        let tierText = "\(aSummonerInfo.tierText) \(aSummonerInfo.rank)"
        self.tierText.text = tierText
    }
    
}

protocol SearchedSummonerCellDelegate {
    func pressedXBtn(summonerModel: SummonerModel)
}
