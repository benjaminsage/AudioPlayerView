//
//  AirPlayButton.swift
//  TabTest
//
//  Created by Benjamin Sage on 9/13/23.
//

import SwiftUI
import AVKit

struct AirPlayButton: UIViewRepresentable {
    func makeUIView(context: Context) -> AVRoutePickerView {
        let routePickerView = AVRoutePickerView()
        routePickerView.activeTintColor = .secondaryLabel
        routePickerView.tintColor = .secondaryLabel
        return routePickerView
    }

    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {

    }
}

struct AirPlayButton_Previews: PreviewProvider {
    static var previews: some View {
        AirPlayButton()
    }
}
