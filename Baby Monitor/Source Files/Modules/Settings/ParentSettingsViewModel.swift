//
//  ParentSettingsViewModel.swift
//  Baby Monitor
//

import RxSwift
import RxCocoa

final class ParentSettingsViewModel {

    private let babyRepo: BabiesRepositoryProtocol

    private let bag = DisposeBag()

    private(set) var addPhoto: Observable<Void>?

    private let dismissImagePickerSubject = PublishRelay<Void>()

    lazy var dismissImagePicker: Observable<Void> = dismissImagePickerSubject.asObservable()

    lazy var baby: Observable<Baby> = babyRepo.babyUpdateObservable

    init(babyRepo: BabiesRepositoryProtocol) {
        self.babyRepo = babyRepo
    }

    func attachInput(babyName: Observable<String>, addPhotoTap: Observable<Void>, resetAppTap: Observable<Void>) {
        addPhoto = addPhotoTap
        babyName.subscribe(onNext: { [weak self] name in
            self?.babyRepo.setCurrentName(name)
        })
        .disposed(by: bag)
        resetAppTap.subscribe(onNext: { [weak self] _ in
            self?.babyRepo.removeAllData()
        })
        .disposed(by: bag)
    }

    func updatePhoto(_ photo: UIImage) {
        babyRepo.setCurrentPhoto(photo)
    }

    func selectDismissImagePicker() {
        dismissImagePickerSubject.accept(())
    }
}
