//
//  AddNewWeightScreen.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 3/3/22.
//

import SwiftUI

struct AddNewWeightScreen: View {
        
    @EnvironmentObject var viewModel: EnvironmentViewModel
    
    @State private var dismiss: Bool = true
    @Binding var isShowingAdjustedMacros: Bool
    
    var body: some View {
        VStack {
            GraphView(user: viewModel.user)
            
            Spacer()
            
            AddNewWeight(isShowingAdjustedMacros: $isShowingAdjustedMacros, dismiss: $dismiss)
            
            Spacer()
        }
        .onAppear {
            viewModel.user.stringWeight = ""
            viewModel.user.weighInDate = Date()
        }
    }
}

