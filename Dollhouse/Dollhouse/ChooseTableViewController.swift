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

}
