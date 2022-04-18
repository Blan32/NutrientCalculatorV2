//
//  MacroDisplay.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 2/17/22.
//

import SwiftUI

struct MacroDisplay: View {
    
    var title: String
    var fillColor: Color
    
    var body: some View {
        HStack {
            Text(title)
                .bold()
                .padding(.horizontal, 35)
            Spacer()
        }
        .frame(height: 35, alignment: .leading)
        .frame(maxWidth: .infinity)
        .background(
            Capsule()
                .fill(fillColor)
                .padding(.horizontal)
        )
    }
}

struct MacroDisplay_Previews: PreviewProvider {
    static var previews: some View {
        MacroDisplay(title: "Calories: ", fillColor: Color.calorieColor)
    }
}
