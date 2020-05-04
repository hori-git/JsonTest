//
//  ResultViewController.swift
//  JsonTest
//
//  Created by 堀川慧介 on 2020/05/02.
//  Copyright © 2020 堀川慧介. All rights reserved.
//

import UIKit

class ResultViewVontroller: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    var json = ""
    
    @IBOutlet weak var resultJson: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        resultJson.text = json
    }
    
}
