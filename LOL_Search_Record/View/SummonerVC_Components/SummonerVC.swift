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
    
    var summonerInfo: DetailSummonerInfo?
    var summonersMatch: [Participant] {
        return self.summonerInfo?.mySummonerMatchInfos ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SummonerVC - viewDidLoad() called")
        self.summaryTable.dataSource = self
        let nib = UINib(nibName: "MatchSummaryCell", bundle: nil)
        summaryTable.register(nib, forCellReuseIdentifier: "MatchSummaryCell")
        
//        self.summaryTable.delegate = self
        loadiconImage()
        loadTierText()
        loadTierImage()
        loadSummonerName()
    }
    
    //MARK: - Receive Data and Draw UI
    func loadiconImage() {
        guard let summonerInfo = summonerInfo else {
            print("SummonerVC - loadiconImage() : summonerInfo is nil")
            return
        }
        let imgName = summonerInfo.icon.intToString()
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
}

extension SummonerVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summonersMatch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let shortInfo = summonersMatch[indexPath.row]
        guard let cell = summaryTable.dequeueReusableCell(withIdentifier: Constants.matchSummaryCell, for: indexPath) as? MatchSummaryCell else { fatalError("Unable to dequeue MatchSummaryCell") }
        // 승,패 레이블
        cell.winLabel.text = shortInfo.win ? "Win" : "Lose"
        cell.winLabel.backgroundColor = shortInfo.win ? .black : .white
        cell.winLabel.textColor = shortInfo.win ? .white : .black
        // 챔피언 이미지
        let championImgUrl = ImageUrlRouter.champion(name: shortInfo.championName).imgUrl
        cell.champImg.loadImage(from: championImgUrl, folderName: "ChampionImgSmall", imgName: shortInfo.championName)
        // 스펠 이미지
        let spell1ImgUrl = ImageUrlRouter.spell(name: DictionaryStore.shared.spellStore[shortInfo.summoner1ID.intToString()]!).imgUrl
        let spell2ImgUrl = ImageUrlRouter.spell(name: DictionaryStore.shared.spellStore[shortInfo.summoner2ID.intToString()]!).imgUrl
        cell.spellOne.loadImage(from: spell1ImgUrl, folderName: "SpellImg", imgName: shortInfo.summoner1ID.intToString())
        cell.spellTwo.loadImage(from: spell2ImgUrl, folderName: "SpellImg", imgName: shortInfo.summoner2ID.intToString())
        // 소환사 이름
        let summonerName = shortInfo.summonerName
        cell.summonerName.text = summonerName
        // KDA
        let kill = shortInfo.kills.intToString()
        let death = shortInfo.deaths.intToString()
        let assist = shortInfo.assists.intToString()
        cell.kill.text = kill
        cell.death.text = death
        cell.assist.text = assist
        
        
        // 아이템 이미지 x7
        let item0 = shortInfo.item0.intToString()
        let item0Url = ImageUrlRouter.item(name: item0).imgUrl
        cell.item0.loadImage(from: item0Url, folderName: "Item", imgName: item0)
        
        let item1 = shortInfo.item1.intToString()
        let item1Url = ImageUrlRouter.item(name: item1).imgUrl
        cell.item1.loadImage(from: item1Url, folderName: "Item", imgName: item1)
        
        let item2 = shortInfo.item2.intToString()
        let item2Url = ImageUrlRouter.item(name: item2).imgUrl
        cell.item2.loadImage(from: item2Url, folderName: "Item", imgName: item2)
        
        let item3 = shortInfo.item3.intToString()
        let item3Url = ImageUrlRouter.item(name: item3).imgUrl
        cell.item3.loadImage(from: item3Url, folderName: "Item", imgName: item3)
        
        let item4 = shortInfo.item4.intToString()
        let item4Url = ImageUrlRouter.item(name: item4).imgUrl
        cell.item4.loadImage(from: item4Url, folderName: "Item", imgName: item4)
        
        let item5 = shortInfo.item5.intToString()
        let item5Url = ImageUrlRouter.item(name: item5).imgUrl
        cell.item5.loadImage(from: item5Url, folderName: "Item", imgName: item5)
        
        let item6 = shortInfo.item6.intToString()
        let item6Url = ImageUrlRouter.item(name: item6).imgUrl
        cell.item6.loadImage(from: item6Url, folderName: "Item", imgName: item6)
        
        return cell
    }
}

//extension SummonerVC: NetworkManagerDelegate {
//    func noIngameError() {
//        
//    }
//    
//    func isLoading() {
//        
//    }
//    
//    func isLoadingSuccess() {
//        
//    }
//    
//    func noSummonerError() {
//        print("SummonerVC - noSummonerError() called")
//        let alert = UIAlertController(title: "소환사 없음", message: "검색한 소환사는 존재하지 않습니다. 다른 소환사 이름을 작성해 주세요.", preferredStyle: .alert)
//        let alertAction = UIAlertAction(title: "확인", style: .cancel) { _ in
//            self.navigationController?.popViewController(animated: true)
//        }
//        alert.addAction(alertAction)
//        present(alert, animated: true)
//    }
//}

//extension SummonerVC: ServiceDelegate {
//    func dataTaskSuccess(returnedData: DetailSummonerInfo) {
//        print("SummonerVC - dataTaskSuccess() called")
//        self.summonerInfo = returnedData
//        loadiconImage()
//        loadTierText()
//        loadTierImage()
//        loadSummonerName()
//        loadingViewHidden()
//    }
//}
