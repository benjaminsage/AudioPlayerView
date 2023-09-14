//
//  PlayButtonStyle.swift
//  TabTest
//
//  Created by Benjamin Sage on 9/13/23.
//

import SwiftUI

struct PlayButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .padding(8)
            .background {
                Circle()
                    .fill(.regularMaterial)
                    .scaleEffect(configuration.isPressed ? 1 : 1.2)
                    .opacity(configuration.isPressed ? 1 : 0)
            }
            .animation(.easeOut, value: configuration.isPressed)
    }
}
