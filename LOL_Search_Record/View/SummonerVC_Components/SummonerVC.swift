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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var queueIdInfos: [QueueIDInfo] = []
    var summonerInfo: DetailSummonerInfo?
    var matchInfos: [MatchInfo] {
        return summonerInfo?.matchInfos ?? []
    }
    var summonersMatch: [Participant] {
        return self.summonerInfo?.mySummonerMatchInfos ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        tierText.backgroundColor = UIColor.theme.myYellow
        tierText.layer.cornerRadius = 5
        tierText.clipsToBounds = true
        
        tierImg.backgroundColor = UIColor.theme.pureWhite?.withAlphaComponent(0.7)
        tierImg.layer.cornerRadius = 20
//        tierImg.clipsToBounds
//        tierImg.
        
        // 테이블뷰(데이터소스, 델리겟) + 셀(NIb)
        self.summaryTable.dataSource = self
        self.summaryTable.delegate = self
        let nib = UINib(nibName: "MatchSummaryCell", bundle: nil)
        summaryTable.register(nib, forCellReuseIdentifier: "MatchSummaryCell")
        //큐 사전 불러오기
        loadQueueIdInfo()
        //UI 데이터 입력
        loadiconImage()
        loadTierText()
        loadTierImage()
        loadSummonerName()
    }
    
    func loadQueueIdInfo() {
        guard
            let data = JsonManager.shared.readJsonFile(filename: "queueId", as: [QueueIDInfo].self) else {
            return
        }
        self.queueIdInfos = data
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
        icon.layer.cornerRadius = 20
    }
    func loadTierText() {
        guard let summonerInfo = summonerInfo else { return }
        let tierString = summonerInfo.tier == "provisional" ? "Unranked" : summonerInfo.tier
        let rankString = summonerInfo.rank
        let tierRank = "\(tierString) \(rankString)"
        tierText.text = tierRank
    }
    func loadTierImage() {
        guard let summonerInfo = summonerInfo else { return }
        tierImg.image = UIImage(named: summonerInfo.tier.lowercased())
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
        guard let cell = summaryTable.dequeueReusableCell(withIdentifier: Constants.cellName.matchSummaryCell.rawValue, for: indexPath) as? MatchSummaryCell else { fatalError("Unable to dequeue MatchSummaryCell") }
        // 승,패 레이블
        cell.winLabel.text = shortInfo.win ? "Win" : "Lose"
        cell.winLabel.backgroundColor = shortInfo.win ? UIColor.theme.teamBlue : UIColor.theme.teamRed
        cell.winLabel.textColor = shortInfo.win ? UIColor.theme.win : UIColor.theme.lose
        // 챔피언 이미지
        let championImgUrl = ImageUrlRouter.champion(name: shortInfo.championName).imgUrl
        cell.champImg.loadImage(from: championImgUrl, folderName: Constants.folderName.championImgSmall.rawValue, imgName: shortInfo.championName)
        // 스펠 이미지
        let spell1ImgUrl = ImageUrlRouter.spell(name: DictionaryStore.shared.spellStore[shortInfo.summoner1ID.intToString()] ?? "").imgUrl
        let spell2ImgUrl = ImageUrlRouter.spell(name: DictionaryStore.shared.spellStore[shortInfo.summoner2ID.intToString()] ?? "").imgUrl
        cell.spellOne.loadImage(from: spell1ImgUrl, folderName: Constants.folderName.spellImg.rawValue, imgName: shortInfo.summoner1ID.intToString())
        cell.spellTwo.loadImage(from: spell2ImgUrl, folderName: Constants.folderName.spellImg.rawValue, imgName: shortInfo.summoner2ID.intToString())
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
        cell.item0.loadImage(from: item0Url, folderName: Constants.folderName.item.rawValue, imgName: item0)
        
        let item1 = shortInfo.item1.intToString()
        let item1Url = ImageUrlRouter.item(name: item1).imgUrl
        cell.item1.loadImage(from: item1Url, folderName: Constants.folderName.item.rawValue, imgName: item1)
        
        let item2 = shortInfo.item2.intToString()
        let item2Url = ImageUrlRouter.item(name: item2).imgUrl
        cell.item2.loadImage(from: item2Url, folderName: Constants.folderName.item.rawValue, imgName: item2)
        
        let item3 = shortInfo.item3.intToString()
        let item3Url = ImageUrlRouter.item(name: item3).imgUrl
        cell.item3.loadImage(from: item3Url, folderName: Constants.folderName.item.rawValue, imgName: item3)
        
        let item4 = shortInfo.item4.intToString()
        let item4Url = ImageUrlRouter.item(name: item4).imgUrl
        cell.item4.loadImage(from: item4Url, folderName: Constants.folderName.item.rawValue, imgName: item4)
        
        let item5 = shortInfo.item5.intToString()
        let item5Url = ImageUrlRouter.item(name: item5).imgUrl
        cell.item5.loadImage(from: item5Url, folderName: Constants.folderName.item.rawValue, imgName: item5)
        
        let item6 = shortInfo.item6.intToString()
        let item6Url = ImageUrlRouter.item(name: item6).imgUrl
        cell.item6.loadImage(from: item6Url, folderName: Constants.folderName.item.rawValue, imgName: item6)
        
        // 게임 시간
        let matchInfo = matchInfos[indexPath.row]
        
        let hour = matchInfo.info.gameDuration / 60
        let hourString = hour < 10 ? "0\(hour)" : "\(hour)"
        let minute = matchInfo.info.gameCreation % 60
        let minuteString = minute < 10 ? "0\(minute)" : "\(minute)"
        cell.gameTime.text = "[\(hourString):\(minuteString)]"
        
        // 현재로부터 흐른 시간
        let timeFromNow = matchInfo.info.elapsedTime.unixToMyString()
        cell.timeFromNow.text = timeFromNow
        
        // 게임 타입
        let queueId = matchInfo.info.queueID
        let queueIdInfo = queueIdInfos.first { $0.queueID == queueId }
        let queueDescription = queueIdInfo?.description ?? ""
        cell.gameType.text = queueDescription
        
        return cell
    }
}

extension SummonerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMatchInfo = matchInfos[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let matchDetailVC = storyboard.instantiateViewController(withIdentifier: "MatchDetailVC") as! MatchDetailVC
        matchDetailVC.matchInfo = selectedMatchInfo
        matchDetailVC.summonerInfo = summonerInfo?.summonerInfo
        navigationController?.pushViewController(matchDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//extension SummonerVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        guard let cell = summaryTable.dequeueReusableCell(withIdentifier: Constants.cellName.matchSummaryCell.rawValue, for: indexPath) as? MatchSummaryCell else { fatalError("Unable to dequeue MatchSummaryCell") }
//        // 셀의 높이를 데이터에 따라 동적으로 계산
//        let data = summonersMatch[indexPath.row]
//        let cellHeight = (cell.champImg.image?.size.height ?? 0) + 10// 셀 높이를 계산하는 로직
//        return cellHeight
//    }
//
//    func updateTableViewData() {
//        summaryTable.reloadData()
//        // 스크롤뷰의 높이를 테이블뷰 컨텐츠 크기에 따라 동적으로 업데이트
//        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: summaryTable.contentSize.height)
//    }
//}


