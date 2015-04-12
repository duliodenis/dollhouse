//
//  LoginSignUpViewController.swift
//  Dollhouse
//
//  Created by Dulio Denis on 4/11/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

import UIKit
import Parse

class LoginSignUpViewController: PFLogInViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.signUpController?.delegate = self
        
        self.logInView?.logo = UIImageView(image: UIImage(named: "dollhouse-logo"))
        self.signUpController?.signUpView?.logo = UIImageView(image: UIImage(named: "dollhouse-logo"))
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        signUpController.dismissViewControllerAnimated(true, completion: nil)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
