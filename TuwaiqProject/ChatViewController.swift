//
//  ChatViewController.swift
//  TuwaiqProject
//
//  Created by Eth Os on 23/09/1442 AH.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var senderEmail: UILabel!
    
    let db = Firestore.firestore()
    var messages :[Messages] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        messageTableView.delegate = self
        messageTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        db.collection("Messages").order(by: "time").addSnapshotListener{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.messages = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let messageSender = data["sender"] as? String,
                       let messageText = data["text"] as? String{
                        let newMessage = Messages(sender: messageSender, body: messageText)
                        self.messages.append(newMessage)
                        DispatchQueue.main.async {
                            self.messageTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    @IBAction func signOutButtonPressed(_ sender: Any) {
        
    do {
      try Auth.auth().signOut()
        performSegue(withIdentifier: "toFirst", sender: nil)
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
      
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if let messageText = messageTextField.text,
           let messageSender = Auth.auth().currentUser?.email{
            db.collection("Messages").addDocument(data: [
                "sender":messageSender,
                "text":messageText,
                "time": Date().timeIntervalSince1970
            ]){ (error) in
                if let err = error {
                    print(err)
                }else{
                    DispatchQueue.main.async {
                        self.messageTextField.text = ""
                    }
                }
                
            }
        }
        
    }
    
}
extension ChatViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "messageCell") as! MessageCell
        cell.messageLabel.text = messages[indexPath.row].body
        cell.backgroundColor = .clear
        let message = messages[indexPath.row]
        if message.sender == Auth.auth().currentUser?.email{
            cell.getMessageDesign(sender: .me)
        }else{
            cell.getMessageDesign(sender: .other)
        }
        
        return cell
    }
    
}
