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
        
        Text(title)
            .bold()
            .padding(.leading)
            .frame(width: UIScreen.main.bounds.width * 0.5, height: 30, alignment: .leading)
            .background(
                Capsule()
                    .fill(fillColor)
            )
    }
}

struct MacroDisplay_Previews: PreviewProvider {
    static var previews: some View {
        MacroDisplay(title: "Calories: ", fillColor: Color.calorieColor)
    }
}
