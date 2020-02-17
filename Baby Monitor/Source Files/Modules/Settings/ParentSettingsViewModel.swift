//
//  ParentSettingsViewModel.swift
//  Baby Monitor
//

import RxSwift
import RxCocoa

protocol BaseSettingsViewModelProtocol: AnyObject {
    var resetAppTap: Observable<Void>? { get }
    var cancelTap: Observable<Void>? { get }
}

final class ParentSettingsViewModel: BaseViewModel, BaseSettingsViewModelProtocol {

    lazy var dismissImagePicker: Observable<Void> = dismissImagePickerSubject.asObservable()
    lazy var baby: Observable<Baby> = babyModelController.babyUpdateObservable
    let soundDetectionModes: [SoundDetectionMode] = [.noiseDetection, .cryRecognition]
    var soundDetectionTitles: [String] {
        return soundDetectionModes.map { $0.localizedTitle }
    }
    var selectedVoiceModeIndex: Int {
        return soundDetectionModes.index(of: UserDefaults.soundDetectionMode) ?? 0
    }
    let settingSoundDetectionFailedPublisher = PublishRelay<Void>()
    let errorHandler: ErrorHandlerProtocol

    private(set) var addPhotoTap: Observable<UIButton>?
    private(set) var soundDetectionTap: Observable<Int>?
    private(set) var resetAppTap: Observable<Void>?
    private(set) var cancelTap: Observable<Void>?
    
    private let babyModelController: BabyModelControllerProtocol
    private let bag = DisposeBag()
    private let dismissImagePickerSubject = PublishRelay<Void>()
    private let webSocketEventMessageService: WebSocketEventMessageServiceProtocol
    private let randomizer: RandomGenerator
    
    init(babyModelController: BabyModelControllerProtocol,
         webSocketEventMessageService: WebSocketEventMessageServiceProtocol,
         errorHandler: ErrorHandlerProtocol,
         randomizer: RandomGenerator,
         analytics: AnalyticsManager) {
        self.babyModelController = babyModelController
        self.webSocketEventMessageService = webSocketEventMessageService
        self.errorHandler = errorHandler
        self.randomizer = randomizer
        super.init(analytics: analytics)
    }
    
    func attachInput(babyName: Observable<String>,
                     addPhotoTap: Observable<UIButton>,
                     soundDetectionTap: Observable<Int>,
                     resetAppTap: Observable<Void>,
                     cancelTap: Observable<Void>) {
        self.addPhotoTap = addPhotoTap
        self.soundDetectionTap = soundDetectionTap
        self.resetAppTap = resetAppTap
        self.cancelTap = cancelTap
        babyName.subscribe({ [weak self] event in
            if let name = event.element {
                self?.babyModelController.updateName(name)
            }
        }).disposed(by: bag)
        setupBindings()
    }
    
    func updatePhoto(_ photo: UIImage) {
        babyModelController.updatePhoto(photo)
    }
    
    func selectDismissImagePicker() {
        dismissImagePickerSubject.accept(())
    }

    private func setupBindings() {
        soundDetectionTap?
            .skip(1)
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe({ [weak self] event in
            guard let self = self,
                let index = event.element else { return }
                self.handleSoundDetectionModeChange(for: index)
        }).disposed(by: bag)
    }

    private func handleSoundDetectionModeChange(for index: Int) {
        guard index < SoundDetectionMode.allCases.count,
            SoundDetectionMode.allCases.count == self.soundDetectionModes.count else {
                assertionFailure("Not handled all voice detection cases")
                return
        }
        let soundDetectionMode = self.soundDetectionModes[index]
        let message = EventMessage(soundDetectionMode: soundDetectionMode, confirmationId: self.randomizer.generateRandomCode())
        self.webSocketEventMessageService.sendMessage(message, completion: { result in
            switch result {
            case .success:
                UserDefaults.soundDetectionMode = soundDetectionMode
            case .failure:
                self.settingSoundDetectionFailedPublisher.accept(())
            }
        })
    }
}
