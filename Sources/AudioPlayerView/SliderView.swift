//
//  SliderView.swift
//  TabTest
//
//  Created by Benjamin Sage on 9/13/23.
//

import SwiftUI

struct SliderView<Number: BinaryFloatingPoint>: View {
    @Binding var value: Number
    @Binding var temp: Number?
    var max: Number
    @Binding var isDragging: Bool

    @State private var hitEdge = false
    @State private var barWidth: CGFloat = 1
    private let barHeight: CGFloat = 7

    var barFactor: Number {
        let value = clamped((temp ?? value) / max)
        guard value.isFinite else { return 0 }
        return value
    }

    var body: some View {
        GeometryReader { g in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.tertiary)

                Rectangle()
                    .fill(isDragging ? .primary : .secondary)
                    .frame(width: g.size.width * CGFloat(barFactor))
            }
            .onAppear {
                barWidth = g.size.width
            }
            .onChange(of: g.size.width) { width in
                if !isDragging {
                    barWidth = width
                }
            }
        }
        .frame(
            width: isDragging ? barWidth * 1.05 : nil,
            height: isDragging ? barHeight * 3 : barHeight
        )
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged(onDragChanged)
                .onEnded(onDragEnded)
        )
        .clipShape(Capsule())
        .animation(.spring(), value: isDragging)
    }

    func onDragChanged(drag: DragGesture.Value) {
        isDragging = true
        let dragOffset = drag.translation.width
        let valueChange = dragOffset / barWidth * CGFloat(max)
        if !hitEdge, let currentTemp = temp, currentTemp < 0 || currentTemp > max {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            hitEdge = true
        }
        temp = value + Number(valueChange)
    }

    func onDragEnded(_ value: DragGesture.Value) {
        self.value = clamped(temp ?? 0)
        temp = nil
        isDragging = false
        hitEdge = false
    }

    func clamped(_ value: Number) -> Number {
        return min(Swift.max(value, 0), max)
    }
}

struct SliderView_Previews: PreviewProvider {
    struct Preview: View {
        @State private var value: Double = 0
        @State private var temp: Double?
        @State private var isDragging = false
        
        @State private var showSheet = false
        
        var body: some View {
            Button("tappable") {
                showSheet = true
            }
            .sheet(isPresented: $showSheet) {
                SliderView(value: $value, temp: $temp, max: 1000, isDragging: $isDragging)
            }
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
