//
//  DashboardView.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 2/17/22.
//

import SwiftUI

struct DashboardView: View {
    
    @EnvironmentObject var viewModel: EnvironmentViewModel
    @Environment(\.colorScheme) var colorScheme
    
    //Text that pops up confirming profile info is saved
    @State private var isWeightSavedVisible: Bool = false
    @State private var isAddNewWeightVisible: Bool = false
    @State private var isShowingAdjustedMacros: Bool = false
    @State private var isShowingGoalInfo: Bool = false
    @State private var dismiss: Bool = false
    
    @Binding var showInstructions: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack(spacing: 10) {
                    currentMacros
                    
                    mostRecentWeight
                }
                .frame(height: 170)
                
                macroChangeButton
                
                GoalView(isShowingGoalInfo: $isShowingGoalInfo)
                    .padding(.bottom, 25)
                
                AddNewWeight(isShowingAdjustedMacros: $isShowingAdjustedMacros, dismiss: $dismiss)
                    .padding(.horizontal, 6)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showInstructions = false
                        }
                    }
                    
                Spacer()
            }
            .fullScreenCover(isPresented: $isShowingAdjustedMacros) {
                AdjustedMacroView(isShowingAdjustedMacros: $isShowingAdjustedMacros)
            }
            .overlay(content: {
                GoalInfo(isShowingGoalInfo: $isShowingGoalInfo)
                    .offset(y: isShowingGoalInfo ? 0 : UIScreen.main.bounds.height)
            })
            .onAppear {
                viewModel.retrieveUser()
                viewModel.user.stringWeight = ""
                viewModel.user.weighInDate = Date()
            }
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.dismissButton)
            }
            .navigationTitle(Text("Dashboard"))
        }
    }
}


extension DashboardView {
    
    //MARK: CURRENT MACROS
    private var currentMacros: some View {
        VStack(alignment: .leading) {
            SectionHeaderText(title: "Current Macros")
            
            if viewModel.user.totalWeighIns == 0 {
                MacroDisplay(title: "Calories: ", fillColor: Color.calorieColor)
                MacroDisplay(title: "Fats: ", fillColor: Color.fatColor)
                MacroDisplay(title: "Carbs: ", fillColor: Color.carbColor)
                MacroDisplay(title: "Protein: ", fillColor: Color.proteinColor)
            } else {
                Text("Calories: \(viewModel.user.previousCalories, specifier: "%.f")")
                    .bold()
                    .padding(.leading)
                    .frame(width: UIScreen.main.bounds.width * 0.5, height: 30, alignment: .leading)
                    .background(
                        Capsule()
                            .fill(Color.calorieColor)
                    )
                Text("Fats: \(viewModel.user.previousFats, specifier: "%.f") g")
                    .bold()
                    .padding(.leading)
                    .frame(width: UIScreen.main.bounds.width * 0.5, height: 30, alignment: .leading)
                    .background(
                        Capsule()
                            .fill(Color.fatColor)
                    )
                Text("Carbs: \(viewModel.user.previousCarbs, specifier: "%.f") g")
                    .bold()
                    .padding(.leading)
                    .frame(width: UIScreen.main.bounds.width * 0.5, height: 30, alignment: .leading)
                    .background(
                        Capsule()
                            .fill(Color.carbColor)
                    )
                Text("Protein: \(viewModel.user.previousProtein, specifier: "%.f") g")
                    .bold()
                    .padding(.leading)
                    .frame(width: UIScreen.main.bounds.width * 0.5, height: 30, alignment: .leading)
                    .background(
                        Capsule()
                            .fill(Color.proteinColor)
                    )
            }
        }
    }
    
    //MARK: MOST RECENT WEIGHT
    private var mostRecentWeight: some View {
        VStack(alignment: .center) {
            SectionHeaderText(title: "Most Recent Weight")
                .padding(.trailing, 15)
            
            VStack {
                if viewModel.user.previousWeight == 0.0 {
                    Text("")
                        .font(.title2)
                        .bold()
                        .padding(.top, 40)
                        .padding(.bottom, 5)
                    Text("")
                        .bold()
                } else {
                    Text("\(viewModel.user.previousWeight, specifier: "%.1f") lbs")
                        .font(.title2)
                        .bold()
                        .padding(.top, 40)
                        .padding(.bottom, 5)
                    Text(viewModel.user.previousDate)
                        .bold()
                }

                Spacer()
            }
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.calorieColor, lineWidth: 4)
                    .frame(width: 145, height: 145)
            )
        }
    }
    
    //MARK: Macro Change Button
    private var macroChangeButton: some View {
        
        VStack {
            if viewModel.user.totalWeighIns >= 2 && viewModel.user.lastPreviousCalories != 0.0 {
                Button {
                    isShowingAdjustedMacros.toggle()
                } label: {
                    Text("Previous Macro Changes")
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .tint(.buttonColor)
                .controlSize(.small)
                .padding()
            } else {
                Text("")
                    .padding(.bottom)
            }
        }
        .background(
            Capsule()
                .fill(Color.calorieColor)
                .frame(height: 30)
                .padding(.horizontal, 15)
            )
        .padding(.horizontal, 15)
    }
}
