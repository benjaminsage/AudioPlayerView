//
//  ImageView.swift
//  TabTest
//
//  Created by Benjamin Sage on 9/13/23.
//

import SwiftUI

struct ImageView: View {
    @EnvironmentObject var model: AudioModel
    
    var animation: Animation {
        model.isPlaying ? expand : contract
    }
    
    var expand: Animation {
        .interpolatingSpring(stiffness: 250, damping: 17)
        .delay(0.1)
    }
    
    var contract: Animation {
        .easeInOut
    }
    
    var body: some View {
        Color.clear
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                Image("image")
                    .resizable()
                    .scaledToFill()
            }
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            .scaleEffect(model.isPlaying ? 1.02 : 0.8)
            .animation(animation, value: model.isPlaying)
    }
}

struct ImageView_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject var model = AudioModel.sample
        
        var body: some View {
            ImageView()
                .onTapGesture {
                    model.isPlaying.toggle()
                }
                .environmentObject(model)
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
