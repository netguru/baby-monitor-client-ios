//
//  BabyService.swift
//  Baby Monitor
//

import Foundation

final class BabyService: BabyServiceProtocol {

    var dataSource: BabyServiceDataSource
    
    enum UpdateType {
        case name(Baby)
        case image(Baby)
    }
    
    private var observations = [ObjectIdentifier: Observation]()
    
    init(dataSource: BabyServiceDataSource) {
        self.dataSource = dataSource
    }
    
    func setCurrent(baby: Baby) {
        dataSource.babies.append(baby)
    }
    
    func setPhoto(_ photo: UIImage) {
        // TODO: - Implement updating saved baby, ticket: https://netguru.atlassian.net/browse/BM-91
        let oldBaby = dataSource.babies.first
        let newBaby = Baby(name: oldBaby?.name, photo: photo)
        dataSource.babies[0] = newBaby
        babyDidChange(updateType: .image(newBaby))
    }
    
    func setName(_ name: String) {
        // TODO: - Implement updating saved baby, ticket: https://netguru.atlassian.net/browse/BM-91
        let oldBaby = dataSource.babies.first
        let newBaby = Baby(name: name, photo: oldBaby?.photo)
        dataSource.babies[0] = newBaby
        babyDidChange(updateType: .name(newBaby))
    }
}

extension BabyService {

    func addObserver(_ observer: BabyServiceObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
    }
    
    func removeObserver(_ observer: BabyServiceObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }
}

private extension BabyService {
    
    struct Observation {
        weak var observer: BabyServiceObserver?
    }
    
    func babyDidChange(updateType: UpdateType) {
        for (id, observation) in observations {
            // If the observer is no longer in memory, we
            // can clean up the observation for its ID
            guard let observer = observation.observer else {
                observations.removeValue(forKey: id)
                continue
            }

            switch updateType {
            case .image(let baby):
                observer.babyService(self, didChangePhotoOf: baby)
            case .name(let baby):
                observer.babyService(self, didChangeNameOf: baby)
            }
        }
    }
}
