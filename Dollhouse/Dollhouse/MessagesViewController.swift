//
//  MessagesViewController.swift
//  Dollhouse
//
//  Created by Dulio Denis on 4/15/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

import UIKit
import Parse

class MessagesViewController: JSQMessagesViewController {
    
    var room:PFObject!
    var incomingUser:PFUser!
    var users = [PFUser]()
    
    var messages = [JSQMessage]()
    var messageObject = [PFObject]()
    
    var outgoingBubbleImage = JSQMessagesBubbleImage()
    var incomingBubbleImage = JSQMessagesBubbleImage()
    
    var selfAvatar = JSQMessagesAvatarImage()
    var incomingAvatar = JSQMessagesAvatarImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Messages"
        self.senderId = PFUser.currentUser()?.objectId
        self.senderDisplayName = PFUser.currentUser()?.username
        
        let selfUsername = PFUser.currentUser()?.username as String!
        let incomingUsername = incomingUser?.username as String!
        
        let nsText = selfUsername as NSString
        let initials = nsText.substringWithRange(NSMakeRange(0, 2))
        
        selfAvatar = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(initials, backgroundColor: UIColor.blackColor(), textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(14), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))!
        
        let nsIncomingText = incomingUsername as NSString
        let initialsIncomingText = nsIncomingText.substringWithRange(NSMakeRange(0, 2))
        
        incomingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(initialsIncomingText, backgroundColor: UIColor.blackColor(), textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(14), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImage = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
        incomingBubbleImage = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.grayColor())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
