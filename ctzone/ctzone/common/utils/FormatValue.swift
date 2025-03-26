//
//  FormatValue.swift
//  ctzone
//
//  Created by Ali An Nuur on 25/03/25.
//

import Foundation

func formattedTime(is24HourFormat : Bool, selectedHour: Int, selectedMinute: Int) -> (hourMinute: String, amPm: String?) {
    let hour24 = selectedHour
    let hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12
    let minute = String(format: "%02d", selectedMinute)

    let period = hour24 < 12 ? "AM" : "PM"
    
    if is24HourFormat {
        return ("\(String(format: "%02d", hour24)):\(minute)", nil)
    } else {
        return ("\(String(format: "%02d", hour12)):\(minute)", period)
    }
    
}

func formattedDate(selectedDay : Int, selectedMonth : Int, selectedYear : Int) -> String {
    return "\(selectedDay)-\(selectedMonth)-\(selectedYear)"
}

