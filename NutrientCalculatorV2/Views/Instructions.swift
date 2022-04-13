//
//  Instructions.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 3/8/22.
//

import SwiftUI

struct Instructions: View {
        
    @Binding var showInstructions: Bool
    @State var animate: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Begin by entering your weight.")
                .bold()
                .font(.title2)
                .padding()
            
            Text("For optimal results update your weight in this app once per week, while sticking as closely to the calories/macros provided for you. This will allow for accurate adjustments to be made based on  your selected goal.")
                .padding()
            
            Spacer()
            
            continueButton
            
            Image(systemName: "arrowtriangle.down.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 20)
                .foregroundColor(.buttonColor)
                .padding(.bottom)
                .offset(y: animate ? -5 : 5)
        }
        .frame(height: 360)
        .frame(maxWidth: .infinity)
        .padding()
        .background(.thinMaterial)
        .cornerRadius(30)
        .onAppear {
            addAnimation()
        }
    }
}

extension Instructions {
    
    private var continueButton: some View {
        Button {
            withAnimation(.spring()) {
                showInstructions.toggle()
            }
            
        } label: {
            Text("Continue")
                .font(.title3)
                .bold()
                .frame(height: 30)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .tint(.buttonColor)
        .padding()
        .padding(.bottom, 15)
    }
    
    func addAnimation() {
        guard !animate else { return } //making sure we don't call it twice
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(
                Animation
                    .easeInOut(duration: 0.5)
                    .repeatForever()
            ) {
                animate.toggle()
            }
        }
    }
}
