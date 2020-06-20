//
//  SettingsViewController.swift
//  Flickr
//
//  Created by Евгений Холкин on 09.06.2020.
//  Copyright © 2020 Евгений Холкин. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    weak var delegate: SettingsViewDelegate?
    
//MARK: - Outlets
    
    @IBAction func saveSettingsButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.refreshData()
    }
    
    @IBOutlet weak var setSortingControl: UISegmentedControl!
    @IBAction func setSortingControl(_ sender: UISegmentedControl) {

        if (setSortingControl.selectedSegmentIndex == 0)
        {
            UserDefaults.standard.set(0, forKey: "Sorting")
        }
        else if (setSortingControl.selectedSegmentIndex == 1)
        {
            UserDefaults.standard.set(1, forKey: "Sorting")
        }
        
    }
    
//MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.register(defaults: ["Sorting" : 0])
        setSortingControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "Sorting")
    }
}

//MARK: - Protocols

protocol SettingsViewDelegate: class {
     func refreshData()
}
