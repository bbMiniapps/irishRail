//
//  AdditionalServerDataLogic.swift
//  IrishRail
//
//  Created by Boris Hristov on 30.07.20.
//  Copyright © 2020 bh. All rights reserved.
//

import Foundation

struct AdditionalServerDataLogic {
    
    func dateBy(_ date: Date?, _ hourMinutesSeconds: (String, String, String), _ valueAfterDot: String) -> Date? {
        guard let components = date?.get(.day, .month, .year),
            let year = components.year,
            let month = components.month,
            let day = components.day else {
                
            return nil
        }
        
        let yearStr = "\(year)"
        var monthStr = "\(month)"
        if monthStr.count == 1 {
            monthStr = "0\(monthStr)"
        }
        var dayStr = "\(day)"
        if dayStr.count == 1 {
            dayStr = "0\(dayStr)"
        }
        
        let dPF: () -> (String, String, String, String, String, String, String) = {
            (yearStr,
            monthStr,
            dayStr,
            hourMinutesSeconds.0,
            hourMinutesSeconds.1,
            hourMinutesSeconds.2,
            valueAfterDot)
        }
        let result = Date.dateISO8601From(dPF)
        
        return result
    }
    
    func late(_ startDate: Date, _ endDate: Date) -> Int {
        let diffComponents = Calendar.current.dateComponents([.minute], from: startDate, to: endDate)
        let minutes = diffComponents.minute
        
        return minutes ?? 0
    }
    
}
