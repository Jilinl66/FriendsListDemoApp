//
//  Friend.swift
//  FriendsListDemoApp
//
//  Created by Jilin Liu on 12/13/17.
//  Copyright © 2017 Jilin Liu. All rights reserved.
//

import Foundation
import UIKit

class FriendObject {
    
    public var name: String
    public var image: UIImage?
    
    init(name: String, image: UIImage?) {
        self.name = name
        self.image = image
    }
}
