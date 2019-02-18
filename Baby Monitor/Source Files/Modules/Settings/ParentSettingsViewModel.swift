//
//  ParentSettingsViewModel.swift
//  Baby Monitor
//

import RxSwift
import RxCocoa

protocol BaseSettingsViewModelProtocol: AnyObject {
    var resetAppTap: Observable<Void>? { get }
    var cancelTap: Observable<Void>? { get }
    
    func clearAllDataForNoneState()
}

final class ParentSettingsViewModel: BaseSettingsViewModelProtocol {
    
    lazy var dismissImagePicker: Observable<Void> = dismissImagePickerSubject.asObservable()
    lazy var baby: Observable<Baby> = babyModelController.babyUpdateObservable
    private(set) var addPhotoTap: Observable<Void>?
    private(set) var resetAppTap: Observable<Void>?
    private(set) var cancelTap: Observable<Void>?
    
    private let babyModelController: BabyModelControllerProtocol
    private let memoryCleaner: MemoryCleanerProtocol
    private let urlConfiguration: URLConfiguration
    private let webSocketWebRtcService: WebSocketWebRtcServiceProtocol
    private let bag = DisposeBag()
    private let dismissImagePickerSubject = PublishRelay<Void>()
    
    init(babyModelController: BabyModelControllerProtocol, memoryCleaner: MemoryCleanerProtocol, urlConfiguration: URLConfiguration, webSocketWebRtcService: WebSocketWebRtcServiceProtocol) {
        self.babyModelController = babyModelController
        self.memoryCleaner = memoryCleaner
        self.urlConfiguration = urlConfiguration
        self.webSocketWebRtcService = webSocketWebRtcService
    }
    
    func attachInput(babyName: Observable<String>, addPhotoTap: Observable<Void>, resetAppTap: Observable<Void>, cancelTap: Observable<Void>) {
        self.addPhotoTap = addPhotoTap
        self.resetAppTap = resetAppTap
        self.cancelTap = cancelTap
        babyName.subscribe({ [weak self] event in
            if let name = event.element {
                self?.babyModelController.updateName(name)
            }
        })
            .disposed(by: bag)
    }
    
    func updatePhoto(_ photo: UIImage) {
        babyModelController.updatePhoto(photo)
    }
    
    func selectDismissImagePicker() {
        dismissImagePickerSubject.accept(())
    }
    
    func clearAllDataForNoneState() {
        babyModelController.removeAllData()
        memoryCleaner.cleanMemory()
        urlConfiguration.url = nil
        webSocketWebRtcService.close()
        UserDefaults.appMode = .none
    }
}
