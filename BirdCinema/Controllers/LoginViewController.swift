//
//  LoginViewController.swift
//  BirdCinema
//
//  Created by 김시종 on 4/22/24.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginLogoImage: UIImageView!
    @IBOutlet weak var loginIdTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var logoImage1: UIImageView!
    @IBOutlet weak var logoImage2: UIImageView!
    @IBOutlet weak var logoImage3: UIImageView!
    @IBOutlet weak var logoImage4: UIImageView!
    @IBOutlet weak var logoImage5: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuplogin()
        
        loginIdTextField.delegate = self
        loginPasswordTextField.delegate = self
        
    }
    
    func setuplogin() {
        loginIdTextField.placeholder = "이메일 주소를 입력하세요."
        loginPasswordTextField.placeholder = "비밀번호를 입력하세요."
        loginPasswordTextField.isSecureTextEntry = true
        
        loginButton.layer.cornerRadius = 20
        loginButton.clipsToBounds = true
        
        logoImage1.image = UIImage(named: "kakaoLogo")
        logoImage2.image = UIImage(named: "naverLogo")
        logoImage3.image = UIImage(named: "instaLogo")
        logoImage4.image = UIImage(named: "facebookLogo")
        logoImage5.image = UIImage(named: "googleLogo")
        
        logoImage1.layer.cornerRadius = logoImage1.bounds.width / 2
        logoImage1.clipsToBounds = true
        logoImage2.layer.cornerRadius = logoImage2.bounds.width / 2
        logoImage2.clipsToBounds = true
        logoImage3.layer.cornerRadius = logoImage2.bounds.width / 2
        logoImage3.clipsToBounds = true
        logoImage4.layer.cornerRadius = logoImage2.bounds.width / 2
        logoImage4.clipsToBounds = true
        logoImage5.layer.cornerRadius = logoImage2.bounds.width / 2
        logoImage5.clipsToBounds = true
    }


    @IBAction func loginToggleButton(_ sender: UIButton) {
        guard let email = loginIdTextField.text,
              let password = loginPasswordTextField.text else {
            
            //입력한 정보가 없거나 정보가 틀린경우 로직구현
            print("정보가 없거나 틀렸다.")
            return
        }
        
        guard let savedUserInfo = UserDefaults.standard.dictionary(forKey: "userInfo") else {
            // 저장된 회원가입 정보가 없는 경우 로직 구현
            print("회원 가입 정보가 없다.")
            return
        }
        
        if let savadPasswod = savedUserInfo[email] as? String, password == savadPasswod {
            // ** 로그인 성공해서 메인 영화 페이지로 이동하는 로직 구현 **
            print("로그인 성공")
        } else {
            // 정보가 맞지 않아 로그인 실패 로직
            print("이메일 또는 비밀번호가 올바르지 않다.")
        }
    }
    
    
    
    
    
    @IBAction func joinToggleButton(_ sender: UIButton) {
        if let secondVC = storyboard?.instantiateViewController(withIdentifier: "secondVC") as? JoinViewController {
            secondVC.modalPresentationStyle = .formSheet
            present(secondVC, animated: true, completion: nil)
        }
    }
    
}
