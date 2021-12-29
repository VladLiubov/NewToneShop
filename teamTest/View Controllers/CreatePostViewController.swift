//
//  PostViewController.swift
//  teamTest
//
//  Created by Admin on 13.12.2021.
//

import UIKit
import FirebaseStorage
import SwiftUI

class CreatePostViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var costField: UITextField!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var postButton: UIBarButtonItem!
        
    private var selectedHeaderImage: UIImage?
    
    var activeTextField : UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.delegate = self
        costField.delegate = self
        textView.delegate = self
        
        titleField.autocapitalizationType = .words
        textView.autocapitalizationType = .words
        
        headerImage.backgroundColor = .tertiarySystemBackground
        headerImage.contentMode = .scaleAspectFit
        headerImage.isUserInteractionEnabled = true
        headerImage.image = UIImage(systemName: "photo")

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        headerImage.addGestureRecognizer(tap)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreatePostViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreatePostViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
  
// MARK: Keyboard
    
    @objc func keyboardWillShow(notification: NSNotification) {

        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[ UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0 { self.view.frame.origin.y -= keyboardFrame.height
        }
        
//        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//            return
//          }
//
//          var shouldMoveViewUp = false
//          if let activeTextView = activeTextView {
//
//            let bottomOfTextField = activeTextView.convert(activeTextView.bounds, to: self.view).maxY;
//
//            let topOfKeyboard = self.view.frame.height - keyboardSize.height
//            if bottomOfTextField > topOfKeyboard {
//              shouldMoveViewUp = true
//            }
//          }
//
//          if(shouldMoveViewUp) {
//            self.view.frame.origin.y = 0 - keyboardSize.height
//          }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
//        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
//        scrollView.contentInset = contentInsets
//        scrollView.scrollIndicatorInsets = contentInsets
        
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[ UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y != 0 { self.view.frame.origin.y += keyboardFrame.height
        }
        
    }
    
    @objc private func hideKeyboard () {
        self.view.endEditing(true)
    }
    
    @objc func didTapHeader () {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func cencelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postButton(_ sender: Any) {
        
        guard let title = titleField.text,
              let body = textView.text,
              let cost = costField.text,
              let headerImage = selectedHeaderImage,
              let email = UserDefaults.standard.string(forKey: "email"),
              !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !cost.trimmingCharacters(in: .whitespaces).isEmpty,
              !body.trimmingCharacters(in: .whitespaces).isEmpty else {

            let alert = UIAlertController(title: "Заповніть всі поля",
                                          message: "Будь ласка, напишіть назву товару, вартість та його опис",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Зрозуміло", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }

        print("Starting post...")

        let newPostId = UUID().uuidString

        // Upload header Image
        StorageManager.shared.uploadBlogHeaderImage(
            email: email,
            image: headerImage,
            postId: newPostId
        ) { success in
            guard success else {
                return
            }
            StorageManager.shared.downloadUrlForPostHeader(email: email, postId: newPostId) { url in
                guard let headerUrl = url else {
                    DispatchQueue.main.async {
                        HapticsManager.shared.vibrate(for: .error)
                    }
                    return
                }

                // Insert of post into DB

                let post = BlogPost(
                    identifier: newPostId,
                    title: title,
                    cost: cost,
                    headerImageUrl: headerUrl,
                    text: body
                )

                DatabaseManager.shared.insert(blogPost: post, email: email) { [weak self] posted in
                    guard posted else {
                        DispatchQueue.main.async {
                            HapticsManager.shared.vibrate(for: .error)
                        }
                        return
                    }

                    DispatchQueue.main.async {
                        HapticsManager.shared.vibrate(for: .success)
                        print ("exit")
                        self?.cencelButton(true)
                    }
                }
            }
        }
    }
}


// MARK: Picker

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        selectedHeaderImage = image
        headerImage.image = image
    }
}

// MARK: Textfield, TextView

extension CreatePostViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleField.resignFirstResponder()
        costField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // set the activeTextField to the selected textfield
        self.activeTextField = textField
      }
        
      // when user click 'done' or dismiss the keyboard
      func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
      }
    
}
