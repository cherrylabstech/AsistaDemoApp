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

    
    /// Shows the knowledge base page from asista
    @IBAction func kbButtonTapped(_ sender: UIButton) {
        AsistaUI.showKnowledgeBase(on: self)
    }
    
    /// Shows Asset list page
    @IBAction func assetButtonTapped(_ sender: UIButton) {
        AsistaUI.showAssets(on: self)
    }
    
    /// Shows Users ticket list page
    @IBAction func myTicketButtonTapped(_ sender: UIButton) {
        AsistaUI.showUserTickets(on: self)
    }
    
    /// Shows Asset list 
    @IBAction func createTicketButtonTapped(_ sender: UIButton) {
        AsistaUI.showTicketCreation(on: self)
    }
}

