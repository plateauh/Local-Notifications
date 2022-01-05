//
//  TimeConverter.swift
//  LocalNotifications
//
//  Created by Najd Alsughaiyer on 05/01/2022.
//
import UIKit

class TimeHandler {
    
    static func convertToHourMin(mins value: Int) -> (Int, Int) {
        var hours = 0
        var mins = value
        while mins >= 60 {
            hours += 1
            mins -= 60
        }
        return (hours, mins)
    }
    
    static func getCurrentTime() -> (Int, Int) {
        let date = Date() // save date, so all components use the same date
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        return (hour, minute)
    }
    
    static func addToCurrentTime(hours: Int, minutes: Int) -> (Int, Int) {
        let current = getCurrentTime()
        var h = current.0 + hours
        var m = current.1 + minutes
        if h > 23 {
            h -= 24
        }
        if m > 59 {
            m -= 60
            h += 1
        }
        return (h, m)
    }
}
