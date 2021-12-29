//
//  AuthViewController.swift
//  teamTest
//
//  Created by Admin on 26.11.2021.
//

import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
    super.viewDidLoad()

    checkLogin ()
    
    }
    
    func setUpElements () {

        Utilities.styleFilledButton(signUpButton)
        Utilities.styleFilledButton(loginButton)
        
   }
   
    func checkLogin () {
        
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: "email")
        let password = defaults.string(forKey: "password")
    
        print (email)
        print (password)
        
        if email != nil || password != nil {
            
            transitionToPage ()
            
        } else {
            
            setUpElements()
            
        }
    }
    
    func transitionToPage () {
        
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tabBarViewController) as? UITabBarController
        
          self.navigationController?.pushViewController(tabBarController!, animated: true)
//        view.window?.rootViewController = tabBarController
//        view.window?.makeKeyAndVisible()
    }
}
