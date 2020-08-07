//
//  SettingsViewController.swift
//  Pensamentos
//
//  Created by Douglas Hennrich on 03/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: Properties
    let config = Configuration.shared
    
    // MARK: IBOutlets
    @IBOutlet weak var autorefreshSwitcher: UISwitch!
    
    @IBOutlet weak var timeIntervalSlider: UISlider!
    
    @IBOutlet weak var colorSchemaSegmentController: UISegmentedControl!
    
    @IBOutlet weak var timeIntervalLabel: UILabel!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default
            .addObserver(forName: NSNotification.Name(rawValue: "Refresh"),
                         object: nil,
                         queue: nil) { [weak self] _ in
                            self?.formatView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatView()
    }
    
    // MARK: IBActions
    @IBAction func changeAutoRefresh(_ sender: UISwitch) {
        config.autorefresh = sender.isOn
    }
    
    @IBAction func changeTimeInterval(_ sender: UISlider) {
        let value = Double(round(sender.value))
        config.timeInterval = value
        changeTimeIntervalLabel(with: value)
    }
    
    @IBAction func changeColorSchema(_ sender: UISegmentedControl) {
        config.colorScheme = sender.selectedSegmentIndex
    }
    
    // MARK: Actions
    func formatView() {
        autorefreshSwitcher.setOn(config.autorefresh, animated: false)
        timeIntervalSlider.setValue(Float(config.timeInterval), animated: false)
        colorSchemaSegmentController.selectedSegmentIndex = config.colorScheme
        changeTimeIntervalLabel(with: config.timeInterval)
    }
    
    func changeTimeIntervalLabel(with value: Double) {
        timeIntervalLabel.text = "Mudar após \(Int(value)) segundos"
    }
    
}
