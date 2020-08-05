//
//  RegisterViewController.swift
//  Swift5ChatApp02
//
//  Created by 中塚富士雄 on 2020/08/05.
//  Copyright © 2020 中塚富士雄. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    let animationView = AnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//firebaseにユーザーを登録する
    @IBAction func registerNewUser(_ sender: Any) {
        
    //アニメーションのスタート
        
        //新規登録
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil{
               print(error as Any)
            }else{
               print("ユーザー登録OKです！")
             //アニメーションのストップ
                self.stopAnimatiom()
                //⭐️関数の中に関数があるので自分自身のクラスにあるメソッドであることを明示する？
                
                
             //Chat画面に遷移
                self.performSegue(withIdentifier: "chat", sender: nil)
            }
            
        }
 
    }
 
    func startAnimation() {
     
        let animation = Animation.named("loading")
        animationView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height/1.5)
        
        animationView.animation = animation
        //⭐️animationView（クラス）.animation（プロパティ）？
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    
    }
    
    func stopAnimatiom(){
        animationView.removeFromSuperview()
    }
    
}
