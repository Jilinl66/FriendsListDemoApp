//
//  ViewController.swift
//  FriendsListDemoApp
//
//  Created by Jilin Liu on 12/13/17.
//  Copyright © 2017 Jilin Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var friendTableView: UITableView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private var friendsList: [FriendObject]?
    private var friendImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendTableView.rowHeight = 60
        
        func mainWork() {
            fetchFriendsImage()
        }
        
        mainWork()
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(friendsList != nil) {
            return friendsList!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let friendCell = cell as? FriendTableViewCell {
            if let fList = friendsList {
                let friend = fList[indexPath.row]
                friendCell.fill(withFriendObject: friend)
            }
        }
    }
    
    // MARK: - Fetch image and friends list

    private func fetchFriendsImage() {
        let path: String = "https://dev01000api03.dynocloud.net/contact/image?friend_email=dgaddamwar@dynosense.com&size=80&mode=binary"
        Networker.networkAPICall(path: path, method: "GET", callback: gotFriendImageCallback);
    }
    
    private func gotFriendImageCallback(code: Int, data: AnyObject?, header: AnyObject?, errorMessage: String?) {
        if (code >= 200 && code <= 299) {
            if (data != nil) {
                friendImage = UIImage(data: data as! Data)
            }
        } else {
            displayAlert(message: errorMessage != nil ? errorMessage! : "")
        }
        fetchFriendsList()
    }
    
    private func fetchFriendsList() {
        let path: String = "https://dev01000api03.dynocloud.net/contact/list"
        Networker.networkAPICall(path: path, method: "GET", callback: gotFriendsListCallback);
    }
    
    private func gotFriendsListCallback(code: Int, data: AnyObject?, header: AnyObject?, errorMessage: String?) {
        finishLoading()
        if (code >= 200 && code <= 299) {
            if(data == nil) {
                return
            }
            if let _data = data?["data"] as? [String: AnyObject], let _friendsList = _data["friendList"] as? [[String: AnyObject]]{
                for friend in _friendsList {
                    if let name = friend["friend_name"] as? String {
                        let newFriendObject = FriendObject(name: name, image: friendImage)
                        if(friendsList == nil) {
                            friendsList = [newFriendObject]
                        } else {
                            friendsList?.append(newFriendObject)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.friendTableView.reloadData()
                }
            }
        } else {
            DispatchQueue.main.async {
                self.displayAlert(message: errorMessage != nil ? errorMessage! : "")
            }
        }
    }
    
    // MARK: - Updating UI

    private func finishLoading() {
        DispatchQueue.main.async {
            self.friendTableView.isHidden = false
            self.loadingLabel.isHidden = true
            self.loadingIndicator.isHidden = true
        }
    }
}


