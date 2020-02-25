//
//  ParentSettingsViewModelTests.swift
//  Baby MonitorTests

import Foundation
import XCTest
import RxSwift
import RxTest
@testable import BabyMonitor

class ParentSettingsViewModelTests: XCTestCase {

    // swiftlint:disable implicitly_unwrapped_optional
    private var babyModelController: BabyModelControllerProtocol!
    private let disposeBag = DisposeBag()
    private var webSocketEventMessageService: WebSocketEventMessageServiceMock!
    private var randomizer: RandomGenerator!
    private var analytics: AnalyticsManager!

    private var initialSoundDetectionMode: SoundDetectionMode!
    private var initialNoiseLimit: Int!

    private var babyName: Observable<String>!
    private var addPhotoTap: Observable<UIButton>!
    private var soundDetectionTap: PublishSubject<Int>!
    private var resetAppTap: Observable<Void>!
    private var cancelTap: Observable<Void>!
    private var noiseSliderValueOnEnded: PublishSubject<Int>!

    private var sut: ParentSettingsViewModel!

    // swiftlint:enable implicitly_unwrapped_optional

    override func setUp() {
        babyModelController = DatabaseRepositoryMock()
        webSocketEventMessageService = WebSocketEventMessageServiceMock()
        randomizer = RandomizerMock()
        analytics = AnalyticsManager(analyticsTracker: AnalyticsTrackerMock())

        sut = ParentSettingsViewModel(babyModelController: babyModelController,
                                      webSocketEventMessageService: webSocketEventMessageService,
                                      randomizer: randomizer,
                                      analytics: analytics)

        initialSoundDetectionMode = UserDefaults.soundDetectionMode
        initialNoiseLimit = UserDefaults.noiseLoudnessFactorLimit

        babyName = PublishSubject<String>()
        addPhotoTap = PublishSubject<UIButton>()
        soundDetectionTap = PublishSubject<Int>()
        resetAppTap = PublishSubject<Void>()
        cancelTap = PublishSubject<Void>()
        noiseSliderValueOnEnded = PublishSubject<Int>()

        sut.attachInput(babyName: babyName,
                        addPhotoTap: addPhotoTap,
                        soundDetectionTap: soundDetectionTap,
                        resetAppTap: resetAppTap,
                        cancelTap: cancelTap,
                        noiseSliderValueOnEnded: noiseSliderValueOnEnded)
    }

    override func tearDown() {
        UserDefaults.soundDetectionMode = initialSoundDetectionMode
        UserDefaults.noiseLoudnessFactorLimit = initialNoiseLimit
    }

    func testShouldSentFailureWhenAttempingToChangeSoundModeOnDisconnect() {
        // Given
        webSocketEventMessageService.connectionStatusPublisher.on(.next(.disconnected))
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Result<()>.self)
        sut.webSocketMessageResultPublisher.bind(to: observer).disposed(by: disposeBag)

        // When
        soundDetectionTap.onNext(0)

        // Then
        XCTAssertEqual(observer.events, [.next(0, .failure(nil))])
    }

    func testShouldNotChangeSoundModeWhenDisconnected() {
        // Given
        webSocketEventMessageService.connectionStatusPublisher.on(.next(.disconnected))
        let noiseIndex = sut.soundDetectionModes.index(of: .noiseDetection)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)
        sut.selectedVoiceModeIndexPublisher.skip(1).bind(to: observer).disposed(by: disposeBag)

        // When
        UserDefaults.soundDetectionMode = .cryRecognition
        soundDetectionTap.onNext(noiseIndex!)

        // Then
        XCTAssertEqual(observer.events, [.next(0, sut.soundDetectionModes.index(of: .cryRecognition)!)])
    }

    func testShouldChangeSoundModeAfterConfimation() {
        // Given
        let noiseIndex = sut.soundDetectionModes.index(of: .noiseDetection)

        // When
        UserDefaults.soundDetectionMode = .cryRecognition
        soundDetectionTap.onNext(noiseIndex!)

        // Then
        XCTAssertEqual(UserDefaults.soundDetectionMode, .noiseDetection)
    }

    func testShouldSentResultForSoundModeWhenReceivedOnConfimation() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Result<()>.self)
        sut.webSocketMessageResultPublisher.bind(to: observer).disposed(by: disposeBag)

        // When
        soundDetectionTap.onNext(0)

        scheduler.start()

        // Then
        XCTAssertEqual(observer.events, [.next(0, .success(()))])
    }

    func testShouldNotChangeSoundModeWhenNoConfimation() {
        // Given
        webSocketEventMessageService.shouldNotConfirmMessage = true
        let noiseIndex = sut.soundDetectionModes.index(of: .noiseDetection)

        // When
        UserDefaults.soundDetectionMode = .cryRecognition
        soundDetectionTap.onNext(noiseIndex!)

        // Then
        XCTAssertEqual(UserDefaults.soundDetectionMode, .cryRecognition)
    }

    func testShouldSentResultForSoundModeWhenReceivedNoConfimation() {
        // Given
        webSocketEventMessageService.shouldNotConfirmMessage = true
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Result<()>.self)
        sut.webSocketMessageResultPublisher.bind(to: observer).disposed(by: disposeBag)

        // When
        soundDetectionTap.onNext(0)

        scheduler.start()

        // Then
        XCTAssertEqual(observer.events, [.next(0, .failure(nil))])
    }

    func testShouldSentFailureWhenAttempingToChangeNoiseLevelOnDisconnect() {
        // Given
        webSocketEventMessageService.connectionStatusPublisher.on(.next(.disconnected))
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Result<()>.self)
        sut.webSocketMessageResultPublisher.bind(to: observer).disposed(by: disposeBag)

        // When
        noiseSliderValueOnEnded.onNext(0)

        // Then
        XCTAssertEqual(observer.events, [.next(0, .failure(nil))])
    }

    func testShouldNotChangeNoiseLevelWhenDisconnected() {
        // Given
        webSocketEventMessageService.connectionStatusPublisher.on(.next(.disconnected))
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)
        sut.noiseLoudnessFactorLimitPublisher.skip(1).bind(to: observer).disposed(by: disposeBag)
        let newLimit = 0
        let oldLimit = 10

        // When
        UserDefaults.noiseLoudnessFactorLimit = oldLimit
        noiseSliderValueOnEnded.onNext(newLimit)

        scheduler.start()

        // Then
        XCTAssertEqual(observer.events, [.next(0, oldLimit)])
    }

    func testShouldChangeLimitAfterConfimation() {
        // Given
        webSocketEventMessageService.shouldNotConfirmMessage = false
        let newLimit = 0
        let oldLimit = 10

        // When
        UserDefaults.noiseLoudnessFactorLimit = oldLimit
        noiseSliderValueOnEnded.onNext(newLimit)

        // Then
        XCTAssertEqual(UserDefaults.noiseLoudnessFactorLimit, newLimit)
    }

    func testShouldNotChangeNoiseLimitWhenNoConfimation() {
        // Given
        webSocketEventMessageService.shouldNotConfirmMessage = true
        let newLimit = 0
        let oldLimit = 10

        // When
        UserDefaults.noiseLoudnessFactorLimit = oldLimit
        noiseSliderValueOnEnded.onNext(newLimit)

        // Then
        XCTAssertEqual(UserDefaults.noiseLoudnessFactorLimit, oldLimit)
    }

    func testShouldSentResultForNoiseLevelWhenReceivedOnConfimation() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Result<()>.self)
        sut.webSocketMessageResultPublisher.bind(to: observer).disposed(by: disposeBag)

        // When
        noiseSliderValueOnEnded.onNext(0)

        scheduler.start()

        // Then
        XCTAssertEqual(observer.events, [.next(0, .success(()))])
    }

    func testShouldSentResultForNoiseLevelWhenReceivedNoConfimation() {
        // Given
        webSocketEventMessageService.shouldNotConfirmMessage = true
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Result<()>.self)
        sut.webSocketMessageResultPublisher.bind(to: observer).disposed(by: disposeBag)

        // When
        noiseSliderValueOnEnded.onNext(0)

        scheduler.start()

        // Then
        XCTAssertEqual(observer.events, [.next(0, .failure(nil))])
    }
    
}
