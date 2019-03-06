//
//  ViewController.swift
//  AsistaUI
//
//  Created by vaisakhcherrylabs on 02/04/2019.
//  Copyright (c) 2019 vaisakhcherrylabs. All rights reserved.
//

import UIKit
import AsistaUI


class MenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func kbButtonTapped(_ sender: UIButton) {
        AsistaUI.showKnowledgeBase(on: self)
    }
    
    @IBAction func assetButtonTapped(_ sender: UIButton) {
        AsistaUI.showAssets(on: self)
    }
    
    @IBAction func myTicketButtonTapped(_ sender: UIButton) {
        AsistaUI.showTicketList(on: self)
    }
    
    @IBAction func createTicketButtonTapped(_ sender: UIButton) {
        AsistaUI.showCreateTicket(on: self)
    }
}

