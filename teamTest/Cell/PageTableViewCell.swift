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
    
    var post: BlogPost? {
        didSet {
            guard post != oldValue else { return }
            configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerImageView.layer.cornerRadius = 16
        
        let imageView = profileImageView
        imageView?.backgroundColor = .systemGray2
        imageView?.layer.borderWidth = 0.5
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.layer.cornerRadius = 50.0
        imageView?.contentMode = .scaleAspectFill
    }
    
    func profilePicture() {
        profileImageView.image = nil
        guard let urlString = post?.user?.profilePictureRef,
              let url = URL(string: urlString) else  {
                  return
              }
        ImageManager.shared.load(url: url) { profilePicture, requestUrl in
            DispatchQueue.main.async { [weak self] in
                guard let self = self,
                      let urlString = self.post?.user?.profilePictureRef,
                      let url = URL(string: urlString),
                      url == requestUrl
                else { return }
                self.profileImageView.image = profilePicture
            }
        }
    }
    
    func headerPicture() {
        headerImageView.image = nil
        guard let url = post?.headerImageUrl else { return }
        ImageManager.shared.load(url: url) { headerImage, requestUrl in
            DispatchQueue.main.async { [weak self] in
                guard let self = self,
                      let url = self.post?.headerImageUrl,
                      url == requestUrl
                else { return }
                self.headerImageView.image = headerImage
            }
        }
    }
    
    private func configure() {
        titleLabel.text = post?.title
        costLabel.text = post?.cost
        firstName.text = post?.user?.name
        profilePicture()
        headerPicture()
    }
}
