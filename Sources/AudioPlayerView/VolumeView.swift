//
//  VolumeView.swift
//  TabTest
//
//  Created by Benjamin Sage on 9/13/23.
//

import SwiftUI

struct VolumeView: View {
    @EnvironmentObject var model: AudioModel
    
    var body: some View {
        Color.clear
            .frame(height: 40)
            .overlay {
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

struct VolumeView_Previews: PreviewProvider {
    static var previews: some View {
        VolumeView()
            .environmentObject(AudioModel.sample)
    }
}
