//
//  BabiesRepositoryMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import RxSwift

final class BabiesRepositoryMock: BabiesRepositoryProtocol {
    
    var babyUpdateObservable: Observable<Baby> {
        return babyUpdatePublisher
            .filter { $0 != nil }
            .map { $0! }
    }
    private let babyUpdatePublisher = BehaviorSubject<Baby?>(value: nil)
    
    private(set) var babies = [String: Baby]()
    private var currentBabyId: String? {
        didSet {
            guard let id = currentBabyId else { return }
            babyUpdatePublisher.onNext(babies[id])
        }
    }
    
    init(currentBaby: Baby? = nil) {
        guard let id = currentBaby?.id else { return }
        currentBabyId = id
        babies[id] = currentBaby
        babyUpdatePublisher.onNext(babies[id])
    }
    
    func save(baby: Baby) throws {
        babies[baby.id] = baby
        babyUpdatePublisher.onNext(baby)
    }
    
    func setCurrent(baby: Baby) {
        currentBabyId = baby.id
    }
    
    func getCurrent() -> Baby? {
        guard let currentBabyId = currentBabyId else {
            return nil
        }
        return babies[currentBabyId]
    }
    
    func fetchAllBabies() -> [Baby] {
        return Array(babies.values)
    }
    
    func fetchBaby(id: String) -> Baby? {
        return babies[id]
    }
    
    func fetchBabies(name: String) -> [Baby] {
        return babies.values.filter { $0.name == name }
    }
    
    func removeAllBabies() {
        babies = [String: Baby]()
    }
    
    func setPhoto(_ photo: UIImage, id: String) {
        guard let baby = babies[id] else { return }
        babies[id] = Baby(id: baby.id, name: baby.name, photo: photo)
        babyUpdatePublisher.onNext(babies[id])
    }
    
    func setName(_ name: String, id: String) {
        guard let baby = babies[id] else { return }
        babies[id] = Baby(id: baby.id, name: name, photo: baby.photo)
        babyUpdatePublisher.onNext(babies[id])
    }
    
    func setCurrentPhoto(_ photo: UIImage) {
        guard let id = currentBabyId else { return }
        setPhoto(photo, id: id)
    }
    
    func setCurrentName(_ name: String) {
        guard let id = currentBabyId else { return }
        setName(name, id: id)
    }
}
