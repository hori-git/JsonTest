//
//  ViewController.swift
//  JsonTest
//
//  Created by 堀川慧介 on 2020/05/02.
//  Copyright © 2020 堀川慧介. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //表示用の文言
    var text = "default"
    
    //タプル配列の宣言
    var studentList:[(id:String , name:String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func getJson(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goResultVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //リクエストURL
        guard let req_url = URL(string: "http://localhost:8080/servlet_test/JsonServlet")
            else{return}
        
        //リクエストに必要な情報を生成
        let req = URLRequest(url: req_url)
        //データ転送を管理するためのセッションを作成
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //リクエストをタスクとして登録
        let task = session.dataTask(with: req, completionHandler: {
            (data, response ,error) in
            //セッションの終了
            session.finishTasksAndInvalidate()
            
            do{
                let decoder = JSONDecoder()
                let json = try decoder.decode([StudentJson].self, from: data!)
                
                
                //let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                
                //print(json)
                
                for index in 0..<json.count {
                if let id = json[index].id , let name = json[index].name{
                   let student = (id,name)
                    self.studentList.append(student)
                }
                }


                print(self.studentList)
                self.text = self.studentList[0].name
                
                
                if segue.identifier == "goResultVC" {
                           let nextVC = segue.destination as! ResultViewVontroller
                    nextVC.json = self.text
                }
                
            }catch{
                print(error)
                print("エラーがでました")
            }
           
            
            
        })
        
        //ダウンロード開始
        task.resume()
        
    }
    
    //JSONのデータ構造
    struct  StudentJson: Codable {
        let id: String?
        let name: String?
    }
    
    struct  ResultJson: Codable {
        //複数要素
        let student:[StudentJson]
    }
    
    
}

