//
//  Arrows.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 2/22/22.
//

import SwiftUI

struct Arrows: View {
    
    let imageName: String
    
    var body: some View {
        if imageName != "" {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .frame(maxWidth: 10)
        } //else {
//            Image(systemName: "minus")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 10)
//        }
        
    }
}

struct Arrows_Previews: PreviewProvider {
    static var previews: some View {
        Arrows(imageName: "GreenUpArrow3")
    }
}
