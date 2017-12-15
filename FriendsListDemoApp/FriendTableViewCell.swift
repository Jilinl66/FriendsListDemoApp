//
//  TableViewCell.swift
//  FriendsListDemoApp
//
//  Created by Jilin Liu on 12/13/17.
//  Copyright © 2017 Jilin Liu. All rights reserved.
//

import Foundation
import UIKit

class FriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myImageView.layer.cornerRadius = 5
    }
    
    public func fill(withFriendObject friendObject: FriendObject) {
        DispatchQueue.main.async {
            self.nameLabel.text = friendObject.name
            self.myImageView.image = friendObject.image
        }
    }
}
