//
//  MyPageViewController.swift
//  BirdCinema
//
//  Created by 김시종 on 4/22/24.
//

import UIKit

class MyPageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureTableView()
    }
    
    func configureUI() {
        //        self.navigationController?.navigationBar.tintColor = .white
        //        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let reservationNib = UINib(nibName: "ReservationCell", bundle: nil)
        tableView.register(reservationNib, forCellReuseIdentifier: "ReservationCell")
        
        let profileNib = UINib(nibName: "ProfileCell", bundle: nil)
        tableView.register(profileNib, forCellReuseIdentifier: "ProfileCell")
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return ReservationManager.shared.reservations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileCell else { return UITableViewCell() }

            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell", for: indexPath) as? ReservationCell else { return UITableViewCell() }
            
            let reservation = ReservationManager.shared.reservations[indexPath.row]
            cell.configureCell(reservation)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        } else {
            return 110
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
        } else {
            return nil
        }
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 60
        } else {
            return 0
        }
    }
}

