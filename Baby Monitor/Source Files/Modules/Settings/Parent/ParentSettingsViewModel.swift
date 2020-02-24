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
    var selectedVoiceModeIndexPublisher = BehaviorSubject<Int>(value: 0)
    var noiseLoudnessFactorLimitPublisher = BehaviorSubject<Int>(value: UserDefaults.noiseLoudnessFactorLimit)
    let webSocketMessageResultPublisher = PublishSubject<Result<()>>()

    private(set) var addPhotoTap: Observable<UIButton>?
    private(set) var soundDetectionTap: Observable<Int>?
    private(set) var resetAppTap: Observable<Void>?
    private(set) var cancelTap: Observable<Void>?
    private(set) var noiseSliderValue: Observable<Int>?
    private(set) var noiseSliderValueOnEnded: Observable<Int>?
    private var currentConnectionStatus: WebSocketConnectionStatus?
    
    private let babyModelController: BabyModelControllerProtocol
    private let bag = DisposeBag()
    private let dismissImagePickerSubject = PublishRelay<Void>()
    private let webSocketEventMessageService: WebSocketEventMessageServiceProtocol
    private let randomizer: RandomGenerator

    init(babyModelController: BabyModelControllerProtocol,
         webSocketEventMessageService: WebSocketEventMessageServiceProtocol,
         randomizer: RandomGenerator,
         analytics: AnalyticsManager) {
        self.babyModelController = babyModelController
        self.webSocketEventMessageService = webSocketEventMessageService
        self.randomizer = randomizer
        super.init(analytics: analytics)
    }
    
    func attachInput(babyName: Observable<String>,
                     addPhotoTap: Observable<UIButton>,
                     soundDetectionTap: Observable<Int>,
                     resetAppTap: Observable<Void>,
                     cancelTap: Observable<Void>,
                     noiseSliderValueOnEnded: Observable<Int>) {
        self.addPhotoTap = addPhotoTap
        self.soundDetectionTap = soundDetectionTap
        self.resetAppTap = resetAppTap
        self.cancelTap = cancelTap
        self.noiseSliderValueOnEnded = noiseSliderValueOnEnded
        babyName.subscribe({ [weak self] event in
            if let name = event.element {
                self?.babyModelController.updateName(name)
            }
        }).disposed(by: bag)
        updateSelectedSoundMode()
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
            .subscribe({ [weak self] event in
                guard let self = self,
                    let value = event.element else { return }
                    self.handleNoiseLimit(value)
            }).disposed(by: bag)

        webSocketEventMessageService.connectionStatusObservable
            .subscribe({ [weak self] status in
                self?.currentConnectionStatus = status.element
            }).disposed(by: bag)
    }

    private func handleSoundDetectionModeChange(for index: Int) {
        guard index < SoundDetectionMode.allCases.count,
            SoundDetectionMode.allCases.count == soundDetectionModes.count else {
                assertionFailure("Not handled all voice detection cases")
                return
        }
        guard currentConnectionStatus != .disconnected else {
            updateSelectedSoundMode()
            self.webSocketMessageResultPublisher.onNext(.failure(nil))
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
                self.updateSelectedSoundMode()
            }
            self.webSocketMessageResultPublisher.onNext(result)
        })
    }

    private func handleNoiseLimit(_ noiseLimit: Int) {
        guard currentConnectionStatus != .disconnected else {
            noiseLoudnessFactorLimitPublisher.onNext(UserDefaults.noiseLoudnessFactorLimit)
            self.webSocketMessageResultPublisher.onNext(.failure(nil))
            return
        }
        let message = EventMessage(noiseLevelLimit: noiseLimit, confirmationId: randomizer.generateRandomCode())
        webSocketEventMessageService.sendMessage(message, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                UserDefaults.noiseLoudnessFactorLimit = noiseLimit
            case .failure:
                self.noiseLoudnessFactorLimitPublisher.onNext(UserDefaults.noiseLoudnessFactorLimit)
            }
            self.webSocketMessageResultPublisher.onNext(result)
        })
    }

    private func updateSelectedSoundMode() {
        selectedVoiceModeIndexPublisher.onNext(soundDetectionModes.index(of: UserDefaults.soundDetectionMode) ?? 0)
    }
}
