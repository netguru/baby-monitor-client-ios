//
//  ActivityLogViewModel.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import RxCocoa

final class ActivityLogViewModel: BabyMonitorGeneralViewModelProtocol, BabyMonitorHeaderCellConfigurable {
    
    typealias DataType = ActivityLogEvent
    
    private let databaseRepository: BabyModelControllerProtocol & ActivityLogEventsRepositoryProtocol

    init(databaseRepository: BabyModelControllerProtocol & ActivityLogEventsRepositoryProtocol) {
        self.databaseRepository = databaseRepository
        self.baby = databaseRepository.babyUpdateObservable
    }

    // MARK: - Coordinator callback
    private(set) var baby: Observable<Baby>
    private var currentSections: [GeneralSection<ActivityLogEvent>] = []
    var sections: Observable<[GeneralSection<ActivityLogEvent>]> {
        return databaseRepository.activityLogEventsObservable
            .map { [weak self] events -> [[ActivityLogEvent]] in
                guard let self = self else {
                    return []
                }
                return self.sortedActivityLogEvents(logs: events)
            }
            .map { [weak self] sortedLogEvents in
                guard let self = self else {
                    return []
                }
                var allSections: [GeneralSection<ActivityLogEvent>] = []
                sortedLogEvents.forEach {
                    let section = GeneralSection<ActivityLogEvent>(title: "", items: $0)
                    allSections.append(section)
                }
                self.currentSections = allSections
                return allSections
            }
        
    }
    
    // MARK: - Internal functions
    func configure(cell: BabyMonitorCellProtocol, for data: ActivityLogEvent) {
        cell.type = .activityLog
        let activityLogEvent = data
        if let image = databaseRepository.baby.photo {
            cell.update(image: image)
        }
        switch activityLogEvent.mode {
        case .emptyState:
            cell.update(mainText: Localizable.ActivityLog.emptyStateMessage)
        case .cryingEvent:
            cell.update(mainText: "\(databaseRepository.baby.name) was crying!")
            let dateText = textDateForCell(from: activityLogEvent.date)
            cell.update(secondaryText: dateText)
        }
    }

    func configure(headerCell: BabyMonitorCellProtocol, for section: Int) {
        headerCell.configureAsHeader()
        guard
            section < currentSections.count,
            let date = currentSections[section].items.first?.date
        else {
            return
        }
        let dateText = textDateForHeader(from: date)
        headerCell.update(mainText: dateText)
    }
    
    private func sortedActivityLogEvents(logs: [ActivityLogEvent]) -> [[ActivityLogEvent]] {
        var sortedLogs: [[ActivityLogEvent]] = []
        for (index, log) in logs.enumerated() {
            if index == 0 {
                sortedLogs.append([log])
            } else {
                if Calendar.current.compare(logs[index].date, to: logs[index - 1].date, toGranularity: .day) == .orderedSame {
                    sortedLogs[sortedLogs.endIndex - 1].append(log)
                } else {
                    sortedLogs.append([log])
                }
            }
        }
        return sortedLogs
    }
    
    private func textDateForCell(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    private func textDateForHeader(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        var prefix = ""
        if Calendar.current.isDateInToday(date) {
            prefix = "\(Localizable.General.today),"
        } else if Calendar.current.isDateInYesterday(date) {
            prefix = "\(Localizable.General.yesterday),"
        }
        dateFormatter.dateFormat = "MMM dd,YYYY"
        let dateString = dateFormatter.string(from: date)
        return prefix + dateString
    }
}
