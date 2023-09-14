//
//  VolumeView.swift
//  TabTest
//
//  Created by Benjamin Sage on 9/13/23.
//

import SwiftUI
import MediaPlayer

struct VolumeView: View {
    @EnvironmentObject var model: AudioModel
    
    var body: some View {
        Color.clear
            .frame(height: 40)
            .overlay {
//                HiddenVolumeSlider()
//                    .frame(width: 0, height: 0) // It's hidden, so it won't be visible in your SwiftUI view.

                HStack(spacing: 12) {
                    icon("speaker.fill", .trailing)
                    SliderView(value: $model.volume, temp: $model.tempVolume, max: 1.0, isDragging: $model.volumeDragging)
                    icon("speaker.wave.3.fill", .leading)
                }
            }
    }
    
    func icon(_ name: String, _ edge: UnitPoint) -> some View {
        Image(systemName: name)
            .foregroundColor(model.volumeDragging ? .primary : .secondary)
            .font(.footnote)
            .scaleEffect(model.volumeDragging ? .init(width: 1.2, height: 1.2) : .init(width: 1, height: 1), anchor: edge)
            .animation(.spring(), value: model.volumeDragging)
    }
}

struct HiddenVolumeSlider: UIViewRepresentable {
    func makeUIView(context: Context) -> MPVolumeView {
        let volumeView = MPVolumeView(frame: .zero)
        volumeView.showsRouteButton = false
        volumeView.showsVolumeSlider = false
        return volumeView
    }
    
    func updateUIView(_ uiView: MPVolumeView, context: Context) {
        // Update if necessary.
    }
}

struct VolumeView_Previews: PreviewProvider {
    static var previews: some View {
        VolumeView()
            .environmentObject(AudioModel.sample)
    }
}
