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
            } label: {
                Image(systemName: "gobackward.30")
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
                .font(.system(size: 43))

            Button {
                model.seek30(.forward)
            } label: {
                Image(systemName: "goforward.30")
            }
        }
        .buttonStyle(PlayButtonStyle())
        .font(.title)
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
