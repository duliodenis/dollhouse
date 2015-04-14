//
//  ChooseTableViewController.swift
//  Dollhouse
//
//  Created by Dulio Denis on 4/12/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

import UIKit
import Parse

class ChooseTableViewController: PFQueryTableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchString = ""
    var searchInProgress = false
    
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "User"
        self.textKey = "username"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 25
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFUser.query()
        
        let currentUser = PFUser.currentUser()
        if query != nil && currentUser != nil {
            query!.whereKey("objectId", notEqualTo: currentUser!.objectId!);
        }
        
        if searchInProgress {
            query?.whereKey("username", containsString: searchString)
        }
        
        if self.objects?.count == 0 {
            // can not use when pinning is enabled - using localDatastore in AppDelegate
            // see http://stackoverflow.com/questions/27720724/parse-com-error-method-not-allowed-when-pinning-is-enabled-when-i-use-a-pfque
            // query?.cachePolicy = PFCachePolicy.CacheThenNetwork
        }
        
        query?.orderByAscending("username")
        return query!
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchText
        searchInProgress = true
        self.loadObjects()
        searchInProgress = false
    }
    
    
    // MARK: Table View Delegate Methods
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if PFUser.currentUser() != nil {
            var user1 = PFUser.currentUser()
            var user2 = self.objects?[indexPath.row] as? PFUser
            
            var room = PFObject(className: "Room")
            
            // Setup the MessageViewController
            let predicate = NSPredicate(format: "user1 = %@ AND user2 = %@ OR user1 = %@ AND user2 = %@", user1!, user2!, user2!, user1!)
            
            let roomQuery = PFQuery(className: "Room", predicate: predicate)

            roomQuery.findObjectsInBackgroundWithBlock({ (results:[AnyObject]?, error:NSError?) -> Void in
                if error == nil {
                    if results!.count > 0 { // room is already existing
                        room = results!.last as! PFObject
                        
                        // Setup MessageViewController and Push to the MessageVC
                        
                    } else { // create a new room
                        room["user1"] = user1
                        room["user2"] = user2
                        
                        room.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                            if error == nil {
                                // Setup MessageViewController and push to the MessageVC
                            }
                        })
                    }
                }
            })
        }
    }

}
