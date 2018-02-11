//
//  ViewController.swift
//  Set
//
//  Created by Yuki Orikasa on 2018/01/29.
//  Copyright © 2018 Yuki Orikasa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //    MARK: - Instance Variables
    
    let figures = ["●", "▲", "■"]
    
    //    MARK: - Outlets

    @IBOutlet var cardButtons: [UIButton]!
    
    //    MARK: - Actions
    
    @IBAction func selectCard(_ sender: UIButton) {
        
    }
    
    
    //    MARK: - etc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

