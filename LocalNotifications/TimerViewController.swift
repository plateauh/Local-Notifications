//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Najd Alsughaiyer on 04/01/2022.
//  Alert https://stackoverflow.com/a/24022696
//  Passing Data in Tab Bar Controllers https://makeapppie.com/2015/02/04/swift-swift-tutorials-passing-data-in-tab-bar-controllers/
//  Local Notification https://www.youtube.com/watch?v=An-bbfEbX3Y
//  Timer https://www.hackingwithswift.com/articles/117/the-ultimate-guide-to-timer

import UIKit
import UserNotifications

class TimerViewController: UIViewController, UNUserNotificationCenterDelegate {

    let notificationCenter = UNUserNotificationCenter.current()
    var notificationIdentifier = ""
    var totalHours = 0
    var totalmins = 0
    var log = [(String, String)]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var timerPicker: UIDatePicker!
    @IBOutlet weak var untilLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.requestAuthorization(options: [.alert, .sound], completionHandler: {(granted, error) in
        })
        notificationCenter.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        }
    
    @IBAction func timerButtonPressed(_ sender: UIButton) {
        let mins = timerPicker.countDownDuration
        let hoursMins = TimeHandler.convertToHourMin(mins: Int(mins/60))
        var timer = Timer()
        // if tag == 0 -> the button is labeled "Start Timer"
        // if tag == 1 -> the button is labeled "Cancel Timer"
        if sender.tag == 0 {
            enableTimer(with: hoursMins)
            timer = Timer.scheduledTimer(timeInterval: mins, target: self, selector: #selector(resetTimer), userInfo: nil, repeats: false)
            notify(duration: mins)
        } else if sender.tag == 1 {
            cancelTimer(with: hoursMins)
            timer.invalidate()
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [self.notificationIdentifier])
        }
    }

    @IBAction func newDayButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "New Day", message: "Are you sure you want to start a new day? this action will reset your log", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "New Day", style: .destructive, handler: { _ in
            self.log.removeAll()
            self.updateLogRef()
            if self.timerButton.tag == 1 {
                self.cancelTimer(with: (self.totalHours, self.totalmins))
            } else {
                self.totalHours = 0
                self.totalmins = 0
                self.resetTimer()
            }
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alert, animated: true, completion: nil)
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
        untilLabel.text = "Work until \(TimeHandler.toString(time: workUntil))"
        pushToLog(until: workUntil, duration: hoursMins)
    }
    
    func cancelTimer(with hoursMins: (Int, Int)) {
        let alert = UIAlertController(title: "Cancel Timer", message: "Are you sure you want to cancel current timer? its duration will be deducted from total time and will be removed from log", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel Timer", style: .destructive, handler: { _ in
            self.totalHours -= hoursMins.0
            self.totalmins -= hoursMins.1
            self.popFromLog()
            self.resetTimer()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func resetTimer() {
        timerButton.tag = 0
        timerButton.setTitle("Start Timer", for: .normal)
        timerButton.backgroundColor = UIColor.systemGreen
        timerPicker.isEnabled = true
        untilLabel.isHidden = true
        titleLabel.text = "Set the timer"
        totalLabel.text = "Total time: \(self.totalHours) hour(s), \(self.totalmins) minutes"
    }
    
    func pushToLog(until: (Int, Int), duration: (Int, Int)) {
        let currentTime = TimeHandler.getCurrentTime()
        let logTitle = "\(TimeHandler.toString(time: currentTime)) - \(TimeHandler.toString(time: until))"
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
    
    func notify(duration: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Timer's done!"
        content.body = "your timer is done honey"
        // Create the trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: duration, repeats: false)
        // Create the request
        notificationIdentifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationIdentifier,
                    content: content, trigger: trigger)
        // Schedule the request with the system.
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
               print(error ?? "Error in notification")
           }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

}

