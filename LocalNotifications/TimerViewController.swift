//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Najd Alsughaiyer on 04/01/2022.
//

import UIKit

class TimerViewController: UIViewController {

    var totalHours = 0
    var totalmins = 0
    var log = [(String, String)]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var timerPicker: UIDatePicker!
    @IBOutlet weak var untilLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    
    @IBAction func timerButtonPressed(_ sender: UIButton) {
        let hoursMins = TimeHandler.convertToHourMin(mins: Int(timerPicker.countDownDuration/60))
        // if tag == 0 -> the button is labeled "Start Timer"
        // if tag == 1 -> the button is labeled "Cancel Timer"
        if sender.tag == 0 {
            sender.tag = 1
            sender.setTitle("Cancel Timer", for: .normal)
            sender.backgroundColor = UIColor.systemRed
            handleTimer(with: hoursMins, isEnable: true)
        } else if sender.tag == 1 {
            sender.tag = 0
            sender.setTitle("Start Timer", for: .normal)
            sender.backgroundColor = UIColor.systemGreen
            handleTimer(with: hoursMins, isEnable: false)
        }
    }

    @IBAction func newDayButtonPressed(_ sender: UIButton) {
        // show alert
        log.removeAll()
        if timerButton.tag == 1 {
            timerButton.tag = 0
            timerButton.setTitle("Start Timer", for: .normal)
            timerButton.backgroundColor = UIColor.systemGreen
            handleTimer(with: (totalHours, totalmins), isEnable: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let barViewControllers = tabBarController?.viewControllers
        let lvc = barViewControllers![1] as! LogViewController
        lvc.log = log
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func handleTimer(with hoursMins: (Int, Int), isEnable: Bool) {
        if isEnable {
            totalHours += hoursMins.0
            totalmins += hoursMins.1
            timerPicker.isEnabled = false
            untilLabel.isHidden = false
            titleLabel.text = "Timer set for \(hoursMins.0) hour(s),\(hoursMins.1) mins"
            let workUntil = TimeHandler.addToCurrentTime(hours: hoursMins.0, minutes: hoursMins.1)
            untilLabel.text = "Work until \(workUntil.0):\(workUntil.1)"
            pushToLog(until: workUntil, duration: hoursMins)
        } else {
            totalHours -= hoursMins.0
            totalmins -= hoursMins.1
            timerPicker.isEnabled = true
            untilLabel.isHidden = true
            titleLabel.text = "Set the timer"
            if !log.isEmpty {
                log.removeLast()
            }
        }
        totalLabel.text = "Total time: \(totalHours) hour(s), \(totalmins) minutes"
    }
    
    func pushToLog(until: (Int, Int), duration: (Int, Int)) {
        let currentTime = TimeHandler.getCurrentTime()
        let logTitle = "\(currentTime.0):\(currentTime.1) - \(until.0):\(until.1)"
        let logSubtitle = "\(duration.0) hour(s), \(duration.1) minute(s) timer"
        log.append((logTitle, logSubtitle))
    }

}

