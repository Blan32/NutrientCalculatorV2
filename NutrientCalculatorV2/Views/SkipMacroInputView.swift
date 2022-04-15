//
//  SkipMacroInputView.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 3/14/22.
//

import SwiftUI

struct SkipMacroInputView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: EnvironmentViewModel
    
    @Binding var showSkipView: Bool
    @Binding var newUser: Bool
    @Binding var showInstructions: Bool
    @Binding var showCurrentEatingHabits: Bool
    
    var body: some View {
        
        VStack {
            Text("Skip This?")
                .bold()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("You can choose to skip this section, but it may take a bit longer find your body's ideal calorie and macronutrient targets.")
                    .padding(.vertical)
                    .padding(.horizontal, 20)
            }
            .padding(.vertical)
            
            skipButton
                .padding(.bottom)
            
            dismissButton
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .cornerRadius(30)
    }
}

extension SkipMacroInputView {
    
    //MARK: Skip Button
    private var skipButton: some View {
        Button {
            guard viewModel.isValidForm else { return }
            viewModel.user.inputCalories = ""
            viewModel.user.inputFats = ""
            viewModel.user.inputCarbs = ""
            viewModel.user.inputProtein = ""
            newUser.toggle()
            showCurrentEatingHabits.toggle()
            presentationMode.wrappedValue.dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 0.5, dampingFraction: 1.0, blendDuration: 1.0)) {
                    showInstructions.toggle()
                }
            }
            viewModel.saveProfile()
        } label: {
            Text("Skip")
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .tint(.red)
    }
    
    //MARK: Dismiss Button
    private var dismissButton: some View {
        Button {
            withAnimation(.spring()) {
                showSkipView.toggle()
            }
        } label: {
            Text("Dismiss")
                .bold()
                .font(.headline)
                .frame(width: 200)
        }
        .buttonStyle(.borderless)
        .tint(.red)
        .controlSize(.regular)
    }
}
