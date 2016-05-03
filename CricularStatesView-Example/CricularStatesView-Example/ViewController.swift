//
//  ViewController.swift
//  CricularStatesView-Example
//
//  Created by Or Elmaliah on 01/05/2016.
//  Copyright © 2016 Or Elmaliah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var statesView: CircularStatesView!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.statesView.dataSource = self
    }
}

extension ViewController: CircularStatesViewDataSource {
    
    func cricularStatesView(cricularStatesView: CircularStatesView, titleForStateAtIndex index: Int) -> String? {
        switch index {
        case 0:
            return "Awaiting Approval"
        case 1:
            return "Packaging"
        case 2:
            return "On My Way"
        case 3:
            return "Delivered"
        default:
            return ""
        }
    }
    
    func cricularStatesView(cricularStatesView: CircularStatesView, imageIconForActiveStateAtIndex index: Int) -> UIImage? {
        switch index {
        case 0:
            return UIImage(named: "state_approval_on")
        case 1:
            return UIImage(named: "state_in_progress_on")
        case 2:
            return UIImage(named: "state_otw_on")
        case 3:
            return UIImage(named: "state_deliverd_on")
        default:
            return UIImage()
        }
    }
    
    func cricularStatesView(cricularStatesView: CircularStatesView, imageIconForInActiveStateAtIndex index: Int) -> UIImage? {
        return UIImage()
    }
}
