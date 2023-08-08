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
    
    var indicaterView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    private var vm = MainVM()
    
    private var searchedSummonerInfos: [DetailSummonerInfo] = []
    var networkManager = NetworkManager.shared
    
    var urlHead: UrlHeadPoint = .kr
    
    //MARK: - View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.summonerSearchBar.delegate = self
        self.summonerSearchBar.searchTextField.backgroundColor = UIColor.theme.linecolor
        self.searchedSummoners.dataSource = self
        self.searchedSummoners.delegate = self
        self.networkManager.delegate = self
        
        // NIB 등록
        let nib = UINib(nibName: "SearchedSummonerCell", bundle: nil)
        searchedSummoners.register(nib, forCellReuseIdentifier: "SearchedSummonerCell")
        
        // UISearchBar에서 키보드를 내리지 않도록 합니다.
        let searchBarTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSearchBarTap))
        searchBarTapGesture.delegate = self
        summonerSearchBar.addGestureRecognizer(searchBarTapGesture)
        
        // 다른 뷰를 탭했을 때 키보드를 내리도록 합니다.
        let otherTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOtherTap))
        otherTapGesture.delegate = self
        view.addGestureRecognizer(otherTapGesture)
        
        // 국가,지역 채택 정보를 받습니다.
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
    
    //MARK: - 로딩뷰
    func addLoadingView() {
         // 스타일을 .large로 설정
        indicaterView.translatesAutoresizingMaskIntoConstraints = false // 오토레이아웃 설정

        // indicaterView의 크기를 설정해줍니다.
        indicaterView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        indicaterView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        view.addSubview(indicaterView)

        // indicaterView를 뷰의 중앙에 배치합니다.
        indicaterView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicaterView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        indicaterView.startAnimating() // 인디케이터 애니메이션 시작
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
            // 키보드 내리기
            view.endEditing(true)
            // 로딩뷰 추가
            view.alpha = 0.1
//            let indicaterView =
            addLoadingView()
            // 네트워킹후 결과값 다음뷰에다가 적용
            let result = try await vm.searchSummonerInfo(urlBaseHead: urlHead, name: summonerName)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let summonerVC = storyboard.instantiateViewController(withIdentifier: "SummonerVC") as! SummonerVC
            summonerVC.summonerInfo = result
            // 데이터 저장
            if !searchedSummonerInfos.contains(where: { aSummonerInfo in
                return aSummonerInfo.summonerName == result.summonerName
            }) {
                self.searchedSummonerInfos.append(result)
                searchedSummoners.reloadData()
            }
            print("MainVC - searchedSummonerInfos counts : \(searchedSummonerInfos.count)")
            // 로딩뷰 제거
            view.alpha = 1.0
            indicaterView.removeFromSuperview()
            // 다음뷰 푸쉬
            navigationController?.pushViewController(summonerVC, animated: true)
        }
        
    }
}

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    // Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchedSummonerInfos.count // 셀 갯수
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = searchedSummoners.dequeueReusableCell(withIdentifier: "SearchedSummonerCell", for: indexPath) as? SearchedSummonerCell else {
            fatalError("MainVC - Unable to dequeue searchedSummonerCell")
        }
        let aSummonerInfo = searchedSummonerInfos[indexPath.row]
        // 프로필 아이콘
        let iconCode = aSummonerInfo.icon.intToString()
        let iconURL = ImageUrlRouter.icon(code: iconCode).imgUrl
        cell.iconImage.loadImage(from: iconURL, folderName: Constants.folderName.icon.rawValue, imgName: iconCode)
        // 소환사 이름
        let aSummonerName = aSummonerInfo.summonerName
        cell.summonerName.text = aSummonerName
        // 티어 이미지
        let tierImg = aSummonerInfo.tier
        cell.tierImage.image = UIImage(named: tierImg.lowercased())
        // 티어 텍스트
        let tierText = "\(aSummonerInfo.tier) \(aSummonerInfo.rank)"
        cell.tierText.text = tierText
        
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

extension MainVC: NetworkManagerDelegate {
    
    
    func noSummonerError() {
        
        print("MainVC - noSummonerError()")
        let alertController = UIAlertController(title: "검색어 에러", message: "없는 소환사 입니다", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .cancel) { action in
            self.view.alpha = 1.0
            self.indicaterView.removeFromSuperview()
        }
        alertController.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    func noIngameError() {
        
    }
    
    func isLoading() {
        
    }
    
    func isLoadingSuccess() {
        
    }
    
    
}
