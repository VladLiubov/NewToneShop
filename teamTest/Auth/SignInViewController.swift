//
//  SignInViewController.swift
//  teamTest
//
//  Created by Admin on 26.11.2021.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignInViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var singInButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
}
    func setUpElements () {

        errorLabel.alpha = 0

        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(singInButton)
    }
    func validateFields() -> String? {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Заполните все поля"
        }
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Убедитесь, что ваш пароль иммет 8 символов, сожержит специальные символы и цифры"
        }
        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        let error = validateFields()
        if error != nil {
         showError(error!)
            
        } else {
            
            let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if err != nil {
                self.showError("Неправильное запонение пользователя")
                
            } else {
                
                let db = Firestore.firestore()
                
                db.collection("users").document(result!.user.uid).setData( ["email":email, "firstname":firstname,"lastname":lastname, "uid": result!.user.uid]) { (error) in
                    
                    if error != nil  {
                        self.showError("Ошибка при сохранении данных")
                    }
                }
                
                Utilities.saveUserToDefaults(email: email, password: password, uid: result!.user.uid)
                self.transitionToPage ()
            }
        
    }
}
}
    func showError (_ message: String) {
            errorLabel.text = message
            errorLabel.alpha = 1
      
    }
    
    func transitionToPage () {
        
       let tabBarController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tabBarViewController) as? UITabBarController
        
        view.window?.rootViewController = tabBarController
        view.window?.makeKeyAndVisible()
    }
    
}

