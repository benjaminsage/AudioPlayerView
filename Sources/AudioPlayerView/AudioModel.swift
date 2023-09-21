//
//  AudioModel.swift
//  TabTest
//
//  Created by Benjamin Sage on 9/13/23.
//

import Foundation
import AVKit
import CoreGraphics
import MediaPlayer
import SwiftUI

class AudioModel: ObservableObject {
    @Published var player: AVPlayer?
    @Published var isPlaying: Bool = false
    @Published var playbackProgress: Double = 0.0
    @Published var currentTime: Double = 0.0
    @Published var tempTime: Double? {
        didSet {
            if tempTime == nil {
                let time = CMTime(seconds: currentTime, preferredTimescale: 600)
                let tolerance = CMTime.zero
                player?.seek(to: time, toleranceBefore: tolerance, toleranceAfter: tolerance)
            }
        }
    }
    @Published var duration: Double = 0.0
    @Published var timeDragging = false
    
    @Published var tempVolume: Float?
    @Published var volumeDragging = false
    
    var volume: Float {
        get {
            player?.volume ?? 0
        } set {
            player?.volume = newValue
        }
    }
    
    let audioURL = URL(string: "https://stylelife-challenge-c32f20f799b2.herokuapp.com/resources/day2.mp3")!
    
    init(url: URL?) {
        guard let url = url else { return }
        player = AVPlayer(url: url)
        addPeriodicTimeObserver()
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
        setupRemoteTransportControls()
    }
    
    enum Direction {
        case forward, reverse
    }
    
    func seek30(_ direction: Direction) {
        guard let currentPlayerTime = player?.currentTime() else {
            return
        }
        
        var newTime: CMTime
        
        switch direction {
        case .forward:
            newTime = currentPlayerTime + CMTime(seconds: 30, preferredTimescale: 600)
        case .reverse:
            newTime = currentPlayerTime - CMTime(seconds: 30, preferredTimescale: 600)
        }
        
        if let duration = player?.currentItem?.duration {
            if newTime >= duration {
                newTime = duration
            } else if newTime <= CMTime.zero {
                newTime = .zero
            }
        }
        
        let tolerance = CMTime.zero
        player?.seek(to: newTime, toleranceBefore: tolerance, toleranceAfter: tolerance)
    }

    func addPeriodicTimeObserver() {
        player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 600), queue: DispatchQueue.main) { [self] time in
            if let duration = self.player?.currentItem?.duration {
                self.duration = duration.seconds
                currentTime = time.seconds

                var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String: Any]()
                nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            }
        }
    }
    
    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player?.rate == 0.0 {
                self.player?.play()
                return .success
            }
            return .commandFailed
        }

        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player?.rate == 1.0 {
                self.player?.pause()
                return .success
            }
            return .commandFailed
        }

        commandCenter.skipForwardCommand.preferredIntervals = [30]
        commandCenter.skipForwardCommand.addTarget { [unowned self] event in
            self.seek30(.forward)
            return .success
        }

        commandCenter.skipBackwardCommand.preferredIntervals = [30]
        commandCenter.skipBackwardCommand.addTarget { [unowned self] event in
            self.seek30(.reverse)
            return .success
        }

        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget { [unowned self] event in
            if let event = event as? MPChangePlaybackPositionCommandEvent {
                self.player?.seek(to: CMTime(seconds: event.positionTime, preferredTimescale: 600), completionHandler: { _ in

                })
                return .success
            }
            return .commandFailed
        }
    }
    func updateNowPlayingInfo(title: String, artist: String, image: UIImage?) {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyArtist] = artist

        if let duration = player?.currentItem?.duration.seconds {
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        }

        if let image = image {
            let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in
                return image
            }
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}

extension AudioModel {
    static let sample = AudioModel(url: URL(string: "https://samplelib.com/lib/preview/mp3/sample-3s.mp3")!)
}
