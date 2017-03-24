//
//  MainViewController.swift
//  SilentKill.iOS
//
//  Created by Tim Sneed on 3/10/17.
//  Copyright © 2017 SilentKill. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.repository.getUserGames { (rounds) in
            
        }
    }
}
