//
//  LoginSignUpViewController.swift
//  Dollhouse
//
//  Created by Dulio Denis on 4/11/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

import UIKit

class LoginSignUpViewController: PFLogInViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.signUpController?.delegate = self
        
        self.logInView?.logo = UIImageView(image: UIImage(named: "dollhouse-logo"))
        self.signUpController?.signUpView?.logo = UIImageView(image: UIImage(named: "dollhouse-logo"))
        
        self.logInView?.logo?.contentMode = .Center
        self.signUpController?.signUpView?.logo?.contentMode = UIViewContentMode.Center
        
        if PFUser.currentUser() != nil {
            showChatOverview()
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        showChatOverview()
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        signUpController.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.showChatOverview()
        })
    }
    
    func showChatOverview() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatOverview = storyboard.instantiateViewControllerWithIdentifier("chatOverview") as! OverviewTableViewController
        
        chatOverview.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.pushViewController(chatOverview, animated: true)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
