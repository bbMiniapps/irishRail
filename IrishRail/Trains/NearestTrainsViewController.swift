//
//  NearestTrainsViewController.swift
//  IrishRail
//
//  Created by Boris Hristov on 30.07.20.
//  Copyright © 2020 bh. All rights reserved.
//

import Foundation
import SwiftUI

final class NearestTrainsViewController: UIViewController {

    @IBOutlet private weak var vStack: UIStackView!
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel = TrainsViewModel()
    private let dataSource = NearestTrainsDataSource()
    
    private var scheduleMenu: ScheduleMenu?
    
    private var refControl = UIRefreshControl()
    private var stopRefreshing: (() -> Void)!
    
    private var showEmptyMessage = false
    private var feedState = LoadingState.clear {
        didSet {
            let date = Date().irishDate()
            let (dayDesc, day, month) = date.calendarMenu()
            scheduleMenu?.calendar = CalendarData(dayDescription: dayDesc,
                                                  day: day,
                                                  month: month)
            
            didChangeFeedState()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func setupMenu() {
            let changeDirectionAction: () -> Void = { [weak self] in
                guard let `self` = self else {
                    return
                }
                
                self.feedState = .clear
            }
            
            let goAction: () -> Void = { [weak self] in
                guard let `self` = self else {
                    return
                }
                
                self.feedState = .clear
                
                self.refControl.beginRefreshing()
                self.request()
            }
            
            let date = Date().irishDate()
            let (dayDesc, day, month) = date.calendarMenu()
            
            let schMenu = ScheduleMenu()
            schMenu.calendar = CalendarData(dayDescription: dayDesc,
                                            day: day,
                                            month: month)
            schMenu.destination = DestinationData(startPointDesc: "Arklow",
                                                  endPointDesc: "Shankill",
                                                  direction: .north)
            scheduleMenu = schMenu
            
            let mSwiftUI = MenuSwiftUIView(scheduleMenu: schMenu,
                                           changeDirectionAction: changeDirectionAction,
                                           goAction: goAction)
            guard let mUIView = UIHostingController(rootView: mSwiftUI).view else {
                return
            }
            
            mUIView.backgroundColor = .clear
            vStack.insertArrangedSubview(mUIView, at: 0)
            vStack.setCustomSpacing(10, after: mUIView)
        }
        setupMenu()
        
        // MARK: Setup tablev view
        func setupTableView() {
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
            
            tableView.dataSource = dataSource
            tableView.delegate = self
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = TableViewConstants.estimatedRowHeight
            tableView.registerTableViewCellNibs({ [TrainCell.self] })
            
            refControl.backgroundColor = .clear
            refControl.addTarget(self,
                                 action: #selector(refresh(_:)),
                                 for: .valueChanged)
            tableView.refreshControl = refControl
            stopRefreshing = { [weak self] in
                self?.refControl.endRefreshing()
            }
        }
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        feedState = .clear
        refControl.beginRefreshing()
        request()
    }
    
    // MARK: - Private Refresh
    @objc private func refresh(_ refreshControl: UIRefreshControl) {
        feedState = .clear
        
        request()
    }
    
    // MARK: - Private
    private func didChangeFeedState() {
        switch feedState {
        case .loading:
            scheduleMenu?.isEnable = false
            showEmptyMessage = false
        case .populated(let data):
            stopRefreshing()
            scheduleMenu?.isEnable = true
            
            if let d = data as? [TrainDataModel] {
                dataSource.populate(d)
                tableView.reloadData()
            }
        case .empty:
            stopRefreshing()
            scheduleMenu?.isEnable = true
            
            showEmptyMessage = true
            tableView.reloadData()
        case .error(let error):
            stopRefreshing()
            scheduleMenu?.isEnable = true
            
            func showAlertMessage(_ pF: () -> (String, String)) {
                let (title, message) = pF()
                
                let alert = UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                present(alert, animated: true)
            }
            
            showAlertMessage({ ("Error", "\(error.message) Code: \(error.code)") })
        case .clear:
            showEmptyMessage = false
            
            dataSource.resetDataSource()
            tableView.reloadData()
            
            scheduleMenu?.isEnable = true
        }
    }
    
    private func request() {
        guard feedState != .loading  else {
            return
        }
        
        feedState = .loading
        
        let startDesc = scheduleMenu?.destination?.startPointDesc ?? ""
        let endDesc = scheduleMenu?.destination?.endPointDesc ?? ""
        let direction = scheduleMenu?.destination?.direction ?? .north
        viewModel.trainsFromTo({ (startDesc, endDesc, ServerConstants.startMainStation, direction) }) { [weak self] result in
            guard let `self` = self else {
                return
            }
            
            switch result {
            case .success(let trains):
                if trains.isEmpty {
                    self.feedState = .empty
                } else {
                    self.feedState = .populated(data: trains)
                }
            case .failure(let err):
                self.feedState = .error(err)
            }
            
        }
    }

}

extension NearestTrainsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard showEmptyMessage else {
            return nil
        }
        
        let label = PaddingLabel(frame: CGRect(x: 0.0,
                                               y: 0.0,
                                               width: tableView.frame.size.width,
                                               height: 1.0))
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "No data found!"
        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let result: CGFloat = showEmptyMessage ? TableViewConstants.defaultHeightForFooter : 0
        
        return result
    }
    
}
