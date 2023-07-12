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
    var detailMatchs: [DetailSummonerInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
