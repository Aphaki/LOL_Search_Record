//
//  SummonerVC.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/12.
//

import UIKit

class SummonerVC: UIViewController {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var tierText: UILabel!
    @IBOutlet weak var tierImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var summaryTable: UITableView!
    
    @IBOutlet weak var loadingView: UIView!
    
    var summonerInfo: DetailSummonerInfo?
    var summonersMatch: [Participant] {
        return self.summonerInfo?.mySummonerMatchInfos ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Receive Data and Draw UI
    func loadiconImage() {
        guard let summonerInfo = summonerInfo else {
            print("SummonerVC - loadiconImage() : summonerInfo is nil")
            return
        }
        let imgName = summonerInfo.icon.iconIntToString()
        let urlString = imgName.toProfileiconUrl()
        
        icon.loadImage(from: urlString, folderName: "profileicon", imgName: imgName)
    }
    func loadTierText() {
        guard let summonerInfo = summonerInfo else { return }
        let rankString = summonerInfo.rank
        tierText.text = rankString
    }
    func loadTierImage() {
        guard let summonerInfo = summonerInfo else { return }
        tierImg.image = UIImage(named: summonerInfo.tier)
    }
    func loadSummonerName() {
        guard let summonerInfo = summonerInfo else { return }
        let receivedName = summonerInfo.summonerName
        name.text = receivedName
    }
    func loadingViewHidden() {
        loadingView.isHidden = true
    }
}

extension SummonerVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summonersMatch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let detail = summonersMatch[indexPath.row]
        let cell = summaryTable.dequeueReusableCell(withIdentifier: "MatchSummaryCell", for: indexPath) as! MatchSummaryCell
        // 승,패 레이블
        cell.winLabel.text = detail.win ? "Win" : "Lose"
        cell.winLabel.backgroundColor = detail.win ? .black : .white
        cell.winLabel.textColor = detail.win ? .white : .black
        // 챔피언 이미지
        let championImgUrl = ImageUrlRouter.champion(name: detail.championName).imgUrl
        cell.champImg.loadImage(from: championImgUrl, folderName: "ChampionImgSmall", imgName: detail.championName)
        // 스펠 이미지
        let spell1ImgUrl = ImageUrlRouter.spell(name: DictionaryStore.shared.spellStore[detail.summoner1ID.formatted()]!).imgUrl
        let spell2ImgUrl = ImageUrlRouter.spell(name: DictionaryStore.shared.spellStore[detail.summoner2ID.formatted()]!).imgUrl
        cell.spellOne.loadImage(from: spell1ImgUrl, folderName: "SpellImg", imgName: detail.summoner1ID.formatted())
        cell.spellTwo.loadImage(from: spell2ImgUrl, folderName: "SpellImg", imgName: detail.summoner2ID.formatted())
        // 소환사 이름
        let summonerName = detail.summonerName
        cell.summonerName.text = summonerName
        // KDA
        let kill = detail.kills.formatted()
        let death = detail.deaths.formatted()
        let assist = detail.assists.formatted()
        cell.kill.text = kill
        cell.death.text = death
        cell.assist.text = assist
        
        
        // 아이템 이미지 x7
        let item0 = detail.item0.formatted()
        let item0Url = ImageUrlRouter.item(name: item0).imgUrl
        cell.item0.loadImage(from: item0Url, folderName: "Item", imgName: item0)
        
        let item1 = detail.item1.formatted()
        let item1Url = ImageUrlRouter.item(name: item1).imgUrl
        cell.item1.loadImage(from: item1Url, folderName: "Item", imgName: item1)
        
        let item2 = detail.item2.formatted()
        let item2Url = ImageUrlRouter.item(name: item2).imgUrl
        cell.item2.loadImage(from: item2Url, folderName: "Item", imgName: item2)
        
        let item3 = detail.item3.formatted()
        let item3Url = ImageUrlRouter.item(name: item3).imgUrl
        cell.item3.loadImage(from: item3Url, folderName: "Item", imgName: item3)
        
        let item4 = detail.item4.formatted()
        let item4Url = ImageUrlRouter.item(name: item4).imgUrl
        cell.item4.loadImage(from: item4Url, folderName: "Item", imgName: item4)
        
        let item5 = detail.item5.formatted()
        let item5Url = ImageUrlRouter.item(name: item5).imgUrl
        cell.item5.loadImage(from: item5Url, folderName: "Item", imgName: item5)
        
        let item6 = detail.item6.formatted()
        let item6Url = ImageUrlRouter.item(name: item6).imgUrl
        cell.item6.loadImage(from: item6Url, folderName: "Item", imgName: item6)
        
        return cell
    }
}
