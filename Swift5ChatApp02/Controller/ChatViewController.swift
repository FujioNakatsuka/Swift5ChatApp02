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
        
        //Viewが出た時にFirebaseからデータをfetchする（取得）
        fetchChatData()
        
        tableView.separatorStyle = .none
        
        
    }
    
   //引数としてNSNotificationを取れる。メソッド復習✨
    //🌷messageTextField.becomeFirstResponder()はなぜ必要がないのか？
    @objc func keyboardWillShow(_ notification:NSNotification){
        
    let keyboardHeight = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey]as Any) as AnyObject).cgRectValue.height
    
    messageTextField.frame.origin.y = screenSize.height-keyboardHeight-messageTextField.frame.height

        
        
    }
    
    @objc func keyboardWillHide(_ notification:NSNotification){
        
        messageTextField.frame.origin.y = screenSize.height - messageTextField.frame.height

//🌷guard[,]はなぜ打つのかguradからCGreactValue/Timeintervalが並列で繋がっていて、それぞれの値を取得しに行っている？

        guard let rect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else{return}
      
        UIView.animate(withDuration: duration){
            
            let transform = CGAffineTransform(translationX: 0, y:0)
            self.view.transform = transform
            
        }
  
    }
    //🌷UITouchをした時にイベントを発生する関数をfunc touchesBeganと設定して、resignFirstResponderという動作を起こす
    override func touchesBegan(_ toouches: Set<UITouch>, with event: UIEvent?){
            
            messageTextField.resignFirstResponder()
                  
        }
        //🌷textFieldShouldReturnはreturnキーが押された時に呼ばれるメソッドでブール値で動作をするかしないかが決まる。
        func textFieldShouldReturn(_ textField: UITextField) -> Bool{
            
            textField.resignFirstResponder()
            
            return true
        
    }
        
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        //メッセージの数
        return chatArray.count
  
    
    }
  
    func numberOfSections(in tableview: UITableView) -> Int {
              
              return 1
              
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        
        cell.messageLabel.text = chatArray[indexPath.row].message
        if (cell.messageLabel.text != nil) {print("OK")}
    
        
        
  
        cell.userNameLabel.text = chatArray[indexPath.row].sender
        cell.iconImageView.image = UIImage(named: "dogAvatarImage")
        
        if cell.userNameLabel.text == Auth.auth().currentUser!.email as! String{
            
            cell.messageLabel.backgroundColor = UIColor.flatGreen()
            cell.messageLabel.layer.cornerRadius = 20
            cell.messageLabel.layer.masksToBounds = true
        
        }else{
            
            cell.messageLabel.backgroundColor = UIColor.flatBlue()
            cell.messageLabel.layer.cornerRadius = 20
            cell.messageLabel.layer.masksToBounds = true
            
        }
        
        
        
        
        return cell
        
        
      }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          
          return 100
          
      }


    @IBAction func sendAction(_ sender: Any) {
        messageTextField.endEditing(true)
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        
        
        if messageTextField.text!.count > 15{
                       
                   print("15文字以上になりました。")
                   
                   return
     
            
    }
    
        
        let chatDB = Database.database().reference().child("chats")
        
        //キーバリュー型で内容を送信（Dictionary型）
        let messageInfo = ["sender":Auth.auth().currentUser?.email,"message":messageTextField.text!]
        
        //chatDBに入れる
        chatDB.childByAutoId().setValue(messageInfo) { (error, result) in
             
             if error != nil{
                print(error!)
                 
             }else{
                 
                 print("送信完了！！")
                 self.messageTextField.isEnabled = true
                 self.sendButton.isEnabled = true
                 self.messageTextField.text = ""
                 
                 
                 
             }
             
             
         }
  
 }
                    //データを引っ張ってくる
                    func fetchChatData(){
            //🌷FireBaseの書き方か？「どこからデータを引っ張ってくるのか」
                        let fetchDataRef = Database.database().reference().child("chats")
                        
                        //新しく更新があった時だけ取得したい。新しいデータはsnapShotに入ってくる
                        fetchDataRef.observe(.childAdded){(snapShot) in
                            let snapShotData = snapShot.value as AnyObject
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
