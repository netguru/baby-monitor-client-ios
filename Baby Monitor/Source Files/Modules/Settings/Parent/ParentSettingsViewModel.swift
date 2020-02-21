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
    var selectedVoiceModeIndex: Int {
        return soundDetectionModes.index(of: UserDefaults.soundDetectionMode) ?? 0
    }
    var noiseLoudnessFactorLimit: Int {
        return UserDefaults.noiseLoudnessFactorLimit
    }
    let settingSoundDetectionFailedPublisher = PublishRelay<Void>()
    let errorHandler: ErrorHandlerProtocol

    private(set) var addPhotoTap: Observable<UIButton>?
    private(set) var soundDetectionTap: Observable<Int>?
    private(set) var resetAppTap: Observable<Void>?
    private(set) var cancelTap: Observable<Void>?
    private(set) var noiseSliderValue: Observable<Int>?
    private(set) var noiseSliderValueOnEnded: Observable<Int>?
    
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
                     cancelTap: Observable<Void>,
                     noiseSliderValue: Observable<Int>,
                     noiseSliderValueOnEnded: Observable<Int>) {
        self.addPhotoTap = addPhotoTap
        self.soundDetectionTap = soundDetectionTap
        self.resetAppTap = resetAppTap
        self.cancelTap = cancelTap
        self.noiseSliderValue = noiseSliderValue
        self.noiseSliderValueOnEnded = noiseSliderValueOnEnded
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

        noiseSliderValueOnEnded?
            .debounce(0.5, scheduler: MainScheduler.instance)
            .throttle(1, scheduler: MainScheduler.instance)// if needed
            .subscribe({ [weak self] event in
            guard let self = self,
                let value = event.element else { return }
                self.handleNoiseLimit(value)
        }).disposed(by: bag)
    }

    private func handleSoundDetectionModeChange(for index: Int) {
        guard index < SoundDetectionMode.allCases.count,
            SoundDetectionMode.allCases.count == soundDetectionModes.count else {
                assertionFailure("Not handled all voice detection cases")
                return
        }
        let soundDetectionMode = soundDetectionModes[index]
        let message = EventMessage(soundDetectionMode: soundDetectionMode, confirmationId: randomizer.generateRandomCode())
        webSocketEventMessageService.sendMessage(message, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                UserDefaults.soundDetectionMode = soundDetectionMode
            case .failure:
                self.settingSoundDetectionFailedPublisher.accept(())
            }
        })
    }

    private func handleNoiseLimit(_ noiseLimit: Int) {
        let message = EventMessage(noiseLevelLimit: noiseLimit, confirmationId: randomizer.generateRandomCode())
        webSocketEventMessageService.sendMessage(message, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                UserDefaults.noiseLoudnessFactorLimit = noiseLimit
            case .failure:
                self.settingSoundDetectionFailedPublisher.accept(())
            }
        })
    }
}
