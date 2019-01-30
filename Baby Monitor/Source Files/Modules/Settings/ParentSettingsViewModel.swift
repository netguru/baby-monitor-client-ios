//
//  ParentSettingsViewModel.swift
//  Baby Monitor
//

import RxSwift
import RxCocoa

final class ParentSettingsViewModel {

    lazy var dismissImagePicker: Observable<Void> = dismissImagePickerSubject.asObservable()
    lazy var baby: Observable<Baby> = babyRepo.babyUpdateObservable
    private(set) var addPhoto: Observable<Void>?
    private let babyRepo: BabyModelControllerProtocol
    private let bag = DisposeBag()
    private let dismissImagePickerSubject = PublishRelay<Void>()


    init(babyRepo: BabyModelControllerProtocol) {
        self.babyRepo = babyRepo
    }

    func attachInput(babyName: Observable<String>, addPhotoTap: Observable<Void>, resetAppTap: Observable<Void>) {
        addPhoto = addPhotoTap
        babyName.subscribe(onNext: { [weak self] name in
            self?.babyRepo.updateName(name)
        })
        .disposed(by: bag)
        resetAppTap.subscribe(onNext: { [weak self] _ in
            self?.babyRepo.removeAllData()
            // TODO: Logout from the app
        })
        .disposed(by: bag)
    }

    func updatePhoto(_ photo: UIImage) {
        babyRepo.updatePhoto(photo)
    }

    func selectDismissImagePicker() {
        dismissImagePickerSubject.accept(())
    }
}
