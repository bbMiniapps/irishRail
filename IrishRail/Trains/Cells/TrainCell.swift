//
//  TrainCell.swift
//  IrishRail
//
//  Created by Boris Hristov on 30.07.20.
//  Copyright © 2020 bh. All rights reserved.
//

import UIKit

final class TrainCell: UITableViewCell {

    @IBOutlet private weak var hStack: UIStackView!
    @IBOutlet private weak var originStack: UIStackView!
    @IBOutlet private weak var destinationStack: UIStackView!
    @IBOutlet private weak var originalTimeLateStack: UIStackView!
    @IBOutlet private weak var destinationTimeLateStack: UIStackView!
    
    @IBOutlet private weak var trainCodeLabel: UILabel!
    @IBOutlet private weak var originStationName: UILabel!
    @IBOutlet private weak var destinationStationName: UILabel!
    @IBOutlet private weak var arrivalTimeLabel: UILabel!
    @IBOutlet private weak var departureTimeLabel: UILabel!
    @IBOutlet private weak var dArrivalTimeLabel: UILabel!
    @IBOutlet private weak var dDepartureTimeLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var originalArrivalLateLabel: UILabel!
    @IBOutlet private weak var destinationArrivalLateLabel: UILabel!
    @IBOutlet private weak var arrivalDesc: UILabel!
    @IBOutlet private weak var departureDesc: UILabel!
    @IBOutlet private weak var dArrivalDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        func initialSetup() {
            backgroundColor = .clear
            contentView.backgroundColor = .clear
            
            dDepartureTimeLabel.text = ""
            
            separatorView.backgroundColor = .darkGray
            
            arrivalDesc.text = "Arr"
            departureDesc.text = "Dep"
            dArrivalDesc.text = "Arr"
        }
        initialSetup()
        
        func setupStacks() {
            hStack.isLayoutMarginsRelativeArrangement = true
            hStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0,
                                                                      leading: 15,
                                                                      bottom: 0,
                                                                      trailing: 15)
            
            originStack.isLayoutMarginsRelativeArrangement = true
            originStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0,
                                                                           leading: 0,
                                                                           bottom: 0,
                                                                           trailing: 10)
            
            destinationStack.isLayoutMarginsRelativeArrangement = true
            destinationStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0,
                                                                                leading: 0,
                                                                                bottom: 0,
                                                                                trailing: 10)
            
            originalTimeLateStack.setCustomSpacing(20, after: arrivalDesc)
            destinationTimeLateStack.setCustomSpacing(20, after: dArrivalDesc)
        }
        setupStacks()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        arrivalTimeLabel.text = ""
        arrivalTimeLabel.textColor = .darkGray
        
        originalArrivalLateLabel.text = ""
        originalArrivalLateLabel.textColor = .green
        
        departureTimeLabel.text = ""
        departureTimeLabel.textColor = .darkGray
        
        dArrivalTimeLabel.text = ""
        dArrivalTimeLabel.textColor = .darkGray
        
        destinationArrivalLateLabel.text = ""
        destinationArrivalLateLabel.textColor = .green
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func populate(_ dataModel: TrainDataModel) {
        let irishDate = Date().irishDate()
        
        func populateCode(_ trainCode: String) {
            trainCodeLabel.text = trainCode
        }
        populateCode(dataModel.trainCode)
        
        func populateOriginStationName(_ name: String) {
            originStationName.text = name
        }
        populateOriginStationName(dataModel.originStationDesc)
        
        func populateDestinationStationName(_ name: String) {
            destinationStationName.text = name
        }
        populateDestinationStationName(dataModel.destinationStationDesc)
        
        func populateOriginalArrivalTime(_ expArrivalDate: Date?,
                                         _ schArrivalDate: Date?,
                                         _ iriDate: Date) {
            guard let expArrivalDate = expArrivalDate,
                let schArrivalDate = schArrivalDate else {
                return
            }
            
            let isArrival = expArrivalDate.compare(iriDate) == .orderedDescending
            let hm = expArrivalDate.dateToHourMinutes()
            let lateMin = AdditionalServerDataLogic().late(expArrivalDate, schArrivalDate)
            
            arrivalTimeLabel.text = hm
            arrivalTimeLabel.textColor = isArrival ? .darkGray : .red
            originalArrivalLateLabel.text = "\(lateMin)"
            originalArrivalLateLabel.textColor = isArrival ? .green : .red
        }
        populateOriginalArrivalTime(dataModel.originExpArrival,
                                    dataModel.originSchArrival,
                                    irishDate)
        
        func populateOriginalDepartureTime( _ expDepartureDate: Date?,
                                            _ iriDate: Date) {
            guard let expDepartureDate = expDepartureDate else {
                return
            }
            
            let isDeparture = expDepartureDate.compare(iriDate) == .orderedDescending
            let dhm = expDepartureDate.dateToHourMinutes()
            
            departureTimeLabel.text = dhm
            departureTimeLabel.textColor = isDeparture ? .darkGray : .red
        }
        populateOriginalDepartureTime(dataModel.originExpDeparture,
                                      irishDate)
        
        func populateDestinationArrivalTime(_ destinationExpArrivalDate: Date?,
                                            _ destinationSchArrivalDate: Date?,
                                            _ iriDate: Date) {
            guard let destinationExpArrivalDate = destinationExpArrivalDate,
                let destinationSchArrivalDate = destinationSchArrivalDate else {
                return
            }
            
            let isArrival = destinationExpArrivalDate.compare(iriDate) == .orderedDescending
            let hm = destinationExpArrivalDate.dateToHourMinutes()
            let lateMin = AdditionalServerDataLogic().late(destinationExpArrivalDate, destinationSchArrivalDate)
            
            dArrivalTimeLabel.text = hm
            dArrivalTimeLabel.textColor = isArrival ? .darkGray : .red
            destinationArrivalLateLabel.text = "\(lateMin)"
            destinationArrivalLateLabel.textColor = isArrival ? .green : .red
        }
        populateDestinationArrivalTime(dataModel.destinationExpArrival,
                                       dataModel.destinationSchArrival,
                                       irishDate)
    }
    
}
