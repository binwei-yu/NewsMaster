//
//  ViewController.swift
//  NewsMaster
//
//  Created by Vincent Yu on 2/15/19.
//  Copyright © 2019 Vincent Yu. All rights reserved.
//

import UIKit

class ViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.preferredDisplayMode = .allVisible
    }
    
    /*
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    */
}

