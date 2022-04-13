//
//  AddNewWeight.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 2/24/22.
//

import SwiftUI

struct AddNewWeight: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var viewModel: EnvironmentViewModel
    
    @State private var isWeightSavedVisible: Bool = false
    @FocusState private var textFieldFocused: Bool
    
    @Binding var isShowingAdjustedMacros: Bool
    @Binding var dismiss: Bool
        
    var body: some View {
        VStack {
            SectionHeaderText(title: "Add New Weight")
                .padding(.trailing, 15) //has 15 leading padding - this centers it
            
            if isWeightSavedVisible == true {
                Text("Weight Saved")
                    .font(.caption)
                    .foregroundColor(.green)
                    .bold()
                    .frame(height: 12)
            }
            
            VStack {
                HStack {
                    TextField("Weight", text: $viewModel.user.stringWeight)
                        .keyboardType(.decimalPad)
                        .focused($textFieldFocused)
                    Text("lbs")
                        .padding(.trailing, 3)
                }
                .padding(.top, 8)
                .padding(5)
                .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                DatePicker("Date", selection: $viewModel.user.weighInDate, displayedComponents: .date)
                    .padding(5)
                    .padding(.horizontal)
                
                Button {
                    saveButtonPressed()
                } label: {
                    Text("Save")
                        .bold()
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .tint(.buttonColor)
                .controlSize(.large)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.calorieColor)
            )
            .padding(.horizontal, 12)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button {
                        textFieldFocused = false
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
            }
        }
    }

    func saveButtonPressed() {
        
        let previousDate = viewModel.user.previousDate
        
        if viewModel.user.stringWeight != "" { //checking to makes sure weight isn't empty
            viewModel.saveWeight()
            withAnimation(.spring()) {
                isWeightSavedVisible.toggle()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.spring()) {
                    isWeightSavedVisible.toggle()
                }
            }
            
            if previousDate != viewModel.user.previousDate && viewModel.user.totalWeighIns >= 2 && viewModel.user.lastPreviousCalories != 0.0 {
                isShowingAdjustedMacros.toggle()
            }
            
            if dismiss {
                presentationMode.wrappedValue.dismiss()
            }
            
        } else {
            viewModel.saveWeight() //if weight is empty, run this to throw alert error
        }
    }
}

