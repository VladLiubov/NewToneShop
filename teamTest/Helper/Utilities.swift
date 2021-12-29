//
//  Utilities.swift
//  teamTest
//
//  Created by Admin on 27.11.2021.
//

import Foundation
import UIKit

class Utilities {

    static func styleTextField(_ textfield:UITextField) {
        
        let bottomLine = CALayer ()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
    }

    static func styleFilledButton (_ button:UIButton) {
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 25
        button.tintColor = UIColor.white
    }
    
    static func styleHelloButton(_ button:UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25
        button.tintColor = UIColor.black
    }
    
    static func isPasswordValid (_ password: String) -> Bool{
        let passwordTest = NSPredicate (format: "SELF MATCHES %@", "^(?=.*[a-z]).{6,}$")
        return passwordTest.evaluate(with: password)
    }
    
    static func saveUserToDefaults (email: String, password: String, uid:String) {
         
         let defaults = UserDefaults.standard
         
         defaults.set(email, forKey: "email")
         defaults.set(password, forKey: "password")
         defaults.set(uid, forKey: "uid")
    }
    
    
}

extension UIView {
    var width: CGFloat {
        frame.size.width
    }

    var height: CGFloat {
        frame.size.height
    }

    var left: CGFloat {
        frame.origin.x
    }

    var right: CGFloat {
        left + width
    }

    var top: CGFloat {
        frame.origin.y
    }

    var bottom: CGFloat {
        top + height
    }
}
