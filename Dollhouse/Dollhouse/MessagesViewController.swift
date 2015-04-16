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
    var messageObjects = [PFObject]()
    
    var outgoingBubbleImage = JSQMessagesBubbleImage()
    var incomingBubbleImage = JSQMessagesBubbleImage()
    
    var selfAvatar = JSQMessagesAvatarImage()
    var incomingAvatar = JSQMessagesAvatarImage()

    
    // MARK: - View Controller Lifecycle
    
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
    }
    
    
    // MARK: - Load Messages
    
    func loadMessages() {
        var lastMessage:JSQMessage? = nil
        
        if messages.last != nil {
            lastMessage = messages.last
        }
        
        let messageQuery = PFQuery(className: "Message")
        messageQuery.whereKey("room", equalTo: room)
        messageQuery.limit = 500
        messageQuery.includeKey("user")
        
        // only load the newest messages
        if lastMessage != nil {
            messageQuery.whereKey("createdAt", greaterThan: lastMessage!.date)
        }
        
        messageQuery.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                let messages = results as! [PFObject]
                
                // for every message in the messages array
                for message in messages {
                    // Add the message to the messages object
                    self.messageObjects.append(message)
                    
                    // then add the user
                    let user = message["user"] as! PFUser
                    self.users.append(user)
                    
                    // and add the message to the JSQMessages Array
                    let chatMessage = JSQMessage(senderId: user.objectId, senderDisplayName: user.username, date: message.createdAt, text: message["content"] as! String)
                    self.messages.append(chatMessage)
                }
                
                if results!.count != 0 {
                    self.finishReceivingMessage()
                }
            }
        }
    }
    
    
    // MARK: - Send Messages
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let message = PFObject(className: "Message")
        message["content"] = text
        message["room"] = room
        message["user"] = PFUser.currentUser()
        
        message.saveInBackgroundWithBlock { (success: Bool, error:NSError?) -> Void in
            if error == nil {
                self.loadMessages()
                
                self.room["lastUpdated"] = NSDate()
                self.room.saveInBackgroundWithBlock(nil)
            } else {
                println("Error sending message: \(error?.localizedDescription)")
            }
        }
        self.finishSendingMessage()
    }
    
    
    // MARK: - JSQMessageVC Delegate Methods
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.row]
        
        if message.senderId == self.senderId {
            return outgoingBubbleImage
        }
        
        return incomingBubbleImage
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.row]
        
        if message.senderId == self.senderId {
            return selfAvatar
        }
        
        return incomingAvatar
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        if indexPath.item % 3 == 0 {
            let message = messages[indexPath.item]
            
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        
        return nil
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.row]
        
        if message.senderId == self.senderId {
            cell.textView.textColor = UIColor.blackColor()
        } else {
            cell.textView.textColor = UIColor.whiteColor()
        }
        
        cell.textView.linkTextAttributes = [NSForegroundColorAttributeName:cell.textView.textColor]
        
        return cell
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0
    }
    
    
    // MARK: - Data Source
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

}
