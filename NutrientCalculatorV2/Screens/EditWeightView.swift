//
//  WeightEditView.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 2/28/22.
//

import SwiftUI

struct EditWeightView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var viewModel: EnvironmentViewModel
    @FocusState private var textFieldFocused: Bool
    
    @Binding var isShowingAdjustedMacros: Bool
    @Binding var dismiss: Bool
    
    var selectedIndex: Int
    
    var body: some View {
        VStack {
            GraphView(user: viewModel.user)
                .padding(.bottom, 20)
                    
            VStack {
                SectionHeaderText(title: "Edit Weight")
                    .padding(.trailing, 15) //has 15 leading padding - this centers it
                
                editWeightInfo
            }
    
            Spacer()
        }
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
        .onAppear {
            viewModel.user.stringWeight = "\(viewModel.user.reversedWeighIns.elements[selectedIndex].value[0])"
            viewModel.user.weighInDate = viewModel.user.reversedWeighIns.elements[selectedIndex].key
        }
    }
}



extension EditWeightView {
    
    //MARK: Edit Weight Info
    private var editWeightInfo: some View {
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
                

            HStack {
                Button {
                    deleteButtonPressed()
                } label: {
                    Text("Delete")
                        .bold()
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .padding(.trailing, 2)
                .padding(.leading)
                .padding(.bottom, 10)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .tint(Color.red)
                .controlSize(.large)
                
                Button {
                    saveButtonPressed()
                } label: {
                    Text("Save")
                        .bold()
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .padding(.leading, 2)
                .padding(.trailing)
                .padding(.bottom, 10)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .tint(Color.buttonColor)
                .controlSize(.large)
            }
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Cancel")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            .buttonStyle(.borderless)
            .buttonBorderShape(.capsule)
            .tint(Color.red)
            .controlSize(.large)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.calorieColor)
        )
        .padding(.horizontal, 12)
    }
    
    //MARK: Delete Button Pressed
    
    func deleteButtonPressed() {
        viewModel.deleteWeight(index: selectedIndex)
        presentationMode.wrappedValue.dismiss()
    }
    
    
    //MARK: Save Button Pressed
    func saveButtonPressed() {
        
        let previousDate = viewModel.user.previousDate
        
        if viewModel.user.stringWeight != "" { //checking to makes sure weight isn't empty
            
            viewModel.saveWeight()
            
            if previousDate != viewModel.user.previousDate && viewModel.user.totalWeighIns >= 2 {
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
