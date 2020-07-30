//
//  Date+Extension.swift
//  IrishRail
//
//  Created by Boris Hristov on 30.07.20.
//  Copyright © 2020 bh. All rights reserved.
//

import Foundation

extension Date {
    
    static func dateIrishISO8601String(_ isoDateString: String) -> Date? {
        let df = ISO8601DateFormatter()
        df.timeZone = TimeZone(identifier: "Europe/Dublin") //TimeZone(identifier: "UTC")
        df.formatOptions =  [.withInternetDateTime, .withFractionalSeconds]

        guard let irishDate = df.date(from: isoDateString) else {
            return nil
        }

        return irishDate
    }
    
    static func dateISO8601From(_ dF: () -> (year: String, month: String, day: String, hour: String, minutes: String, seconds: String, valueAfterDot: String)) -> Date? {
        let (year, month, day, hour, minutes, seconds, valueAfterDot) = dF()
        
        let dateString = "\(year)-\(month)-\(day)T\(hour):\(minutes):\(seconds).\(valueAfterDot)"
        let result = Date.dateIrishISO8601String(dateString)
        
        return result
    }
    
    static func dateIrishFrom(_ dF: () -> (String, String)) -> Date? {
        let (dateFormat, dateString) = dF()
        
        let df = DateFormatter()
        df.timeZone = TimeZone(identifier: "UTC")
        df.locale = Locale(identifier: "en_IE")
        df.calendar = Calendar(identifier: .gregorian)
        df.dateFormat = dateFormat
        
        let date = df.date(from: dateString)
        return date
    }
    
    func get(_ components: Calendar.Component...,
        calendar: Calendar = Calendar(identifier: .iso8601)) -> DateComponents {
        var cal = calendar
        cal.timeZone = TimeZone(identifier: "UTC") ?? Calendar.current.timeZone
        
        return cal.dateComponents(Set(components), from: self)
    }
    
    func toSearchString() -> String {
        let df = DateFormatter()
        df.timeZone = TimeZone(identifier: "UTC")
        df.dateFormat = "dd%20MMM%20yyyy"
        let now = df.string(from: self)
        
        return now
    }
    
    func dateToHourMinutes() -> String {
        let df = DateFormatter()
        df.timeZone = TimeZone(identifier: "UTC")
        df.dateFormat = "hh:mm"
        let result = df.string(from: self)

        return result
    }
    
    func irishDate() -> Date {
        let dF = ISO8601DateFormatter()
        dF.timeZone = TimeZone(identifier: "Europe/Dublin") //"Europe/Lisbon"
        dF.formatOptions =  [.withInternetDateTime, .withFractionalSeconds]
        var irishString = dF.string(from: self)
        let firstDateComponent = (irishString.components(separatedBy: ".")).first ?? ""
        irishString = "\(firstDateComponent).000Z"
        let irishDate = dF.date(from: irishString)
        
        return irishDate ?? self
    }
    
    func calendarMenu() -> (String, String, String) {
        let df = DateFormatter()
        df.timeZone = TimeZone(identifier: "UTC")
        df.dateFormat = "E"
        let dayDesc = df.string(from: self)
        
        df.dateFormat = "dd"
        let day = df.string(from: self)
        
        df.dateFormat = "MMM"
        let month = df.string(from: self)
        
        return (dayDesc, day, month)
    }
    
}
