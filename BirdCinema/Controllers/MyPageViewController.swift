//
//  MyPageViewController.swift
//  BirdCinema
//
//  Created by 김시종 on 4/22/24.
//

import UIKit

class MyPageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var userEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUserInfo()
        configureUI()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 화면이 나타날 때마다 데이터를 업데이트
        updateData()
    }
    
    func updateData() {
        tableView.reloadData()
    }
    
    func updateUserInfo() {
        // 로그인 정보 가져오기
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let loggedInUserInfo = appDelegate.loggedInUserInfo,
              let email = loggedInUserInfo.keys.first else {
            print("로그인 정보 없음")
            return
        }
        print("로그인 사용자 이메일: \(email)")
        self.userEmail = email
    }
    
    func configureUI() {
        self.navigationController?.navigationBar.tintColor = .systemIndigo
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemIndigo]
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let profileNib = UINib(nibName: "ProfileCell", bundle: nil)
        tableView.register(profileNib, forCellReuseIdentifier: "ProfileCell")
        
        let reservationNib = UINib(nibName: "ReservationCell", bundle: nil)
        tableView.register(reservationNib, forCellReuseIdentifier: "ReservationCell")
        
        let wishNib = UINib(nibName: "WishCell", bundle: nil)
        tableView.register(wishNib, forCellReuseIdentifier: "WishCell")
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return ReservationManager.shared.reservations.count
        } else if section == 2 {
            return WishMovieManager.shared.wishlist.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileCell else { return UITableViewCell() }
            
            cell.userEmailLabel.text = "\(userEmail ?? "")님"
            
            // 로그아웃 버튼 누를 경우 로그인 페이지 이동
            cell.logOutButtonAction = { [weak self] in
                print("로그아웃 버튼이 눌렸습니다.")
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                guard let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController else { return }
                
                loginVC.modalPresentationStyle = .fullScreen
                self?.present(loginVC, animated: true, completion: nil)
            }
            
            
            return cell
            
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell", for: indexPath) as? ReservationCell else { return UITableViewCell() }
            
            let reservation = ReservationManager.shared.reservations[indexPath.row]
            cell.configureCell(reservation)
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WishCell", for: indexPath) as? WishCell else { return UITableViewCell() }
            
            let wish = WishMovieManager.shared.wishlist[indexPath.row]
            cell.configureCell(wish)
            // 셀 버튼 삭제
            cell.deleteHandler = {
                let alert = UIAlertController(title: "Notice", message: "영화를 삭제하시겠습니까?", preferredStyle: .alert)
                
                let deleteAction = UIAlertAction(title: "삭제하기", style: .default) { _ in
                    guard let indexPathToDelete = tableView.indexPath(for: cell) else { return }
                    
                    WishMovieManager.shared.removeMovieFromWishlist(at: indexPathToDelete.row)
                    tableView.reloadData()
                }
                
                let cancelAction = UIAlertAction(title: "취소", style: .default)
                
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                self.present(alert, animated: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 110
        } else if indexPath.section == 1 {
            return 100
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
            headerView.backgroundColor = .clear
            
            let borderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 6))
            borderView.backgroundColor = .systemGray5
            headerView.addSubview(borderView)
            
            let titleLabel = UILabel(frame: CGRect(x: 16, y: 10, width: headerView.frame.width - 32, height: 40))
            titleLabel.text = "예매/구매 내역"
            titleLabel.textColor = .white
            titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
            headerView.addSubview(titleLabel)
            
            return headerView
        } else if section == 2 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
            headerView.backgroundColor = .clear
            
            let borderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 6))
            borderView.backgroundColor = .systemGray5
            headerView.addSubview(borderView)
            
            let titleLabel = UILabel(frame: CGRect(x: 16, y: 10, width: headerView.frame.width - 32, height: 40))
            titleLabel.text = "찜한 영화"
            titleLabel.textColor = .white
            titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
            headerView.addSubview(titleLabel)
            
            return headerView
        } else {
            return nil
        }
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 60
        } else if section == 2 {
            return 60
        }else {
            return 0
        }
    }
}

