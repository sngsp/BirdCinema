//
//  MovieReservationViewController.swift
//  BirdCinema
//
//  Created by 김시종 on 4/22/24.
//

import UIKit

class MovieReservationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    

    func configureUI() {
        self.navigationController?.navigationBar.tintColor = .white
        // 내비게이션 바의 타이틀 색상을 화이트로 변경합니다.
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }

}
