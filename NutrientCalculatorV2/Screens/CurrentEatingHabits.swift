//
//  CurrentEatingHabits.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 3/10/22.
//

import SwiftUI

struct CurrentEatingHabits: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: EnvironmentViewModel
    
    @FocusState private var focusedTextField: FormTextField?
    
    @State var showSkipView: Bool = false
    
    @Binding var newUser: Bool
    @Binding var showInstructions: Bool
    @Binding var showCurrentEatingHabits: Bool
    
    enum FormTextField {
        case fats
        case carbs
        case protein
        case calories
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Spacer()
                    
                    VStack {
                        Text("Please input your current nutritional data. If you have never tracked your calories or macros before we highly recommend logging your food for a week and before starting.")
                            .padding(.vertical)
                            .padding(.horizontal, 20)
                    }
                    Spacer()
                    
                    inputMacros
                        .padding()
                        .padding(.bottom, 20)
                    
                    weightChangeLastMonth
                    
                    saveButton
                    
                    skipButton
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        keyboardDownButton
                        Spacer()
                        keyboardNextButton
                    }
                }
            }
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.dismissButton)
            }
            .navigationTitle("Current Macros")
            .overlay(
                SkipMacroInputView(showSkipView: $showSkipView, newUser: $newUser, showInstructions: $showInstructions, showCurrentEatingHabits: $showCurrentEatingHabits)
                    .offset(y: showSkipView ? 0 : UIScreen.main.bounds.height)
            )
        }
    }
}

extension CurrentEatingHabits {
    
    //MARK: Keyboard Buttons
    private var keyboardDownButton: some View {
        Button {
            focusedTextField = nil
        } label: {
            Image(systemName: "keyboard.chevron.compact.down")
        }
    }
    
    private var keyboardNextButton: some View {
        Button {
            if focusedTextField == .fats {
                focusedTextField = .carbs
            } else if focusedTextField == .carbs {
                focusedTextField = .protein
            } else if focusedTextField == .protein {
                focusedTextField = .calories
            } else {
                focusedTextField = nil
            }
        } label: {
            Text(focusedTextField == .calories ? "Done" : "Next")
        }
    }
    
    //MARK: Functions
    func calculateCalories() -> String {
        return "\(calculateFats() + calculateCarbs() + calculateProtein())"
    }
    
    func calculateFats() -> Double {
        let fats = Double(viewModel.user.inputFats) ?? 0
        return 9 * fats
    }
    
    func calculateCarbs() -> Double {
        let carbs = Double(viewModel.user.inputCarbs) ?? 0
        return 4 * carbs
    }
    
    func calculateProtein() -> Double {
        let protein = Double(viewModel.user.inputProtein) ?? 0
        return 4 * protein
    }
    
    //MARK: inputMacros
    private var inputMacros: some View {
        VStack {
            
            SectionHeaderText(title: "Enter Your Current Macros:")
            
            HStack {
                Text("Fats:")
                    .bold()
                    .frame(width: 75, height: 30, alignment: .leading)
                    .padding(.horizontal)
                    .background(
                        Capsule()
                            .fill(Color.fatColor)
                    )
                
                TextField("Avg Fats", text: $viewModel.user.inputFats)
                    .padding(.leading)
                    .frame(width: UIScreen.main.bounds.width * 0.35, height: 30, alignment: .leading)
                    .background(
                        Capsule()
                            .stroke(Color.fatColor, lineWidth: 3)
                    )
                    .keyboardType(.decimalPad)
                    .focused($focusedTextField, equals: .fats)
            }
            
            HStack {
                Text("Carbs:")
                    .bold()
                    .frame(width: 75, height: 30, alignment: .leading)
                    .padding(.horizontal)
                    .background(
                        Capsule()
                            .fill(Color.carbColor)
                    )
                
                TextField("Avg Carbs", text: $viewModel.user.inputCarbs)
                    .padding(.leading)
                    .frame(width: UIScreen.main.bounds.width * 0.35, height: 30, alignment: .leading)
                    .background(
                        Capsule()
                            .stroke(Color.carbColor, lineWidth: 3)
                    )
                    .keyboardType(.decimalPad)
                    .focused($focusedTextField, equals: .carbs)
            }
            
            HStack {
                Text("Protein:")
                    .bold()
                    .frame(width: 75, height: 30, alignment: .leading)
                    .padding(.horizontal)
                    .background(
                        Capsule()
                            .fill(Color.proteinColor)
                    )
                
                TextField("Avg Protein", text: $viewModel.user.inputProtein)
                    .padding(.leading)
                    .frame(width: UIScreen.main.bounds.width * 0.35, height: 30, alignment: .leading)
                    .background(
                        Capsule()
                            .stroke(Color.proteinColor, lineWidth: 3)
                    )
                    .keyboardType(.decimalPad)
                    .focused($focusedTextField, equals: .protein)
            }
            
            HStack {
                Text("Calories:")
                    .bold()
                    .frame(width: 75, height: 30, alignment: .leading)
                    .padding(.horizontal)
                    .background(
                        Capsule()
                            .fill(Color.calorieColor)
                    )
                
                TextField(viewModel.user.inputFats != "" || viewModel.user.inputCarbs != "" || viewModel.user.inputProtein != "" ? calculateCalories() : "Avg Calories", text: $viewModel.user.inputCalories)
                    .padding(.leading)
                    .frame(width: UIScreen.main.bounds.width * 0.35, height: 30, alignment: .leading)
                    .background(
                        Capsule()
                            .stroke(Color.calorieColor, lineWidth: 3)
                    )
                    .keyboardType(.decimalPad)
                    .focused($focusedTextField, equals: .calories)
            }
        }
    }

    
    //MARK: weightChangeLastMonth
    private var weightChangeLastMonth: some View {
        VStack {
            Text("How much has your weight changed in the last month following these calories/macros?")
            
            HStack(spacing: 2) {
                Spacer()
                
                if viewModel.user.inputWeightChange > 0 {
                    Text("+")
                        .bold()
                } else if viewModel.user.inputWeightChange < 0 {
                    Text("-")
                        .bold()
                } else {
                    Text("=")
                        .opacity(0.0)
                }
                
                Text(String(format: "%.1f", abs(viewModel.user.inputWeightChange)))
                    .bold()
                
                Text("lbs")
                
                Spacer()
            }
            .padding(.vertical)
            .foregroundColor(viewModel.user.inputWeightChange > 0 ? Color.green : viewModel.user.inputWeightChange < 0 ? Color.red : Color.primary)
            
            Slider(value: $viewModel.user.inputWeightChange, in: -25.0...25.0, step: 0.5)
        }
        .padding(.horizontal, 20)
    }
    
    //MARK: Save Button
    private var saveButton: some View {
        Button {
            guard viewModel.isValidMacros else { return }
            
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
            Text("Save")
                .font(.title3)
                .bold()
                .frame(height: 30)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .tint(.buttonColor)
        .padding()
    }
    
    
    
    //MARK: Skip Button
    private var skipButton: some View {
        Button {
            withAnimation(.spring()) {
                showSkipView.toggle()
            }

        } label: {
            Text("Skip")
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderless)
        .tint(.red)
    }
}
