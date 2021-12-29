//
//  PageViewController.swift
//  teamTest
//
//  Created by Admin on 26.11.2021.

import UIKit

class PageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var composeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var filterPosts: [BlogPost] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchAllPosts()
        tableView.reloadData()
        print ("print")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.register(PostPreviewTableViewCell.self,
                           forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        
        self.tabBarController?.navigationItem.hidesBackButton = true
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchAllPosts()
        tableView.reloadData()

     
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
    }
    
    @objc private func hideKeyboard () {
        self.view.endEditing(true)
    }
    
    private var posts: [BlogPost] = []
    
    private func fetchAllPosts() {
        
        print("Fetching posts...")
        
        DatabaseManager.shared.getAllPosts { [weak self] posts in
            self?.posts = posts
            self?.filterPosts = posts
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = filterPosts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as? PostPreviewTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(title: post.title, imageUrl: post.headerImageUrl))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ShowPostViewController(post: filterPosts [indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Post"
        navigationController?.pushViewController(vc, animated: true)
    }
    
// MARK: add search bar

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterPosts = []
        
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            filterPosts = posts
            self.tableView.reloadData()
        }
        else{
            for post in posts {
                if post.title.lowercased().contains(searchText.lowercased()) == true {
                    filterPosts.append(post)
                }
            }
            self.tableView.reloadData()
        }
    }
}
