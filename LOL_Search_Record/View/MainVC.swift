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
    
    //MARK: - View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.summonerSearchBar.delegate = self
        self.searchedSummoners.delegate = self
        // UISearchBar에서 키보드를 내리지 않도록 합니다.
        let searchBarTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSearchBarTap))
        searchBarTapGesture.delegate = self
        summonerSearchBar.addGestureRecognizer(searchBarTapGesture)
        
        // 다른 뷰를 탭했을 때 키보드를 내리도록 합니다.
        let otherTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOtherTap))
        otherTapGesture.delegate = self
        view.addGestureRecognizer(otherTapGesture)
        
        // 국가,지역을 채택 정보를 받습니다.
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataNotification(_:)), name: NSNotification.Name("UrlHead"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.location.title = urlHead.nationString.uppercased()
    }
    
    
    //MARK: - Notification Center
    @objc func handleDataNotification(_ notification: Notification) {
        if let receivedData = notification.object as? UrlHeadPoint {
            self.urlHead = receivedData
            print("MainVC - receivedData \(receivedData)")
        }
    }
    
    //MARK: - 탭 제스처
    //UISearchBar를 탭했을 때 호출되는 메서드
    @objc func handleSearchBarTap(_ gesture: UITapGestureRecognizer) {
        // 키보드를 내리지 않습니다.
    }
    
    // 다른 뷰를 탭했을 때 호출되는 메서드
    @objc func handleOtherTap(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true) // 키보드를 내립니다.
    }
    
}




extension MainVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 다음 화면
        guard let summonerName = summonerSearchBar.text, !summonerName.isEmpty else {
            let alertController = UIAlertController(title: "검색어 에러", message: "소환사 이름을 입력해주세요.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .cancel)
            alertController.addAction(alertAction)
            present(alertController, animated: true)
            return
        }
        Task {
            let result = try await vm.searchSummonerInfo(urlBaseHead: urlHead, name: summonerName)
            //            SummonerStoryboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let summonerVC = storyboard.instantiateViewController(withIdentifier: "SummonerVC") as! SummonerVC
            summonerVC.summonerInfo = result
            
            navigationController?.pushViewController(summonerVC, animated: true)
        }
        
    }
    //    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //        print("searchBar cancel button clicked")
    //        summonerSearchBar.text = ""
    //        summonerSearchBar.resignFirstResponder()
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

extension MainVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //UISearchBar에서 터치 이벤트를 받지 않도록 합니다.
        if gestureRecognizer.view == summonerSearchBar {
            return false
        }
        return true
    }
}
