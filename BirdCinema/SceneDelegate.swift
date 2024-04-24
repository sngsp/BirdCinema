//
//  SceneDelegate.swift
//  BirdCinema
//
//  Created by 김시종 on 4/22/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // 지정한 storyboardName 이름을 갖는 Storyboard로 이동
    func move(to storyboardName: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
//      func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//       guard let windowScene = (scene as? UIWindowScene) else { return }
//       let window = UIWindow(windowScene: windowScene)
//       self.window = window
//       window.makeKeyAndVisible()
//       // 내가 원하는 Storybaord를 시작점으로 설정
//       DispatchQueue.main.async() {
//        // MARK: :경고: 함수 인자(to:)만 수정하세요! :경고:
//    }
//    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.makeKeyAndVisible()
        // 내가 원하는 Storybaord를 시작점으로 설정
        DispatchQueue.main.async() {
            // MARK: ⚠️ 함수 인자(to:)만 수정하세요! ⚠️
            // 만약 잘 안된다면 두가지 확인하기
            // 1. 오타는 없는지
            // 2. 스토리보드 내의 entry point가 있는지 (뷰컨 앞에 있는 화살표)
            // 3. 2번이 안되어있으면 속성에서 "is Initial View Controller" 체크하기.
            self.move(to: "MovieDetail")
        }
    }
        

//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
//        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
//        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        guard let _ = (scene as? UIWindowScene) else { return }
//    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

