//
//  BaseViewController.swift
//  SilentKill.iOS
//
//  Created by Tim Sneed on 3/10/17.
//  Copyright © 2017 SilentKill. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    lazy var repository: SilentKillRepository = {
        return SilentKillRepository()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
