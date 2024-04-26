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
    @IBOutlet weak var autoLoginButton: UIButton!
    
    @IBOutlet weak var logoImage1: UIImageView!
    @IBOutlet weak var logoImage2: UIImageView!
    @IBOutlet weak var logoImage3: UIImageView!
    @IBOutlet weak var logoImage4: UIImageView!
    @IBOutlet weak var logoImage5: UIImageView!
    
    var isAutoLoginEnabled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuplogin()
        saveLoginInfo()
        loginIdTextField.delegate = self
        loginPasswordTextField.delegate = self
    }
    
    // MARK: - 다시 로그인 화면 왔을때 자동로그인 여부 판단 후 값 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let loggedInUserInfo = appDelegate.loggedInUserInfo,
           let email = loggedInUserInfo.keys.first,
           let password = loggedInUserInfo.values.first,
           let isAutoLoginEnabled = UserDefaults.standard.object(forKey: "isAutoLoginEnabled") as? Bool {
            
            if isAutoLoginEnabled {
                loginIdTextField.text = email
                loginPasswordTextField.text = password
                autoLoginButton.isSelected = true
            } else {
                // 자동 로그인이 비활성화되어 있으면 아무 동작도 하지 않음
            }
        }
    }
    
    // MARK: - login 셋업
    func setuplogin() {
        loginIdTextField.placeholder = "이메일 주소를 입력하세요."
        loginPasswordTextField.placeholder = "비밀번호를 입력하세요."
        loginPasswordTextField.isSecureTextEntry = true
        
        loginButton.layer.cornerRadius = 20
        loginButton.clipsToBounds = true
        
        loginLogoImage.image = UIImage(named: "BirdCinemaLogo")
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - 빈곳 탭 키보드 내려감
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - 로그인 성공 시 로그인 정보 저장
    func saveLoginInfo() {
        if isAutoLoginEnabled, let savedUserInfo = UserDefaults.standard.dictionary(forKey: "userInfo"),
           let email = savedUserInfo.keys.first,
           let password = savedUserInfo.values.first as? String {
            loginIdTextField.text = email
            loginPasswordTextField.text = password
        }
    }
    
    // MARK: - 로그인 버튼 클릭 시 각 상황에 따른 이용자 알럿 로직
    @IBAction func loginToggleButton(_ sender: UIButton) {
        
        guard let email = loginIdTextField.text,
              let password = loginPasswordTextField.text else {
            showAlert(message: "이메일 또는 패스워드가\n일치하지 않습니다.")
            return
        }
        
        guard let savedUserInfo = UserDefaults.standard.dictionary(forKey: "userInfo") else {
            showAlert(message: "저장된 회원정보가 없습니다.")
            return
        }
        
        // 로그인 성공 시 데이터 저장
        if let savadPasswod = savedUserInfo[email] as? String, password == savadPasswod {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.loggedInUserInfo = [email:password]
            
            // 메인 뷰 컨트롤러로 이동
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: "MainViewTab") as? UITabBarController else { return }
            
            // 커스텀 전환 애니메이션 적용
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            view.window?.layer.add(transition, forKey: kCATransition)
            
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: false, completion: nil)
        } else {
            showAlert(message: "이메일 또는 패스워드가\n일치하지 않습니다.")
        }
    }
    
    // MARK: - 로그인 유저 알럿 구현 메소드
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - 자동 로그인 여부 설정 구현 로직
    @IBAction func saveLoginDataTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        print(sender.isSelected)
        UserDefaults.standard.set(sender.isSelected, forKey: "isAutoLoginEnabled")
        
        if sender.isSelected {
            saveLoginInfo()
        }
    }
    
    // MARK: - 회원가입 페이지 이동
    @IBAction func joinToggleButton(_ sender: UIButton) {
        if let secondVC = storyboard?.instantiateViewController(withIdentifier: "secondVC") as? JoinViewController {
            secondVC.modalPresentationStyle = .formSheet
            present(secondVC, animated: true, completion: nil)
        }
    }
}
