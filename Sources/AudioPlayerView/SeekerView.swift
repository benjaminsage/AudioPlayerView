//
//  SeekerView.swift
//  TabTest
//
//  Created by Benjamin Sage on 9/13/23.
//

import SwiftUI

struct SeekerView: View {
    @EnvironmentObject var model: AudioModel
    
    var body: some View {
        Color.clear
            .frame(height: 50)
            .overlay {
                VStack {
                    SliderView(value: $model.currentTime, temp: $model.tempTime, max: model.duration, isDragging: $model.timeDragging)
                    musicTextView
                }
                .animation(.spring(), value: model.timeDragging)
                .frame(maxWidth: .infinity)
            }
    }
    
    var displayTime: Double {
        model.tempTime ?? model.currentTime
    }
    
    var musicTextView: some View {
        HStack {
            musicLabel(for: displayTime)
            Spacer()
            musicLabel(for: displayTime - model.duration)
        }
    }
    
    func musicLabel(for time: Double) -> some View {
        Text(timeString(for: time) ?? "--:--")
            .foregroundStyle(model.timeDragging ? .primary : .tertiary)
            .font(.caption2)
    }
    
    func timeString(for time: Double) -> String? {
        guard time.isFinite else { return nil }
        let absoluteTime = abs(time)

        let hours = Int(absoluteTime) / 3600
        let minutes = Int(absoluteTime) / 60 % 60
        let seconds = Int(absoluteTime) % 60

        let sign = time < 0 ? "-" : ""

        if hours > 0 {
            return String(format: "\(sign)%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "\(sign)%i:%02i", minutes, seconds)
        }
    }
}

struct SeekerView_Previews: PreviewProvider {
    static var previews: some View {
        SeekerView()
            .padding()
            .environmentObject(AudioModel.sample)
    }
}
