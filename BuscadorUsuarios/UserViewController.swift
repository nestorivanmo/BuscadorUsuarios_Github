//
//  UserViewController.swift
//  BuscadorUsuarios
//
//  Created by Néstor Iván on 11/06/18.
//  Copyright © 2018 Néstor Iván. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

class UserViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var repoLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    
    var user: UserStats?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        nameLabel.text = user?.name
        followersLabel.text = "\((user?.followers)!)"
        repoLabel.text = "\((user?.repos)!)"
        loginLabel.text = (user?.location)
    
        imageView.downloadedFrom(url: (user?.avatarUrl)!)
        
    }



}
