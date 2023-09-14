//
//  ImageView.swift
//  TabTest
//
//  Created by Benjamin Sage on 9/13/23.
//

import SwiftUI

struct ImageView: View {
    @EnvironmentObject var model: AudioModel
    var image: Image
    
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
                image
                    .resizable()
                    .scaledToFill()
            }
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: .secondary.opacity(0.3), radius: 25, x: 0, y: 15)
            .scaleEffect(model.isPlaying ? 1.02 : 0.75)
            .animation(animation, value: model.isPlaying)
    }
}

struct ImageView_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject var model = AudioModel.sample
        
        var body: some View {
            ImageView(image: Image(systemName: "checkmark"))
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
