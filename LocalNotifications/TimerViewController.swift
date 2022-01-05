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
            enableTimer(with: hoursMins)
        } else if sender.tag == 1 {
            disableTimer(with: hoursMins)
        }
    }

    @IBAction func newDayButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "New Day", message: "Are you sure you want to start a new day? this action will reset your log", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "new day", style: .destructive, handler: { _ in
            self.log.removeAll()
            if self.timerButton.tag == 1 {
                self.disableTimer(with: (self.totalHours, self.totalmins))
            }
        }))
        alert.addAction(UIAlertAction(title: "dismiss", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func enableTimer(with hoursMins: (Int, Int)) {
        timerButton.tag = 1
        timerButton.setTitle("Cancel Timer", for: .normal)
        timerButton.backgroundColor = UIColor.systemRed
        totalHours += hoursMins.0
        totalmins += hoursMins.1
        timerPicker.isEnabled = false
        untilLabel.isHidden = false
        titleLabel.text = "Timer set for \(hoursMins.0) hour(s),\(hoursMins.1) mins"
        let workUntil = TimeHandler.addToCurrentTime(hours: hoursMins.0, minutes: hoursMins.1)
        totalLabel.text = "Total time: \(totalHours) hour(s), \(totalmins) minutes"
        untilLabel.text = "Work until \(workUntil.0):\(workUntil.1)"
        pushToLog(until: workUntil, duration: hoursMins)
    }
    
    func disableTimer(with hoursMins: (Int, Int)) {
        let alert = UIAlertController(title: "Cancel Timer", message: "Are you sure you want to cancel current timer? its duration will be deducted from total time and will be removed from log", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel timer", style: .destructive, handler: { _ in
            self.timerButton.tag = 0
            self.timerButton.setTitle("Start Timer", for: .normal)
            self.timerButton.backgroundColor = UIColor.systemGreen
            self.totalHours -= hoursMins.0
            self.totalmins -= hoursMins.1
            self.timerPicker.isEnabled = true
            self.untilLabel.isHidden = true
            self.titleLabel.text = "Set the timer"
            self.totalLabel.text = "Total time: \(self.totalHours) hour(s), \(self.totalmins) minutes"
            self.popFromLog()
        }))
        alert.addAction(UIAlertAction(title: "dismiss", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func pushToLog(until: (Int, Int), duration: (Int, Int)) {
        let currentTime = TimeHandler.getCurrentTime()
        let logTitle = "\(currentTime.0):\(currentTime.1) - \(until.0):\(until.1)"
        let logSubtitle = "\(duration.0) hour(s), \(duration.1) minute(s) timer"
        log.append((logTitle, logSubtitle))
        updateLogRef()
    }
    
    func popFromLog() {
        if !log.isEmpty {
            log.removeLast()
        }
        updateLogRef()
    }
    
    func updateLogRef() {
        let barViewControllers = tabBarController?.viewControllers
        let lvc = barViewControllers![1] as! LogViewController
        lvc.log = log
    }

}

