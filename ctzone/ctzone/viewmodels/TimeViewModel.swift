//
//  TimeViewModel.swift
//  ctzone
//
//  Created by Ali An Nuur on 25/03/25.
//

import Foundation
import Combine

class TimeViewModel: ObservableObject {
    @Published var currentDate: Date = Date()
    private var timer: AnyCancellable?
    
    init(updateInterval: TimeInterval = 60) { 
        timer = Timer.publish(every: updateInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] date in
                self?.currentDate = date
            }
    }
}
