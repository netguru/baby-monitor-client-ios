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
    let voiceDetectionModes: [VoiceDetectionMode] = [.noiseDetection, .machineLearningCryRecognition]
    var voiceDetectionTitles: [String] {
        return voiceDetectionModes.map { $0.localizedTitle }
    }
    var selectedVoiceModeIndex: Int {
        return voiceDetectionModes.index(of: UserDefaults.voiceDetectionMode) ?? 0
    }
    let settingVoiceDetectionFailedPublisher = PublishRelay<Void>()
    let errorHandler: ErrorHandlerProtocol

    private(set) var addPhotoTap: Observable<UIButton>?
    private(set) var voiceDetectionTap: Observable<Int>?
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
                     voiceDetectionTap: Observable<Int>,
                     resetAppTap: Observable<Void>,
                     cancelTap: Observable<Void>) {
        self.addPhotoTap = addPhotoTap
        self.voiceDetectionTap = voiceDetectionTap
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
        voiceDetectionTap?
            .skip(1)
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe({ [weak self] event in
            guard let self = self,
                let index = event.element else { return }
                self.handleVoiceDetectionModeChange(for: index)
        }).disposed(by: bag)
    }

    private func handleVoiceDetectionModeChange(for index: Int) {
        guard index < VoiceDetectionMode.allCases.count,
            VoiceDetectionMode.allCases.count == self.voiceDetectionModes.count else {
                assertionFailure("Not handled all voice detection cases")
                return
        }
        let voiceDetectionMode = self.voiceDetectionModes[index]
        let message = EventMessage(voiceDetectionMode: voiceDetectionMode, confirmationId: self.randomizer.generateRandomCode())
        self.webSocketEventMessageService.sendMessage(message, completion: { result in
            switch result {
            case .success:
                UserDefaults.voiceDetectionMode = voiceDetectionMode
            case .failure:
                self.settingVoiceDetectionFailedPublisher.accept(())
            }
        })
    }
}
