//
//  MyPageViewController.swift
//  BirdCinema
//
//  Created by 김시종 on 4/22/24.
//

import UIKit

class MyPageViewController: UIViewController {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureTableView()
    }
    
    func configureUI() {
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
       
        profileView.layer.cornerRadius = 16
        profileView.clipsToBounds = true
        
        profileView.layer.borderWidth = 1
        profileView.layer.borderColor = UIColor.systemGray.cgColor
//        profileView.layer.borderColor = UIColor(red: 37/255, green: 40/255, blue: 54/255, alpha: 1.0).cgColor
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let nibName = UINib(nibName: "ReservationCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "ReservationCell")
    }
}
extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell", for: indexPath) as? ReservationCell else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
