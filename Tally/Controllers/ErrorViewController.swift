//
//  ViewController.swift
//  Tally
//
//  Created by Daniel Schultz on 3/22/15.
//  Copyright (c) 2015 Gender Avenger. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {
    
    @IBAction func tryAgainButtonHandler() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }    
}

