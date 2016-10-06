//
//  SettingsVC.swift
//  period-flow
//
//  Created by Antonija on 26/09/2016.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import Foundation
import SwiftDate

class SettingsVC: UIViewController {

    // MARK: - Outlets
    // Stacks
    
    // Pickers
    @IBOutlet weak var cycleDurationPicker: UIPickerView!
    @IBOutlet weak var reminderPicker: UIPickerView!
    @IBOutlet weak var baseAnalysisPicker: UIPickerView!
    
    // Buttons
    @IBOutlet weak var cycleDurationButton: UIButton!
    @IBOutlet weak var reminderButton: UIButton!
    @IBOutlet weak var baseAnalysisButton: UIButton!
    
    // MARK: - Properties
    let tempArray = ["One", "Two", "Three", "Four", "Five", "Six"]
    let tempArray2 = ["1", "2", "3", "4", "5", "6"]
    let tempArray3 = ["Lorem", "Ipsum", "Dolor", "Sit", "Amet"]
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        cycleDurationPicker.delegate = self
        prepareUI()
    }
    
    // MARK: Methods
    
    func prepareUI() {
        cycleDurationPicker.isHidden = true
        reminderPicker.isHidden = true
        baseAnalysisPicker.isHidden = true
        
        cycleDurationButton.setTitle("\(DefaultsManager.getCycleDays())", for: .normal)
    }
    
    func selectPicker(picker: UIPickerView) {
        switch picker {
        case cycleDurationPicker:
            cycleDurationPicker.isHidden = false
            cycleDurationPicker.delegate = self
            reminderPicker.isHidden = true
            baseAnalysisPicker.isHidden = true
        case reminderPicker:
            reminderPicker.isHidden = false
            reminderPicker.delegate = self
            cycleDurationPicker.isHidden = true
            baseAnalysisPicker.isHidden = true
        case baseAnalysisPicker:
            baseAnalysisPicker.isHidden = false
            baseAnalysisPicker.delegate = self
            cycleDurationPicker.isHidden = true
            reminderPicker.isHidden = true
        default:
            cycleDurationPicker.isHidden = true
            reminderPicker.isHidden = true
            baseAnalysisPicker.isHidden = true
        }
    }

    @IBAction func cycleDurationButtonPressed(_ sender: AnyObject) {
        selectPicker(picker: cycleDurationPicker)
    }
    
    @IBAction func reminderButtonPressed(_ sender: AnyObject) {
        selectPicker(picker: reminderPicker)
    }
    
    @IBAction func baseAnalysisButtonPressed(_ sender: AnyObject) {
        selectPicker(picker: baseAnalysisPicker)
    }
}

// Picker Functionality
extension SettingsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case cycleDurationPicker:
            let days = (1...100).map { $0 }
            return days.count
        case reminderPicker:
            return tempArray2.count
        case baseAnalysisPicker:
            return tempArray3.count
        default:
            return tempArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case cycleDurationPicker:
            let days = (1...100).map { String($0) }
            return days[row]
        case reminderPicker:
            return tempArray2[row]
        case baseAnalysisPicker:
            return tempArray3[row]
        default:
            return tempArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case cycleDurationPicker:
            let days = (1...100).map { String($0) }
            cycleDurationButton.setTitle(days[row], for: .normal)
            cycleDurationPicker.isHidden = true
            DefaultsManager.setCycleDays(row + 1)
        case reminderPicker:
            reminderButton.setTitle(tempArray2[row], for: .normal)
            reminderPicker.isHidden = true
        case baseAnalysisPicker:
            baseAnalysisButton.setTitle(tempArray3[row], for: .normal)
            baseAnalysisPicker.isHidden = true
        default:
            print("Default")
        }
    }
}
