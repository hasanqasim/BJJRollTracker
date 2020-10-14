//
//  SettingsViewController.swift
//  BJJRollTracker
//
//  Created by Hasan Qasim on 19/9/20.
//  Copyright © 2020 Hasan Qasim. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var roundsLabel: UILabel!
    @IBOutlet weak var roundsSlider: UISlider!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerSlider: UISlider!
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var restSlider: UISlider!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var warningSlider: UISlider!
    
    @IBOutlet weak var subview: UIView!
    var roundValue = 0
    var timerValue = 0
    var restValue = 0
    var warningValue = 0
    
    var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.setHidesBackButton(true, animated: true);
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        subview.backgroundColor = .black
        
        roundValue = Int(roundsSlider.value)
        timerValue = Int(timerSlider.value)
        restValue = Int(restSlider.value)
        warningValue = Int(warningSlider.value)*5
    }
    
    @IBAction func DoneButtonTapped(_ sender: Any) {
        let currentRoll = RollSetting(numberOfRounds: roundValue, roundTime: timerValue, restTime: restValue, warningTime: warningValue)
        delegate?.didSelectRollSetting(rollSetting: currentRoll)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func roundsSliderMoved(_ sender: UISlider) {
        roundValue = Int(sender.value)
        roundsLabel.text = "Number of rounds  \(roundValue)"
    }
    @IBAction func timerSliderMoved(_ sender: UISlider) {
        timerValue = Int(sender.value)
        timerLabel.text = "Round Time  \(timerValue):00"
    }
    @IBAction func restSliderMoved(_ sender: UISlider) {
        restValue = Int(sender.value)
        restLabel.text = "Rest Time  \(restValue):00"
    }
    @IBAction func warningSliderMoved(_ sender: UISlider) {
        warningValue = Int(sender.value)*5
        warningLabel.text = warningValue == 5 ? "Warning Time  :0\(warningValue)": "Warning Time  :\(warningValue)"
    }
}
