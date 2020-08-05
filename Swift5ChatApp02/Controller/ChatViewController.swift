//
//  ChatViewController.swift
//  Swift5ChatApp02
//
//  Created by 中塚富士雄 on 2020/08/05.
//  Copyright © 2020 中塚富士雄. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableView.automaticDimension
        //可変サイズ
        tableView.estimatedRowHeight = 70
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          <#code#>
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          <#code#>
      }

}
