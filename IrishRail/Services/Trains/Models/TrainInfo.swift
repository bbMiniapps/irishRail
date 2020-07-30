//
//  TrainInfo.swift
//  IrishRail
//
//  Created by Boris Hristov on 30.07.20.
//  Copyright © 2020 bh. All rights reserved.
//

import Foundation

struct TrainDataModel: PClassName {
    let trainCode: String
    let originStationDesc: String
    let originExpArrival: Date?
    let originSchArrival: Date?
    let originExpDeparture: Date?
    let originSchDeparture: Date?
    let originArrival: Date?
    let originDeparture: Date?
    let destinationStationDesc: String
    let destinationExpArrival: Date?
    let destinationSchArrival: Date?
    let destinationExpDeparture: Date?
    let destinationSchDeparture: Date?
}

struct TrainInfo {
    typealias HoursMinutesSeconds = (hour: String, minutes: String, seconds: String)
    
    let trainCode: String
    let trainDate: Date
    let message: String
    let direction: String
    let latitude: Double
    let longitude: Double
    
    let locationFullName: String
    
    let schArrival: HoursMinutesSeconds
    let schDeparture: HoursMinutesSeconds
    let expArrival: HoursMinutesSeconds
    let expDeparture: HoursMinutesSeconds
    let arrival: HoursMinutesSeconds?
    let departure: HoursMinutesSeconds?
}

final class TrainInfoParser: NSObject {
    static let zeroTimeString = ("00", "00", "00")
    
    private var aspl = AdditionalServerParseLogic()
    private var trains: [TrainInfo] = []
    private var elementName = ""
    
    private var trainCode = ""
    private var trainDate = Date().irishDate()
    private var message = ""
    private var direction = ""
    private var latitude: Double = 0
    private var longitude: Double = 0
    private var locationFullName = ""
    private var schArrival = zeroTimeString
    private var schDeparture = zeroTimeString
    private var expArrival = zeroTimeString
    private var expDeparture = zeroTimeString
    private var arrival: TrainInfo.HoursMinutesSeconds?
    private var departure: TrainInfo.HoursMinutesSeconds?
}

extension TrainInfoParser {
    
    func parse(_ data: Data) -> [TrainInfo] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        
        return trains
    }
    
}

extension TrainInfoParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "objTrainPositions" || elementName == "objTrainMovements" {
            trainCode = ""
            trainDate = Date().irishDate()
            message = ""
            direction = ""
            latitude = 0
            longitude = 0
            locationFullName = ""
            schArrival = TrainInfoParser.zeroTimeString
            schDeparture = TrainInfoParser.zeroTimeString
            expArrival = TrainInfoParser.zeroTimeString
            expDeparture = TrainInfoParser.zeroTimeString
            arrival = nil
            departure = nil
        }
        
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        guard elementName == "objTrainPositions" || elementName == "objTrainMovements" else {
            return
        }
        
        let ti = TrainInfo(trainCode: trainCode,
                           trainDate: trainDate,
                           message: message,
                           direction: direction,
                           latitude: latitude,
                           longitude: longitude,
                           locationFullName: locationFullName,
                           schArrival: schArrival,
                           schDeparture: schDeparture,
                           expArrival: expArrival,
                           expDeparture: expDeparture,
                           arrival: arrival,
                           departure: departure)
        trains.append(ti)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        guard !data.isEmpty else {
            return
        }
        
        typealias ResultF = AdditionalServerParseLogic.ResultF
        
        let trainCodeF: ResultF = { [weak self] d in
            self?.trainCode = d
        }
        let trainDateF: ResultF = { [weak self] _ in
//            d.components(separatedBy: " ")
//            let date = Date.dateIrishFrom({ (ServerConstants.trainDateFormat, d) })
            self?.trainDate = Date().irishDate() //date ?? Date().irishDate()
        }
        let messageF: ResultF = { [weak self] d in
            self?.message = d
        }
        let directionF: ResultF = { [weak self] d in
            self?.direction = d
        }
        let latitudeF: ResultF = { [weak self] d in
            self?.latitude = Double(d) ?? 0
        }
        let longitudeF: ResultF = { [weak self] d in
            self?.longitude = Double(d) ?? 0
        }
        let locationFullNameF: ResultF = { [weak self] d in
            self?.locationFullName = d
        }
        let schArrivalF: ResultF = { [weak self] d in
            if let hms = d.hourMinutesAndSeconds() {
                self?.schArrival = hms
            }
        }
        let schDepartureF: ResultF = { [weak self] d in
            if let hms = d.hourMinutesAndSeconds() {
                self?.schDeparture = hms
            }
        }
        let expArrivalF: ResultF = { [weak self] d in
            if let hms = d.hourMinutesAndSeconds() {
                self?.expArrival = hms
            }
        }
        let expDepartureF: ResultF = { [weak self] d in
            if let hms = d.hourMinutesAndSeconds() {
                self?.expDeparture = hms
            }
        }
        let arrivalF: ResultF = { [weak self] d in
            let hms = d.hourMinutesAndSeconds()
            self?.arrival = hms
        }
        let departureF: ResultF = { [weak self] d in
            let hms = d.hourMinutesAndSeconds()
            self?.departure = hms
        }
        
        let firstGroup: ResultF? = aspl.elementF(elementName, "TrainCode", trainCodeF) ??
            aspl.elementF(elementName, "TrainDate", trainDateF) ??
            aspl.elementF(elementName, "PublicMessage", messageF) ??
            aspl.elementF(elementName, "Direction", directionF) ??
            aspl.elementF(elementName, "TrainLatitude", latitudeF) ??
            aspl.elementF(elementName, "TrainLongitude", longitudeF)
        let secondGroup: ResultF? = aspl.elementF(elementName, "LocationFullName", locationFullNameF) ??
            aspl.elementF(elementName, "ScheduledArrival", schArrivalF) ??
            aspl.elementF(elementName, "ScheduledDeparture", schDepartureF) ??
            aspl.elementF(elementName, "ExpectedArrival", expArrivalF) ??
            aspl.elementF(elementName, "ExpectedDeparture", expDepartureF) ??
            aspl.elementF(elementName, "Arrival", arrivalF) ??
            aspl.elementF(elementName, "Departure", departureF)
        
        let result = firstGroup ?? secondGroup
        result?(data)
    }
    
}
