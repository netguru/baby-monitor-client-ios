//
//  ActivityLogViewModel.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import RxCocoa

final class ActivityLogViewModel {
    
    typealias DataType = ActivityLogEvent
    
    lazy var sectionsChangeObservable = sectionsChangePublisher.asObservable()
    let sectionsChangePublisher = PublishSubject<Void>()
    var numberOfSections: Int {
        return currentSections.count
    }
    private(set) var baby: Observable<Baby>
    
    private let dateFormatter = DateFormatter()
    private let databaseRepository: BabyModelControllerProtocol & ActivityLogEventsRepositoryProtocol
    private var currentSections: [GeneralSection<ActivityLogEvent>] = []
    private let disposeBag = DisposeBag()

    init(databaseRepository: BabyModelControllerProtocol & ActivityLogEventsRepositoryProtocol) {
        self.databaseRepository = databaseRepository
        self.baby = databaseRepository.babyUpdateObservable
        rxSetup()
    }
    
    // MARK: - Internal functions
    func numberOfRows(in section: Int) -> Int {
        guard section < currentSections.count else {
            return 0
        }
        return currentSections[section].items.count
    }
    
    func configure(cell: ActivityLogCell, for indexPath: IndexPath) {
        guard
            indexPath.section < currentSections.count,
            indexPath.row < currentSections[indexPath.section].items.count
        else {
            return
        }
        let activityLogEvent = currentSections[indexPath.section].items[indexPath.row
        ]
        let dateText = textDateForCell(from: activityLogEvent.date)
        cell.update(secondaryText: dateText)
        switch activityLogEvent.mode {
        case .emptyState:
            cell.update(mainText: Localizable.ActivityLog.emptyStateMessage)
        case .cryingEvent:
            cell.update(mainText: "\(databaseRepository.baby.name) \(Localizable.ActivityLog.wasCrying)")
        }
    }

    func configure(headerCell: ActivityLogCell, for section: Int) {
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
                    sortedLogs[sortedLogs.endIndex - 1].insert(log, at: 0)
                } else {
                    sortedLogs.append([log])
                }
            }
        }
        sortedLogs.reverse()
        return sortedLogs
    }
    
    private func textDateForCell(from date: Date) -> String {
        dateFormatter.dateFormat = "HH:mm a"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    private func textDateForHeader(from date: Date) -> String {
        var prefix = ""
        if Calendar.current.isDateInToday(date) {
            prefix = "\(Localizable.General.today), "
        } else if Calendar.current.isDateInYesterday(date) {
            prefix = "\(Localizable.General.yesterday), "
        }
        dateFormatter.dateFormat = "MMM dd, YYYY"
        let dateString = dateFormatter.string(from: date)
        return prefix + dateString
    }
    
    private func rxSetup() {
        databaseRepository.activityLogEventsObservable
            .map { [weak self] events -> [[ActivityLogEvent]] in
                guard let self = self else {
                    return []
                }
                return self.sortedActivityLogEvents(logs: events)
            }
            .map { [weak self] sortedLogEvents in
                guard let self = self else {
                    return
                }
                var allSections: [GeneralSection<ActivityLogEvent>] = []
                sortedLogEvents.forEach {
                    let section = GeneralSection<ActivityLogEvent>(title: "", items: $0)
                    allSections.append(section)
                }
                self.currentSections = allSections
            }
            .subscribe(onNext: { [weak self] _ in
                self?.sectionsChangePublisher.onNext(())
            })
            .disposed(by: disposeBag)
    }
}
