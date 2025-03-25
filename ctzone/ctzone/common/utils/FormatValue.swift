//
//  FormatValue.swift
//  ctzone
//
//  Created by Ali An Nuur on 25/03/25.
//

import Foundation

func formattedTime(is24HourFormat : Bool, selectedHour: Int, selectedMinute: Int) -> (hourMinute: String, amPm: String?) {
    // Misalkan selectedHour adalah jam dalam format 24 jam (contoh: 22 untuk 10 malam)
    let hour24 = selectedHour
    // Konversi ke format 12 jam
    let hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12
    // Pastikan menit selalu dua digit
    let minute = String(format: "%02d", selectedMinute)
    
    // Hitung period berdasarkan selectedHour, bukan variabel isAM yang statis
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
