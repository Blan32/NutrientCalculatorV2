//
//  ActivityInfo.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 2/19/22.
//

import SwiftUI

struct ActivityInfo: View {
    
    @Binding var showActivityInfo: Bool
    
    var body: some View {
        
        VStack {
            Text("Activity Levels")
                .bold()
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("None:")
                        .bold()
                        //.italic()
                    Text("Little to no exercise")
                }
                HStack {
                    Text("Low:")
                        .bold()
                        //.italic()
                        .foregroundColor(.blue)
                    Text("Exercise 1-2 days / week")
                }
                HStack {
                    Text("Moderate:")
                        .bold()
                        //.italic()
                        .foregroundColor(.green)
                    Text("Exercise 3-5 days / week")
                }
                HStack {
                    Text("High:")
                        .bold()
                        //.italic()
                        .foregroundColor(.yellow)
                    Text("Exercise 6-7 days / week")
                }
                HStack {
                    Text("Extreme:")
                        .bold()
                        //.italic()
                        .foregroundColor(.red)
                    Text("Exercise 8+ times / week")
                }
            }
            .padding(.vertical)
            
            Button {
                withAnimation(.spring()) {
                    showActivityInfo.toggle()
                }
            } label: {
                Text("Dismiss")
                    .bold()
                    .font(.headline)
                    .frame(width: 200)
            }
            .buttonStyle(.borderless)
            //.buttonBorderShape(.capsule)
            .tint(.red)
            .controlSize(.regular)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .cornerRadius(30)
    }
}

//struct ActivityInfo_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityInfo()
//    }
//}
