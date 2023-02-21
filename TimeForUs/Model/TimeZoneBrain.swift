//
//  TimeZoneBrain.swift
//  TimeForUs
//
//  Created by Cameo Sameshima on 2023-02-20.
//

import Foundation

struct TimeZoneBrain {
    var timeZones = [TimeZoneItem]()
    
    init(){
        for location in TimeZone.knownTimeZoneIdentifiers {
            let clean_location = location.replacingOccurrences(of: "_", with: " ").components(separatedBy: "/")
            if let city = clean_location.last, let region = clean_location.first {
                let name = "\(city), \(region)"
                timeZones.append(TimeZoneItem(l: location, n: name))
            }
        }
    }
    
    func getTimeZones() -> [TimeZoneItem] {
        return timeZones
    }
    
}

