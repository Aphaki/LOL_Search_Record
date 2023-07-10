//
//  MainVC.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/06/23.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var summonerSearchBar: UISearchBar!
    
    @IBOutlet weak var searchedSummoners: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.summonerSearchBar.delegate = self
        self.searchedSummoners.delegate = self
    }
}

extension MainVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 다음 화면
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    // Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0 // 셀 갯수
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "SearchedSummonerCell")
        
        return cell
    }
    
    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

