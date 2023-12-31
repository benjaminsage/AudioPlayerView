//
//  AudioPlayerView.swift
//  
//
//  Created by Benjamin Sage on 9/14/23.
//

import SwiftUI
import MediaPlayer

public struct AudioPlayerView: View {
    @StateObject var model: AudioModel
    
    var title: String = "Title"
    var subtitle: String = "Subtitle"
    var image: UIImage
    
    public init(url: URL?, title: String, subtitle: String, image: UIImage) {
        _model = StateObject(wrappedValue: AudioModel(url: url))
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
        
    public var body: some View {
        VStack {
            ImageView(image: Image(uiImage: image))
                .frame(maxHeight: .infinity)

            TitleView(title: title, subtitle: subtitle)
                .padding(.top, 32)
                .padding(.bottom, 16)
            
            SeekerView()
            
            ButtonsStack()
                .padding(.top, 20)
                .padding(.bottom, 36)
            
            VolumeView()
                        
            AirPlayButton()
                .frame(width: 48, height: 48)

        }
        .padding(.horizontal, 32)
        .onAppear {
            model.updateNowPlayingInfo(title: title, artist: subtitle, image: image)
        }
        .environmentObject(model)
    }
}

struct AudioPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        AudioPlayerView(
            url: URL(string: "https://samplelib.com/lib/preview/mp3/sample-3s.mp3"),
            title: "Sample", subtitle: "Subtitle", image: UIImage(systemName: "checkmark") ?? UIImage())
    }
}
