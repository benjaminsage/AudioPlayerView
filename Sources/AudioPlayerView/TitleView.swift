//
//  TitleView.swift
//  TabTest
//
//  Created by Benjamin Sage on 9/13/23.
//

import SwiftUI

struct TitleView: View {
    var title: String
    var subtitle: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .bold()

                Text(subtitle)
                    .foregroundColor(.secondary)
                    .fontWeight(.regular)
            }
            .font(.title3)
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.primary)
                    .padding(12)
                    .background {
                        Circle()
                            .fill(.regularMaterial)
                    }
            }
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(title: "Title", subtitle: "Subtitle")
    }
}
