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
    
    let coreDataService = CoreDataService.shared
    var indicaterView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    private var service = Service()
    
    private var searchedSummonerInfos: [SummonerModel] = []
    var networkManager = NetworkManager.shared
    
    var selectedSummonerInfo: SummonerModel?
    
    var urlHead: UrlHeadPoint = .kr
    
    //MARK: - View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchedSummonerInfos = coreDataService.fetchData()
        
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
        
        // 테이블뷰셀을 탭했을 때 선택되도록 합니다.
        let cellTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap))
        cellTapGesture.delegate = self
        searchedSummoners.addGestureRecognizer(cellTapGesture)
        
        // 국가,지역 채택 정보를 받습니다.
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataNotification(_:)), name: NSNotification.Name("UrlHead"), object: nil)
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.location.title = urlHead.rawValue.uppercased()
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
    
    @objc func handleCellTap(_ gesture: UITapGestureRecognizer) {
        if let indexPath = searchedSummoners.indexPathForRow(at: gesture.location(in: searchedSummoners)) {
            tableView(searchedSummoners, didSelectRowAt: indexPath)
        }
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
    //MARK: - 데이터 저장
    func saveSearchedSummonerData(result: DetailSummonerInfo) {
        let aModel = SummonerModel(iconImgId: result.icon, name: result.summonerName, tierImgStr: result.tier, tierText: result.tier, rank: result.rank, date: Date())
        if !searchedSummonerInfos.contains(where: { aSummonerInfo in
            return aSummonerInfo.name == result.summonerName
        }) {
            coreDataService.addEntity(model: aModel)
            self.searchedSummonerInfos = coreDataService.fetchData()
        } else {
            let existSummoner =
            searchedSummonerInfos.first { aSummonerInfo in
                return aSummonerInfo.name == result.summonerName
            }!
            let newSummoner = SummonerModel(iconImgId: result.icon, name: result.summonerName, tierImgStr: result.tier, tierText: result.tier, rank: result.rank, date: Date())
            coreDataService.upDateData(model: existSummoner, newModel: newSummoner)
            self.searchedSummonerInfos = coreDataService.fetchData()
        }
        searchedSummoners.reloadData()
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
            addLoadingView()
            // 네트워킹후 결과값 다음뷰에다가 적용
            let result = try await service.saveSearchedSummonerDetail(urlBase: urlHead, name: summonerName)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let summonerVC = storyboard.instantiateViewController(withIdentifier: "SummonerVC") as! SummonerVC
            summonerVC.summonerInfo = result
            summonerVC.urlHead = self.urlHead
            // 데이터 저장
            saveSearchedSummonerData(result: result)
            searchedSummoners.reloadData()
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
        cell.delegate = self
        cell.summonerModel = aSummonerInfo
        cell.drawUI()

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aSummonerInfo = searchedSummonerInfos[indexPath.row]
        self.selectedSummonerInfo = aSummonerInfo

        // 로딩뷰 추가
        view.alpha = 0.1
        addLoadingView()

        // 네트워킹후 결과값 다음뷰에다가 적용
        Task {
            do {
                let result = try await service.saveSearchedSummonerDetail(urlBase: urlHead, name: aSummonerInfo.name)

                // 데이터 저장
                saveSearchedSummonerData(result: result)

                // UI 업데이트를 메인 스레드에서 수행
                DispatchQueue.main.async {
                    self.searchedSummoners.reloadData()
                    print("MainVC - searchedSummonerInfos counts : \(self.searchedSummonerInfos.count)")

                    // 로딩뷰 제거
                    self.view.alpha = 1.0
                    self.indicaterView.removeFromSuperview()

                    // 다음뷰 푸쉬
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let summonerVC = storyboard.instantiateViewController(withIdentifier: "SummonerVC") as! SummonerVC
                    summonerVC.summonerInfo = result
                    self.navigationController?.pushViewController(summonerVC, animated: true)
                }

            } catch {
                // 에러 핸들링
                DispatchQueue.main.async {
                    self.view.alpha = 1.0
                    self.indicaterView.removeFromSuperview()
                    print("Error: \(error)")
                }
            }
        }
    }

    // 셀 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
    
    
    func tooManyRequestError() {
        let alertController = UIAlertController(title: "요청 에러", message: "짧은 시간에 너무 많은 요청을 했습니다. 잠시후에 다시 시도해주세요.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .cancel) { action in
            self.view.alpha = 1.0
            self.indicaterView.removeFromSuperview()
        }
        alertController.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}

extension MainVC: SearchedSummonerCellDelegate {
    func pressedXBtn(summonerModel: SummonerModel) {
        coreDataService.deleteData(model: summonerModel)
        self.searchedSummonerInfos = coreDataService.fetchData()
        searchedSummoners.reloadData()
    }
}

