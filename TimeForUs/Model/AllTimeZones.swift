//
//  TimeZoneBrain.swift
//  TimeForUs
//
//  Created by Cameo Sameshima on 2023-02-20.
//

import Foundation
import CoreData

struct AllTimeZones {
    var timeZones = [Item]()
    let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    init(){
        for loc in TimeZone.knownTimeZoneIdentifiers {
            let clean_location = loc.replacingOccurrences(of: "_", with: " ").components(separatedBy: "/")
            if let city = clean_location.last, let region = clean_location.first {
                let abv = TimeZone(identifier: loc)!.abbreviation()! as String
                let name = "\(city), \(region) (\(abv))"
                let newTimeZone = Item(context: childContext)
                newTimeZone.location = String(loc)
                newTimeZone.name = name
                timeZones.append(newTimeZone)
            }
        }
    }
    
    func getTimeZones() -> [Item] {
        return timeZones
    }
    
}

