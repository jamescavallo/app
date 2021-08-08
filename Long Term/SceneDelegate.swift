//
//  SceneDelegate.swift
//  Long Term
//
//  Created by James Cavallo on 7/10/21.
//

import UIKit
import Firebase
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

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
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
      guard let url = URLComponents(string: url) else { return nil }
      return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink){
        guard let url = dynamicLink.url else{
            print("No url or issue with deep link")
            return
        }
        //Parse the link then switch the view to get new password
        let code = getQueryStringParameter(url: url.absoluteString, param: "oobCode")!
        let mode = getQueryStringParameter(url: url.absoluteString, param: "mode")!
        if (mode == "resetPassword"){
            handlePasswordReset(code: code)
        }else if (mode == "verifyEmail"){
            handleVerify(code: code)
        }
        
        
    }
    
    func handlePasswordReset(code:String){
        Auth.auth().verifyPasswordResetCode(code){
            (email, error) in
            if (error != nil){
                //do nothing
                print(error!)
            }else{
                let userEmail = email!
                Utilities.code.actionCode = code
                Utilities.code.email = userEmail
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(identifier: "completedVC")
                self.window?.rootViewController = viewController
                self.window?.makeKeyAndVisible()
            }
        }
        
        
    }
    
    func handleVerify(code: String){
        Auth.auth().applyActionCode(code) { error in
            if error != nil{
                print("Couldnt Verify")
            }else{
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(identifier: "verifiedVC")
                self.window?.rootViewController = viewController
                self.window?.makeKeyAndVisible()
            }
        }
        
    }
    
    
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        _ = DynamicLinks.dynamicLinks() //this runs if the app is installed and opened from the link
          .handleUniversalLink(userActivity.webpageURL!) { dynamiclink, error in
              if error != nil{
                print("Something went wrong: \(String(describing: error))")
              }else{
                self.handleIncomingDynamicLink(dynamiclink!)
              }
          }
        
    }
    


}

