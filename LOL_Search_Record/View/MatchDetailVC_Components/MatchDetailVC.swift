//
//  MatchDetailVC.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/26.
//

import UIKit

class MatchDetailVC: UIViewController {
    let service = Service()
    //MARK: - IBOutlet property
    //승 or 패
    @IBOutlet weak var resultsLable: UILabel!
    @IBOutlet weak var teamTableA: UITableView!
    @IBOutlet weak var teamTableB: UITableView!
    
    @IBOutlet weak var blueTeamResult: UILabel!
    @IBOutlet weak var blueTeamKill: UILabel!
    @IBOutlet weak var blueTeamDeath: UILabel!
    @IBOutlet weak var blueTeamAssist: UILabel!
    @IBOutlet weak var blueTeamDragon: UILabel!
    @IBOutlet weak var blueTeamBarron: UILabel!
    @IBOutlet weak var blueTeamTower: UILabel!
    
    @IBOutlet weak var redTeamResult: UILabel!
    @IBOutlet weak var redTeamKill: UILabel!
    @IBOutlet weak var redTeamDeath: UILabel!
    @IBOutlet weak var redTeamAssist: UILabel!
    @IBOutlet weak var redTeamDragon: UILabel!
    @IBOutlet weak var redTeamBarron: UILabel!
    @IBOutlet weak var redTeamTower: UILabel!
    
    
    //MARK: - Recieved Property
    // 매치 정보 표기
    var matchInfo: MatchInfo?
    // 해당 플레이어 표기
    var summonerInfo: SummonerInfo?
    
    //MARK: - Set Property
    // 위 두 데이터로부터 나온 데이터(A,B Team Info 채울 데이터)
    // TeamID (100 -> Blue), (200 -> Red)
    var blueTeamMember: [Participant] = []
    var redTeamMember: [Participant] = []
    var mostDamage: Int?
    var winTeamId: Int?
    var summonerWinBool: Bool?
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTeamMember()
        settingMostDamage()
        settingWinTeamId()
        settingSummonerWinBool()
        
        self.teamTableA.dataSource = self
        self.teamTableB.dataSource = self
        let nib = UINib(nibName: "TeamMemberSummaryCell", bundle: nil)
        teamTableA.register(nib, forCellReuseIdentifier: "TeamMemberSummaryCell")
        teamTableB.register(nib, forCellReuseIdentifier: "TeamMemberSummaryCell")
        
        resultsLabelSetting()
        teamResultLabelsSetting()
        
        
    }
    //MARK: - Draw UI
    func resultsLabelSetting() {
        guard let summonerWinBool = summonerWinBool else { fatalError("summonerWinBool - is nil") }
        resultsLable.textColor = UIColor.theme.pureWhite
        if summonerWinBool {
            resultsLable.text = "Win"
            resultsLable.backgroundColor = .blue
        } else {
            resultsLable.text = "Lose"
            resultsLable.backgroundColor = .red
        }
    }
    func teamResultLabelsSetting() {
        guard let matchInfo = matchInfo else { return }
        let blueTeamInfo = matchInfo.info.teams[0]
        let redTeamInfo = matchInfo.info.teams[1]
        blueTeamResult.textColor = UIColor.theme.pureWhite
        redTeamResult.textColor = UIColor.theme.pureWhite
        if blueTeamInfo.win {
            blueTeamResult.text = "승리"
            redTeamResult.text = "패배"
        } else {
            blueTeamResult.text = "패배"
            redTeamResult.text = "승리"
        }
        let blueTeamMembers = self.blueTeamMember
        let blueTeamKDA = returnedKDA(teamMembers: blueTeamMembers)
        let redTeamMembers = self.redTeamMember
        let redTeamKDA = returnedKDA(teamMembers: redTeamMembers)
        blueTeamKill.text = blueTeamKDA.0.intToString()
        blueTeamDeath.text = blueTeamKDA.1.intToString()
        blueTeamAssist.text = blueTeamKDA.2.intToString()
        blueTeamDragon.text = blueTeamInfo.objectives.dragon.kills.intToString()
        blueTeamBarron.text = blueTeamInfo.objectives.baron.kills.intToString()
        blueTeamTower.text = blueTeamInfo.objectives.tower.kills.intToString()
        
        redTeamKill.text = redTeamKDA.0.intToString()
        redTeamDeath.text = redTeamKDA.1.intToString()
        redTeamAssist.text = redTeamKDA.2.intToString()
        redTeamDragon.text = redTeamInfo.objectives.dragon.kills.intToString()
        redTeamBarron.text = redTeamInfo.objectives.baron.kills.intToString()
        redTeamTower.text = redTeamInfo.objectives.tower.kills.intToString()
    }
    
    //MARK: - Setting property method
    func settingWinTeamId() {
        guard let matchInfo = matchInfo else { return }
        let winTeam =
        matchInfo.info.teams.filter { aTeam in
            return aTeam.win == true
        }.first!
        self.winTeamId = winTeam.teamID
    }
    func settingSummonerWinBool() {
        guard let safeSummonerInfo = summonerInfo else { fatalError("summonerWinBool - is nil") }
        guard let matchInfo = matchInfo else { return }
        
        let summonerTeamId =
        matchInfo.info.participants.first(where: { aParticipant in
            return aParticipant.summonerName == safeSummonerInfo.name
        })!.teamID
        print("summonerTeamId - \(summonerTeamId)")
        if summonerTeamId == winTeamId {
            summonerWinBool = true
        } else {
            summonerWinBool = false
        }
    }
    
    func settingMostDamage() {
        guard let matchInfo = matchInfo else { return }
        let totalDealtArray =
        matchInfo.info.participants.map { aSummoner in
            return aSummoner.totalDamageDealtToChampions
        }
        self.mostDamage = totalDealtArray.max()!
    }
    
    func settingTeamMember() {
        guard let safeMatchInfos = matchInfo else { return }
        let classifiedTeamMember = service.classifyTeamColor(matchInfo: safeMatchInfos)
        self.blueTeamMember = classifiedTeamMember.0
        self.redTeamMember = classifiedTeamMember.1
    }
    
    private func settingTableViewData(cell: TeamMemberSummaryCell, aMember: Participant) {
        guard let summonerInfo = summonerInfo else { fatalError("summonerInfo is nil") }
        if aMember.championName == summonerInfo.name {
            cell.tintColor = UIColor.green
        }
        // 챔피언 이미지
        let champImgUrl = aMember.championName.toChampionSmallImgUrl()
        cell.champImg.loadImage(from: champImgUrl, folderName: Constants.folderName.championImgSmall.rawValue, imgName: aMember.championName)
        // 스펠 이미지
        let spell1Name = DictionaryStore.shared.spellStore[aMember.summoner1ID.intToString()]!
        let spell1Url = ImageUrlRouter.spell(name: spell1Name).imgUrl
        let spell2Name = DictionaryStore.shared.spellStore[aMember.summoner2ID.intToString()]!
        let spell2Url = ImageUrlRouter.spell(name: spell2Name).imgUrl
        cell.spell1.loadImage(from: spell1Url,
                              folderName: Constants.folderName.spellImg.rawValue ,
                              imgName: spell1Name)
        cell.spell2.loadImage(from: spell2Url,
                              folderName: Constants.folderName.spellImg.rawValue,
                              imgName: spell2Name)
        // 소환사 네임
        cell.summonerName.text = aMember.summonerName
        // KDA
        cell.kill.text = aMember.kills.intToString()
        cell.death.text = aMember.deaths.intToString()
        cell.death.textColor = .red
        cell.assist.text = aMember.assists.intToString()
        // 아이템 이미지
        let item1Code = aMember.item0.intToString()
        let item1Url = ImageUrlRouter.item(name: item1Code).imgUrl
        cell.item1.loadImage(from: item1Url,
                             folderName: Constants.folderName.item.rawValue,
                             imgName: item1Code)
        let item2Code = aMember.item1.intToString()
        let item2Url = ImageUrlRouter.item(name: item2Code).imgUrl
        cell.item1.loadImage(from: item2Url,
                             folderName: Constants.folderName.item.rawValue,
                             imgName: item2Code)
        let item3Code = aMember.item2.intToString()
        let item3Url = ImageUrlRouter.item(name: item3Code).imgUrl
        cell.item1.loadImage(from: item3Url,
                             folderName: Constants.folderName.item.rawValue,
                             imgName: item3Code)
        let item4Code = aMember.item3.intToString()
        let item4Url = ImageUrlRouter.item(name: item4Code).imgUrl
        cell.item1.loadImage(from: item4Url,
                             folderName: Constants.folderName.item.rawValue,
                             imgName: item4Code)
        let item5Code = aMember.item4.intToString()
        let item5Url = ImageUrlRouter.item(name: item5Code).imgUrl
        cell.item1.loadImage(from: item5Url,
                             folderName: Constants.folderName.item.rawValue,
                             imgName: item5Code)
        let item6Code = aMember.item5.intToString()
        let item6Url = ImageUrlRouter.item(name: item6Code).imgUrl
        cell.item1.loadImage(from: item6Url,
                             folderName: Constants.folderName.item.rawValue,
                             imgName: item6Code)
        let item7Code = aMember.item6.intToString()
        let item7Url = ImageUrlRouter.item(name: item7Code).imgUrl
        cell.item1.loadImage(from: item7Url,
                             folderName: Constants.folderName.item.rawValue,
                             imgName: item7Code)
        // 딜량
        let dealt = aMember.totalDamageDealtToChampions
        let portion = Float(dealt) / Float(self.mostDamage!)
        cell.damageBar.progress = portion
        cell.damageText.text = dealt.description
    }
    
    func returnedKDA(teamMembers: [Participant]) -> (Int, Int, Int) {
        let killArray =
        teamMembers.map { aMember in
            return aMember.kills
        }
        let deathArray =
        teamMembers.map { aMemeber in
            return aMemeber.deaths
        }
        let assistArray =
        teamMembers.map { aMember in
            return aMember.assists
        }
        let kills = killArray.reduce(0, +)
        let deaths = deathArray.reduce(0, +)
        let assists = assistArray.reduce(0, +)
        return (kills, deaths, assists)
    }
}

extension MatchDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == teamTableA {
            return blueTeamMember.count
        } else if tableView == teamTableB {
            return redTeamMember.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let summonerInfo = summonerInfo else { fatalError("summonerInfo is nil") }
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMemberSummaryCell", for: indexPath) as! TeamMemberSummaryCell
        //Blue Team 데이터 대입
        if tableView == teamTableA {
            let aMember = blueTeamMember[indexPath.row]
            if aMember.summonerName == summonerInfo.name {
                cell.backgroundColor = .green
            }
            settingTableViewData(cell: cell, aMember: aMember)
        } else if tableView == teamTableB {
            let aMember = redTeamMember[indexPath.row]
            if aMember.summonerName == summonerInfo.name {
                cell.backgroundColor = .green
            }
            settingTableViewData(cell: cell, aMember: aMember)
        }
        
        return cell
    }
    
    
}

extension MatchDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ResultTableHeaderView") as? ResultTableHeaderView else { fatalError("MatchDetailVC - header error") }
//        if tableView == teamTableA {
//            header.resultLabel.text =
//        }
        
        return header
    }
    
}
