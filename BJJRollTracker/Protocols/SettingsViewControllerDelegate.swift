//
//  SettingsViewControllerDelegate.swift
//  BJJRollTracker
//
//  Created by Hasan Qasim on 11/10/20.
//  Copyright © 2020 Hasan Qasim. All rights reserved.
//

import Foundation

// higher order fucntion list.forEach
// chekc for retain cycle
protocol SettingsViewControllerDelegate: class {
    func didSelectRollSetting(rollSetting: RollSetting)
}
