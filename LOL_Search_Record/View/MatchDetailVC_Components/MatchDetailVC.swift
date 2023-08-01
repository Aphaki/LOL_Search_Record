//
//  MatchDetailVC.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/26.
//

import UIKit

class MatchDetailVC: UIViewController {
    let service = Service()
    
    //승 or 패
    @IBOutlet weak var ResultsLable: UILabel!
    
    
    
//    var summonerInfo: SummonerInfo?
//    var participant: [Participant] = []
    // 매치 정보 표기
    var matchInfos: MatchInfo?
    // 해당 플레이어 표기
    var summonerInfo: SummonerInfo?
    // 해당 플레이어의 팀과 적팀으로 분류, 승패여부
    
    // 위 두 데이터로부터 나온 데이터(A,B Team Info 채울 데이터)
    // TeamID (100 -> Blue), (200 -> Red)
    var blueTeamMember: [Participant] = []
    var redTeamMember: [Participant] = []

    

    override func viewDidLoad() {
        super.viewDidLoad()
        settingTeamMember()
    }
    
    
    func settingTeamMember() {
        guard let safeMatchInfos = matchInfos else { return }
        let classifiedTeamMember = service.classifyTeamColor(matchInfo: safeMatchInfos)
        self.blueTeamMember = classifiedTeamMember.0
        self.redTeamMember = classifiedTeamMember.1
    }
    
}
