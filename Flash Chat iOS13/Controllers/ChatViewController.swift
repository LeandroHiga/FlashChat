//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    //Reference to out database
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self //Set this ChatViewController as the datasource
        title = K.appName //Title of ChatViewController
        navigationItem.hidesBackButton = true //Hide "Back" button
        
        //To use a custom .xib file we have to put it on the viewDidLoad()
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        //Load messages
        loadMessages()
    }
    
    func loadMessages() {
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)                      //Order by date
            .addSnapshotListener { (queySnapshot, error) in     //Listen for new messages
                
                //Clear the message array
                self.messages = []
                
                //Check if there was any error
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else { //If there was not error
                    if let snapshotDocuments = queySnapshot?.documents {
                        //Loop through the snapshotDocument array of QueyDocumentSnapshot and get its data
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            
                            //Check if sender and body can be converted to string
                            if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                                //Create a new message of tyoe Message
                                let newMessage = Message(sender: messageSender, body: messageBody)
                                //Add the message to the message array
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    //Reload data again
                                    self.tableView.reloadData() //reloadData() trigger the 2 delegates methods (in the extension below)
                                    
                                    //Scroll down to the last message
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        //Check if body and sender are not nil
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            
            db.collection(K.FStore.collectionName).addDocument(data: [
                //Message properties
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                //Check if there was any error
                if let e = error {
                    print("There was an issue saving data to Firestore. \(e)")
                } else { //If there was not error
                    print("Successfully saved data.")
                    
                    DispatchQueue.main.async { //To run this on the main thread rather than on the background thread
                        self.messageTextfield.text = ""  //Clear text field
                    }
                }
            }
        }
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true) //Jump directly to root (WelcomeViewController)
            
        } catch let signOutError as NSError { //Catch error if there was any problem signing out
            print ("Error signing out: %@", signOutError)
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    //Cast the cell to a MessageCell class with as! so then we can use the label (UILabel)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body //It takes the body of every element in message array
        
        //Check if message is from the curren user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else { //If message is from another sender
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        
        
        return cell
    }
}
