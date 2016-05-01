//
//  ViewController.swift
//  CricularStatesView-Example
//
//  Created by Or Elmaliah on 01/05/2016.
//  Copyright © 2016 Or Elmaliah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = CricularStatesView(frame: self.view.bounds)
        self.view.addSubview(v)
    }
}

