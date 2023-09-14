//
//  AudioPlayerView.swift
//  
//
//  Created by Benjamin Sage on 9/14/23.
//

import SwiftUI

public struct AudioPlayerView: View {
    @StateObject var model: AudioModel
    
    var title: String = "Title"
    var subtitle: String = "Subtitle"
    
    public init(url: String, title: String, subtitle: String) {
        _model = StateObject(wrappedValue: AudioModel(url: url))
        self.title = title
        self.subtitle = subtitle
    }
        
    public var body: some View {
        VStack {
            ImageView()
                .frame(maxHeight: .infinity)

            TitleView(title: title, subtitle: subtitle)
                .padding(.top, 32)
                .padding(.bottom, 16)
            
            SeekerView()
            
            ButtonsStack()
                .padding(.bottom, 36)
            
            VolumeView()
                        
            AirPlayButton()
                .frame(width: 48, height: 48)

        }
        .padding(.horizontal, 32)
        .onDisappear {
            model.player?.pause()
        }
        .environmentObject(model)
    }
}

struct AudioPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        AudioPlayerView(
            url: "https://samplelib.com/lib/preview/mp3/sample-3s.mp3",
            title: "Sample", subtitle: "Subtitle")
    }
}
