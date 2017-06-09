//
//  SettingTVC.swift
//  PokedexApp
//
//  Created by Dara on 4/16/17.
//  Copyright © 2017 iDara09. All rights reserved.
//

import UIKit
import AVFoundation

enum Unit: Int {
    case USCustomary
    case SI
}

enum SettingRow: String {
    case measurementUnit = "00"
    case section10 = "10"
    case section11 = "11"
    case iDara09GitHub = "20"
    case sourceCode = "21"
    case disclaimer = "22"
    case credits = "23"
}

// TODO: - remove hard code links and revampe viewLauncher

class SettingTVC: UITableViewController {
    
    @IBOutlet weak var measurementSC: UISegmentedControl!
    @IBOutlet weak var soundEffectSwitch: UISwitch!
    
    var viewLauncher: ViewLauncher?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSettingFromUserDefaults()
        configureViewLauncher()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewLauncher?.dismiss()
        viewLauncher?.removeFromSuperview()
        audioPlayer.play(audio: AVAudioPlayer.ResourceAudioFile.save)
    }

    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let selectedRow = SettingRow(rawValue: "\(indexPath.section)\(indexPath.row)") {
            
            switch selectedRow {
                
            case .iDara09GitHub:
                if let url = URL(string: "https://github.com/iDara09") {
                    UIApplication.shared.open(url)
                }
                
            case .sourceCode:
                if let url = URL(string: "https://github.com/iDara09/PokedexApp") {
                    UIApplication.shared.open(url)
                }
                
            case.disclaimer:
                audioPlayer.play(audio: .select)
                let text = "Disclaimer:\n● This is for practice and learning purposes only.\n● All contents, arts, assets, and data belong to their respective owners."
                
                if let textView = viewLauncher?.makeTextView(withText: text) {
                    viewLauncher?.addSubview(textView)
                    viewLauncher?.launch()
                }
                
            case .credits:
                audioPlayer.play(audio: .select)
                let text = "Data Resources:\n● Bulbapedia\n● PokemonDB\n● Official Pokemon Site\n● Phasma\n● Veekun"
                
                if let textView = viewLauncher?.makeTextView(withText: text) {
                    viewLauncher?.addSubview(textView)
                    viewLauncher?.launch()
                }
                
            default: ()
            }
        }
    }
    
    
    
    
    // MARK: - IBActions
    
    @IBAction func measurementSCValueChanged(_ sender: UISegmentedControl) {
        
        UserDefaults.standard.set(measurementSC.selectedSegmentIndex, forKey: Constant.Key.Setting.measurementSCSelectedIndex)
    }
    
    @IBAction func soundEffectSwitchToggled(_ sender: UISwitch) {
        
        UserDefaults.standard.set(sender.isOn, forKey: Constant.Key.Setting.soundEffectSwitchState)
        if sender.isOn { audioPlayer.play(audio: .select) }
    }
    
    
    
    
    // MARK: - Initializer and Handler
    
    func loadSettingFromUserDefaults() {
        
        measurementSC.selectedSegmentIndex = UserDefaults.standard.integer(forKey: Constant.Key.Setting.measurementSCSelectedIndex)
        soundEffectSwitch.isOn = UserDefaults.standard.bool(forKey: Constant.Key.Setting.soundEffectSwitchState)
    }
    
    func configureViewLauncher() {
        
        viewLauncher = ViewLauncher(swipeToDismissDirection: .right)
        
        if let window = UIApplication.shared.keyWindow {
            viewLauncher?.setSuperview(window)
        }
    }
}
