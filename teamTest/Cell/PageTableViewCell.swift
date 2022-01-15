//
//  PageTableViewCell.swift
//  teamTest
//
//  Created by Admin on 05.01.2022.
//

import UIKit

class PageTableViewCell: UITableViewCell {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var firstName: UILabel!
    
    var user: User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageData()
        headerImageView.layer.cornerRadius = 16
        
        let imageView = profileImageView
        imageView?.backgroundColor = .systemGray2
        imageView?.layer.borderWidth = 0.5
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.layer.cornerRadius = 50.0
        imageView?.contentMode = .scaleAspectFill
    }
    
    func imageData () {
        guard let urlString = user?.profilePictureRef,
              let url = URL(string: urlString) else  {
                  return
              }
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.profileImageView.image = image
            }
        })
        task.resume()
    }
}
