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
    var detailMatchs: [DetailSummonerInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    func loadiconImage() {
        guard let summonerInfo = summonerInfo else {
            print("SummonerVC - loadiconImage() : summonerInfo is nil")
            return
        }
        let imgName = summonerInfo.icon.iconIntToString()
        let urlString = imgName.toProfileiconUrlString()
        
        icon.loadImage(from: urlString, folderName: "profileicon", imgName: imgName)
    }
    func loadTierImage() {
        guard let summonerInfo = summonerInfo else { return }
        tierImg.image = UIImage(named: summonerInfo.tier)
    }
}

extension SummonerVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailMatchs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let detail = detailMatchs[indexPath.row]
        let cell = summaryTable.dequeueReusableCell(withIdentifier: "MatchSummaryCell", for: indexPath) as! MatchSummaryCell
        
        
        
        
        return cell
    }
}
