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
    private(set) var addPhotoTap: Observable<UIButton>?
    private(set) var voiceDetectionTap: Observable<Int>?
    private(set) var resetAppTap: Observable<Void>?
    private(set) var cancelTap: Observable<Void>?
    
    private let babyModelController: BabyModelControllerProtocol
    private let bag = DisposeBag()
    private let dismissImagePickerSubject = PublishRelay<Void>()
    private let webSocketEventMessageService: WebSocketEventMessageServiceProtocol
    
    init(babyModelController: BabyModelControllerProtocol,
         webSocketEventMessageService: WebSocketEventMessageServiceProtocol,
         analytics: AnalyticsManager) {
        self.babyModelController = babyModelController
        self.webSocketEventMessageService = webSocketEventMessageService
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
        voiceDetectionTap?.subscribe({ [weak self] event in
            guard let self = self,
                let index = event.element,
                index < VoiceDetectionMode.allCases.count,
                VoiceDetectionMode.allCases.count == self.voiceDetectionModes.count else {
                    assertionFailure("Not handled all voice detection cases")
                    return
            }
            let voiceDetectionMode = self.voiceDetectionModes[index]
            let message = EventMessage(voiceDetectionMode: voiceDetectionMode)
            self.webSocketEventMessageService.sendMessage(message.toStringMessage())
        }).disposed(by: bag)
    }
}
