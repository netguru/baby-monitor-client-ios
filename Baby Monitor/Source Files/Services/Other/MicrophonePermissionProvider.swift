//
//  MicrophonePermissionProvider.swift
//  Baby Monitor
//

import RxSwift
import AVFoundation

protocol MicrophonePermissionProviderProtocol: AnyObject {
    func getMicrophonePermission() -> Observable<Void>
}

final class MicrophonePermissionProvider: MicrophonePermissionProviderProtocol {
    
    func getMicrophonePermission() -> Observable<Void> {
        return Observable.create({ observer in
            guard AVAudioSession.sharedInstance().recordPermission == .undetermined else {
                observer.onNext(())
                return Disposables.create()
            }
            AVAudioSession.sharedInstance().requestRecordPermission({ _ in
                observer.onNext(())
            })
            return Disposables.create()
        })
            .observeOn(MainScheduler.asyncInstance)
    }
}
