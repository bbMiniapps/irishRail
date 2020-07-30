//
//  String+Extension.swift
//  IrishRail
//
//  Created by Boris Hristov on 30.07.20.
//  Copyright © 2020 bh. All rights reserved.
//

import Foundation

extension String {
    
    func hourAndMinutes() -> (String, String)? {
        let elements = self.components(separatedBy: ":")
        guard elements.count == 2,
            let hour = elements.first,
            let minutes = elements.last else {
            return nil
        }
        
        return (hour, minutes)
    }
    
    func hourMinutesAndSeconds() -> (hour: String, minutes: String, seconds: String)? {
        let elements = self.components(separatedBy: ":")
        guard elements.count >= 3 else {
                return nil
        }
        
        let hour = elements[0]
        let minutes = elements[1]
        let seconds = elements[2]
        
        return (hour, minutes, seconds)
    }
    
}
