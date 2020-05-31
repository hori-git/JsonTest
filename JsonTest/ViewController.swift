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
    var textId = ""
    var textName = ""
    
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
        
        //リクエストURL　JSONを返すサーブレットを指定
//        guard let req_url = URL(string: "http://localhost:8080/servlet_test/JsonServlet")
//            else{return}
        guard let req_url = URL(string: "http://ec2-18-181-216-48.ap-northeast-1.compute.amazonaws.com:8080/servlet_test/JsonServlet")
        else{return}
        
        //リクエストに必要な情報を生成
        var req = URLRequest(url: req_url)
        
        //0~2のランダムな数値を取得
        let id = Int.random(in: 1...3)
        //データ転送を管理するためのセッションを作成
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //JavaServletへ渡す情報（ID）をBodyへ設定する
        req.httpMethod = "POST"
        req.httpBody = "id=\(id)".data(using: .utf8)
        //リクエストをタスクとして登録
        let task = session.dataTask(with: req, completionHandler: {
            (data, response ,error) in
            //セッションの終了
            session.finishTasksAndInvalidate()
            
            do{
                //取得したJSONを変換する
                let decoder = JSONDecoder()
                let json = try decoder.decode(StudentJson.self, from: data!)

                print(json)
                self.textId = json.id!
                self.textName = json.name!
                
                if segue.identifier == "goResultVC" {
                    let nextVC = segue.destination as! ResultViewVontroller
                    nextVC.jsonId = self.textId
                    nextVC.jsonName = self.textName
                    nextVC.viewDidLoad()
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

