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
    
    @IBOutlet weak var location: UIBarButtonItem!
    
    private var vm = MainVM()
    
    var urlHead: UrlHeadPoint = .kr
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.summonerSearchBar.delegate = self
        self.searchedSummoners.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataNotification(_:)), name: NSNotification.Name("UrlHead"), object: nil)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.location.title = urlHead.nationString.uppercased()
    }
    
    @objc func handleDataNotification(_ notification: Notification) {
            if let receivedData = notification.object as? UrlHeadPoint {
                self.urlHead = receivedData
                print("MainVC - receivedData \(receivedData)")
            }
        }
    
    
}




extension MainVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 다음 화면
        
//        guard let summonerName = summonerSearchBar.text else {
//            print("summonerName is nil")
//            return }
//        if summonerName == "" {
//            let alertController = UIAlertController(title: "검색어 에러", message: "소환사 이름을 입력해주세요.", preferredStyle: .alert)
//            let alertAction = UIAlertAction(title: "확인", style: .cancel)
//            alertController.addAction(alertAction)
//            present(alertController, animated: true)
//        } else {
//            vm.searchSummonerInfo(urlBaseHead: urlHead, name: summonerName)
//            let data = vm.searchedDetailInfo
//
//        }
        guard let summonerName = summonerSearchBar.text, !summonerName.isEmpty else {
            let alertController = UIAlertController(title: "검색어 에러", message: "소환사 이름을 입력해주세요.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .cancel)
            alertController.addAction(alertAction)
            present(alertController, animated: true)
            return
        }
        vm.searchSummonerInfo(urlBaseHead: urlHead, name: summonerName)
        let summonerVC = SummonerVC()
        summonerVC.summonerInfo = vm.searchedDetailInfo
        navigationController?.pushViewController(summonerVC, animated: true)
        
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//    }
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

