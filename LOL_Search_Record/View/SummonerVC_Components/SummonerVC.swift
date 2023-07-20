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
        let urlString = imgName.toProfileiconUrlString()
        
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
        
        
        return cell
    }
}
