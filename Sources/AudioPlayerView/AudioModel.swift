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
    
    private var volumeView: MPVolumeView?
    private var volumeSlider: UISlider?
    
    var volume: Float {
        get {
            AVAudioSession.sharedInstance().outputVolume
        }
        set {
            MPVolumeView.setVolume(newValue)
        }
    }

    let audioURL = URL(string: "https://stylelife-challenge-c32f20f799b2.herokuapp.com/resources/day2.mp3")!
    
    init(url: URL?) {
        guard let url = url else { return }
        player = AVPlayer(url: url)
        addPeriodicTimeObserver()
    }
    
    deinit {
        volumeView = nil
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
            }
        }
    }
}

extension AudioModel {
    static let sample = AudioModel(url: URL(string: "https://samplelib.com/lib/preview/mp3/sample-3s.mp3"))
}

extension MPVolumeView {
    static func setVolume(_ volume: Float) -> Void {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
}
