//
//  ViewController.swift
//  SilentKill.iOS
//
//  Created by Tim Sneed on 3/5/17.
//  Copyright © 2017 SilentKill. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        repository.login(parameters: ["email":"trsneed+silentkill@gmail.com", "password":"testfest"]) { [weak self] (success) in
            if success {
                self?.showMainViewController()
            }
        }
    }

    func showMainViewController(){
        performSegue(withIdentifier: "loggedInSegue", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

