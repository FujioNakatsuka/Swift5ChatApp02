//
//  ChatViewController.swift
//  Swift5ChatApp02
//
//  Created by 中塚富士雄 on 2020/08/05.
//  Copyright © 2020 中塚富士雄. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    //スクリーンのサイズを取得
        let screenSize = UIScreen.main.bounds.size
    
    var chatArray = [Message]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        messageTextField.delegate = self
        
        
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableView.automaticDimension
        //可変サイズ
        tableView.estimatedRowHeight = 70
        
        //キーボード
        NotificationCenter.default.addObserver(self, selector:  #selector(ChatViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector:  #selector(ChatViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Firebaseからデータをfetchする（取得）
        fetchChatData()
        
        tableView.separatorStyle = .none
        
        
    }
    
   @objc func keyboardWillShow(_ notification:NSNotification){
        
    let keyboardHeight = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey]as Any) as AnyObject).cgRectValue.height
    
    messageTextField.frame.origin.y = screenSize.height-keyboardHeight-messageTextField.frame.height
    
    }
    @objc func keyboardWillHide(_ notification:NSNotification){
        
        messageTextField.frame.origin.y = screenSize.height - messageTextField.frame.height
   
//⭐️guard [,]で繋げるのか？
        
        //guard let rect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
//
//        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]as? TimeInterval else{return}
        
        guard let rect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else{return}
      
        UIView.animate(withDuration: duration){
            
            let transform = CGAffineTransform(translationX: 0, y:0)
            self.view.transform = transform
            
        }
    
        func touchesBegan(_ toouches: Set<UITouch>, with event: UIEvent){
            messageTextField.resignFirstResponder()
                  
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool{
            textField.resignFirstResponder()
            return true
        }
        
        
        func numberOfSections(in tableview: UITableView) -> Int {
            
            return 1
            
        }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       //メッセージの数
        return chatArray.count
        }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        cell.messageLabel.text = chatArray[indexPath.row].message
        cell.userNameLabel.text = chatArray[indexPath.row].sender
        cell.iconImageView.image = UIImage(named: "dogAvatarImage")
        
        if cell.userNameLabel.text == Auth.auth().currentUser?.email as! String{
            
            cell.messageLabel.backgroundColor = UIColor.flatGreen()
            
        }else{
            
            cell.messageLabel.backgroundColor = UIColor.flatBlue()
        }
        
        
        
        
        return cell
        
        
      }

}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          <#code#>
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          <#code#>
      }


    @IBAction func sendAction(_ sender: Any) {
        messageTextField.endEditing(true)
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        let chatDB = Database.database().reference().child("chats")
        
        //キーバリュー型で内容を送信（Dictionary型）
        let messageInfo = ["sender":Auth.auth().currentUser?.email,"message":messageTextField.text!]
        
        //chatDBに入れる
        
        
        
        
        

            }
                    //データを引っ張ってくる
                    func fetchChatData(){
            //⭐️FireBaseの書き方か？「どこからデータを引っ張ってくるのか」
                        let fetchDataRef = Database.database().reference().child("chats")
                        
                        //新しく更新があった時だけ取得したい。新しいデータはsnapShotに入ってくる
                        fetchDataRef.observe(.childAdded){(snapShot) in
                            let snapShotData = snapShot.value as! AnyObject
                            let text = snapShotData.value(forKey: "message")
                            let sender = snapShotData.value(forKey: "sender")
                            
                            let message = Message()
                            message.message = text as! String
                            message.sender = sender as! String
                            self.chatArray.append(message)
                            self.tableView.reloadData()
                            
            
            
        }
   
    }

}
