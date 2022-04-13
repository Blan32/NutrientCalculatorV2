//
//  SectionHeaderText.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 2/17/22.
//

import SwiftUI

struct SectionHeaderText: View {
    
    var title: String
    
    var body: some View {
        Text(title)
            .font(.caption)
            .foregroundColor(.secondary)
            .bold()
            .padding(.leading, 15)
    }
}

struct SectionHeaderText_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeaderText(title: "MACROS")
    }
}
