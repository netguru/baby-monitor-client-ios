//
//  LullabyPlayerTests.swift
//  Baby MonitorTests
//

import XCTest
import AVKit
@testable import BabyMonitor

class LullabyPlayerTests: XCTestCase {

    func testShouldPlayLullabyFromLibrary() {
        // Given
        let lullaby = Lullaby(name: "test", identifier: "test", type: .bmLibrary)
        let urlMediaPlayer = URLMediaPlayerMock()
        let bundle = Bundle(for: type(of: self))
        let sut = LullabyPlayer(bundle: bundle, playerFactory: { item -> URLMediaPlayer in
            return urlMediaPlayer
        })
        
        // When
        sut.play(lullaby: lullaby)
        
        // Then
        XCTAssertTrue(urlMediaPlayer.isPlaying)
    }

    func testShouldPausePlayingCurrentLullabyAfterPlayingAnotherLullaby() {
        // Given
        let lullaby = Lullaby(name: "test", identifier: "test", type: .bmLibrary)
        let secondLullaby = Lullaby(name: "test2", identifier: "test2", type: .bmLibrary)
        let urlMediaPlayer = URLMediaPlayerMock()
        let secondUrlMediaPlayer = URLMediaPlayerMock()
        let bundle = Bundle(for: type(of: self))
        let sut = LullabyPlayer(bundle: bundle, playerFactory: { item -> URLMediaPlayer in
            let fileName = (item.asset as! AVURLAsset).url.pathComponents.last!
            if fileName == "test.mp3" {
                return urlMediaPlayer
            } else {
                return secondUrlMediaPlayer
            }
        })

        // When
        sut.play(lullaby: lullaby)
        sut.play(lullaby: secondLullaby)

        // Then
        XCTAssertFalse(urlMediaPlayer.isPlaying)
        XCTAssertTrue(secondUrlMediaPlayer.isPlaying)
    }
    
    func testShouldPauseLullaby() {
        // Given
        let lullaby = Lullaby(name: "test", identifier: "test", type: .bmLibrary)
        let urlMediaPlayer = URLMediaPlayerMock()
        let bundle = Bundle(for: type(of: self))
        let sut = LullabyPlayer(bundle: bundle, playerFactory: { item -> URLMediaPlayer in
            return urlMediaPlayer
        })
        
        // When
        sut.play(lullaby: lullaby)
        sut.pause()
        
        // Then
        XCTAssertFalse(urlMediaPlayer.isPlaying)
    }
    
    func testShouldResumeLullaby() {
        // Given
        let lullaby = Lullaby(name: "test", identifier: "test", type: .bmLibrary)
        let firstMediaPlayer = URLMediaPlayerMock()
        let secondMediaPlayer = URLMediaPlayerMock()
        let bundle = Bundle(for: type(of: self))
        var isSwitched = false
        let sut = LullabyPlayer(bundle: bundle, playerFactory: { item -> URLMediaPlayer in
            isSwitched.toggle()
            return isSwitched ? firstMediaPlayer : secondMediaPlayer
        })
        
        // When
        sut.play(lullaby: lullaby)
        sut.pause()
        sut.play(lullaby: lullaby)
        
        // Then
        XCTAssertTrue(firstMediaPlayer.isPlaying)
        XCTAssertFalse(secondMediaPlayer.isPlaying)
    }
}
