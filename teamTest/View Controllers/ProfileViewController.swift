//
//  ProfileViewController.swift
//  teamTest
//
//  Created by Admin on 03.12.2021.
//

import UIKit
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var outButton: UIButton!
    @IBOutlet weak var emailAddress: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    private let storage = Storage.storage().reference()
    
    var currentEmail: String
    private var user: User?
    
    init(currentEmail: String) {
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder decoder: NSCoder) {
        self.currentEmail = ""
        super.init(coder: decoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserPosts()
        
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostPreviewTableViewCell.self,
                           forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        
        let emailLabel = emailAddress
        emailLabel?.text = UserDefaults.standard.string(forKey: "email")
        
        let imageView = profileImage
        imageView?.backgroundColor = .systemGray2
        imageView?.layer.borderWidth = 0.5
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.layer.cornerRadius = 50.0
        imageView?.contentMode = .scaleAspectFill
        
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
              let url = URL(string: urlString) else  {
                  return
              }
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.profileImage.image = image
            }
            
        })
        
        task.resume()
    }
    
    func setUpElements () {
        Utilities.styleFilledButton(outButton)
        Utilities.styleFilledButton(photoButton)
    }
    
    @IBAction func exitButton(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        transitionToSignIn ()
        
    }
    
    func transitionToSignIn () {
        
        let sigInVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.sigInVC) as? UINavigationController
        
        self.view.window?.rootViewController = sigInVC
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func photoButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
            
        }
        
        guard let imageData = image.pngData() else {
            return
        }
        
        storage.child("avatars/file.png").putData(imageData, metadata: nil, completion: {_, error in
            
            guard error == nil else {
                print("Не получилось")
                return
            }
            
            self.storage.child("avatars/file.png").downloadURL(completion: {url, error in
                
                guard let url = url, error == nil else {
                    return
                }
                
                self.profileImage.image = image
                
                let urlString = url.absoluteString
                print ("Download url: \(urlString)")
                UserDefaults.standard.set(urlString, forKey: "url")
            })
            
        })
    }

// MARK: TableBView
    
    private var posts: [BlogPost] = []
    
    private func fetchUserPosts() {
        
        guard let email = UserDefaults.standard.string(forKey: "email"),
              email == currentEmail else {
            return
        }
        
        DatabaseManager.shared.getPosts(for: currentEmail) { [weak self] posts in
            self?.posts = posts
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as? PostPreviewTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(title: post.title, imageUrl: post.headerImageUrl))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ShowPostViewController(post: posts[indexPath.row])
        vc.title = posts[indexPath.row].title
        navigationController?.pushViewController(vc, animated: true)
    }
}


