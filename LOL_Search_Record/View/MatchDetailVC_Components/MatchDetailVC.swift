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
        self.teamTableA.delegate = self
        let nib = UINib(nibName: "TeamMemberSummaryCell", bundle: nil)
        let nibHeader = UINib(nibName: "ResultTableHeaderView", bundle: nil)
        teamTableA.register(nib, forCellReuseIdentifier: "TeamMemberSummaryCell")
        teamTableA.register(nibHeader, forHeaderFooterViewReuseIdentifier: "ResultTableHeaderView")
        
        
        resultsLabelSetting()
//        teamResultLabelsSetting()
        
        
    }
    //MARK: - Draw UI
    func resultsLabelSetting() {
        guard let summonerWinBool = summonerWinBool else { fatalError("summonerWinBool - is nil") }
        
        if summonerWinBool {
            resultsLable.text = "Win"
            resultsLable.textColor = UIColor.theme.win
            resultsLable.backgroundColor = UIColor.theme.teamBlue
            view.backgroundColor = UIColor.theme.teamBlue
        } else {
            resultsLable.text = "Lose"
            resultsLable.textColor = UIColor.theme.lose
            resultsLable.backgroundColor = UIColor.theme.teamRed
            view.backgroundColor = UIColor.theme.teamRed

        }
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
        cell.death.textColor = UIColor.theme.teamRed
        cell.assist.text = aMember.assists.intToString()
        // 아이템 이미지
        let item1Code = aMember.item0.intToString()
        let item1Url = ImageUrlRouter.item(name: item1Code).imgUrl
        cell.item1.loadImage(from: item1Url,
                             folderName: Constants.folderName.item.rawValue,
                             imgName: item1Code)
        let item2Code = aMember.item1.intToString()
        let item2Url = ImageUrlRouter.item(name: item2Code).imgUrl
        cell.item2.loadImage(from: item2Url,
                             folderName: Constants.folderName.item.rawValue,
                             imgName: item2Code)
        let item3Code = aMember.item2.intToString()
        let item3Url = ImageUrlRouter.item(name: item3Code).imgUrl
        cell.item3.loadImage(from: item3Url,
                             folderName: Constants.folderName.item.rawValue,
                             imgName: item3Code)
        let item4Code = aMember.item3.intToString()
        let item4Url = ImageUrlRouter.item(name: item4Code).imgUrl
        cell.item4.loadImage(from: item4Url,
                             folderName: Constants.folderName.item.rawValue,
                             imgName: item4Code)
        let item5Code = aMember.item4.intToString()
        let item5Url = ImageUrlRouter.item(name: item5Code).imgUrl
        cell.item5.loadImage(from: item5Url,
                             folderName: Constants.folderName.item.rawValue,
                             imgName: item5Code)
        let item6Code = aMember.item5.intToString()
        let item6Url = ImageUrlRouter.item(name: item6Code).imgUrl
        cell.item6.loadImage(from: item6Url,
                             folderName: Constants.folderName.item.rawValue,
                             imgName: item6Code)
        let item7Code = aMember.item6.intToString()
        let item7Url = ImageUrlRouter.item(name: item7Code).imgUrl
        cell.item7.loadImage(from: item7Url,
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
    
    func settingHeaderData (header: ResultTableHeaderView, teamKDA: (Int, Int, Int), teamInfo: Team) {
        if teamInfo.win {
            header.resultLabel.text = "승리"
        } else {
            header.resultLabel.text = "패배"
        }
        header.teamKills.text = teamKDA.0.intToString()
        header.teamDeaths.text = teamKDA.1.intToString().plusSlash()
        header.teamAssist.text = teamKDA.2.intToString()
        header.teamDragon.text = teamInfo.objectives.dragon.kills.intToString()
        header.teambarron.text = teamInfo.objectives.baron.kills.intToString()
        header.teamTower.text = teamInfo.objectives.tower.kills.intToString()
        
        //텍스트 칼라 설정
        switch teamInfo.teamID {
        case 100:
            header.resultLabel.textColor = UIColor.theme.teamBlue
            header.teamLabel.textColor = UIColor.theme.teamBlue
            header.teamLabel.text = "(BLUE팀)"
            
            header.teamKills.textColor = UIColor.theme.teamBlue
            header.teamDeaths.textColor = UIColor.theme.teamBlue
            header.teamAssist.textColor = UIColor.theme.teamBlue
        default:
            header.resultLabel.textColor = UIColor.theme.teamRed
            header.teamLabel.textColor = UIColor.theme.teamRed
            header.teamLabel.text = "(RED팀)"
            
            header.teamKills.textColor = UIColor.theme.teamRed
            header.teamDeaths.textColor = UIColor.theme.teamRed
            header.teamAssist.textColor = UIColor.theme.teamRed
        }
        
    }
    
    
}

extension MatchDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return blueTeamMember.count
        default:
            return redTeamMember.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let summonerInfo = summonerInfo else { fatalError("summonerInfo is nil") }
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMemberSummaryCell", for: indexPath) as! TeamMemberSummaryCell
        
        //Blue Team 데이터 대입
        if indexPath.section == 0 {
            let aMember = blueTeamMember[indexPath.row]
            if aMember.summonerName == summonerInfo.name {
                cell.backgroundColor = UIColor.theme.myYellow
            }
            settingTableViewData(cell: cell, aMember: aMember)
        } else {
            let aMember = redTeamMember[indexPath.row]
            if aMember.summonerName == summonerInfo.name {
                cell.backgroundColor = UIColor.theme.myYellow
            }
            settingTableViewData(cell: cell, aMember: aMember)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let matchInfo = matchInfo else { return nil }
        guard let header = teamTableA.dequeueReusableHeaderFooterView(withIdentifier: "ResultTableHeaderView") as? ResultTableHeaderView else { fatalError("MatchDetailVC - header error") }
        
        let blueTeamInfo = matchInfo.info.teams[0]
        let redTeamInfo = matchInfo.info.teams[1]
        
        let blueTeamMembers = self.blueTeamMember
        let blueTeamKDA = returnedKDA(teamMembers: blueTeamMembers)
        
        let redTeamMembers = self.redTeamMember
        let redTeamKDA = returnedKDA(teamMembers: redTeamMembers)
        
        switch section {
        case 0:
            settingHeaderData(header: header, teamKDA: blueTeamKDA, teamInfo: blueTeamInfo)
            return header
        default:
            settingHeaderData(header: header, teamKDA: redTeamKDA, teamInfo: redTeamInfo)
            return header
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
}

extension MatchDetailVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
