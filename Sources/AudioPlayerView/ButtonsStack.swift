//
//  ButtonsStack.swift
//  TabTest
//
//  Created by Benjamin Sage on 9/13/23.
//

import SwiftUI
import AVKit

struct ButtonsStack: View {
    @EnvironmentObject var model: AudioModel

    @State private var scale: CGFloat = 1
    @State private var backRotationAngle: Double = 0
    @State private var forwardRotationAngle: Double = 0
    
    var playBinding: Binding<Bool> {
        Binding<Bool>(
            get: { model.isPlaying },
            set: {
                if $0 != model.isPlaying {
                    model.isPlaying.toggle()
                    if let player = model.player {
                        if model.isPlaying {
                            player.play()
                        } else {
                            player.pause()
                        }
                    }
                    self.scale = 0
                }
            }
        )
    }
    
    var body: some View {
        HStack(spacing: 50) {
            Button {
                model.seek30(.reverse)
                withAnimation(.spring()) {
                    backRotationAngle -= 360
                }
            } label: {
                Image(systemName: "gobackward.30")
                    .rotationEffect(Angle(degrees: backRotationAngle))
            }
            
            Image(systemName: "play.fill")
                .opacity(0)
                .overlay {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)) {
                            self.playBinding.wrappedValue.toggle()
                        }
                    } label: {
                        Image(systemName: model.isPlaying ? "pause.fill" : "play.fill")
                    }
                    .scaleEffect(scale)
                    .onChange(of: model.isPlaying) { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)) {
                                scale = 1
                            }
                        }
                    }
                }
                .font(.system(size: 50))

            Button {
                model.seek30(.forward)
                withAnimation(.spring()) {
                    forwardRotationAngle += 360
                }
            } label: {
                Image(systemName: "goforward.30")
                    .rotationEffect(Angle(degrees: forwardRotationAngle))
            }
        }
        .buttonStyle(PlayButtonStyle())
        .font(.largeTitle)
        .foregroundColor(.primary)
        .padding(.horizontal)
    }
}

struct ButtonsStack_Previews: PreviewProvider {
    struct Preview: View {
        var body: some View {
            ButtonsStack()
                .environmentObject(AudioModel.sample)
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
