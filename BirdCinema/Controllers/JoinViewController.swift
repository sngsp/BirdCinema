//
//  JoinViewController.swift
//  BirdCinema
//
//  Created by 김시종 on 4/22/24.
//

import UIKit

class JoinViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var joinAddressTextField: UITextField!
    @IBOutlet weak var joinPasswordMainTextField: UITextField!
    @IBOutlet weak var joinPasswordSubTextField: UITextField!
    @IBOutlet weak var joinButton: UIButton!
    
    @IBOutlet weak var joinImage1: UIImageView!
    @IBOutlet weak var joinImage2: UIImageView!
    
    @IBOutlet weak var kakaoStackView: UIStackView!
    @IBOutlet weak var naverStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        
    }
    
    func setupTextField() {
        joinAddressTextField.delegate = self
        joinPasswordMainTextField.delegate = self
        joinPasswordSubTextField.delegate = self
        
        joinAddressTextField.placeholder = "이메일 주소를 입력하세요."
        joinPasswordMainTextField.placeholder = "비밀번호를 입력하세요."
        joinPasswordSubTextField.placeholder = "비밀번호를 동일하게 입력하세요."
        
        joinPasswordMainTextField.isSecureTextEntry = true
        joinPasswordSubTextField.isSecureTextEntry = true
        
        joinButton.layer.cornerRadius = 20
        joinButton.clipsToBounds = true
        
        joinImage1.image = UIImage(named: "kakaoLogo")
        joinImage2.image = UIImage(named: "naverLogo")
        
        kakaoStackView.layer.cornerRadius = 20
        kakaoStackView.clipsToBounds = true
        naverStackView.layer.cornerRadius = 20
        naverStackView.clipsToBounds = true
        
    }
    

    @IBAction func joinButtonTapped(_ sender: UIButton) {
        guard let email = joinAddressTextField.text,
              let password = joinPasswordMainTextField.text else {
            return
        }
        guard password == joinPasswordSubTextField.text else {
            showAlert(message: "비밀번호가 일치하지 않습니다.")
            print("비밀번호가 일치하지 않습니다.")
            return
        }
        
        var saveUserInfo = UserDefaults.standard.dictionary(forKey: "userInfo") ?? [:]
        
        if saveUserInfo[email] != nil {
            showAlert(message: "이미 등록된 이메일 입니다.")
            print("이미 등록된 이메일")
            return
        }
        saveUserInfo[email] = password
        UserDefaults.standard.set(saveUserInfo, forKey: "userInfo")
        
        joinOkAlert(message: "회원가입이 완료되었습니다.")
        print("가입완료")
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func joinOkAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
