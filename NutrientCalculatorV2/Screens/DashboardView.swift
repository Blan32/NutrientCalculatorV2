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
    @State private var dismiss: Bool = false
    
    @Binding var showInstructions: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    currentMacros
                        .padding(.bottom)
                    
                    mostRecentWeight
                }
                
                macroChangeButton
                
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
        VStack(alignment: .center) {
            SectionHeaderText(title: "Current Macros")
            
            if viewModel.user.totalWeighIns == 0 {
                MacroDisplay(title: "Calories: ", fillColor: Color.calorieColor)
                MacroDisplay(title: "Fats: ", fillColor: Color.fatColor)
                MacroDisplay(title: "Carbs: ", fillColor: Color.carbColor)
                MacroDisplay(title: "Protein: ", fillColor: Color.proteinColor)
            } else {
                HStack(spacing: 1) {
                    Text("Calories: ")
                        .bold()
                    Text("\(viewModel.user.previousCalories, specifier: "%.f")")
                    Spacer()
                    Text("(\(viewModel.user.previousCalories * 0.95, specifier: "%.f") - \(viewModel.user.previousCalories * 1.05, specifier: "%.f"))")
                }
                .padding(.horizontal, 35)
                .frame(height: 35, alignment: .leading)
                .background(
                    Capsule()
                        .fill(Color.calorieColor)
                        .padding(.horizontal)
                )
                HStack(spacing: 1) {
                    Text("Fats: ")
                        .bold()
                    Text("\(viewModel.user.previousFats, specifier: "%.f") g")
                    Spacer()
                    Text("(\(viewModel.user.previousFats * 0.95, specifier: "%.f") - \(viewModel.user.previousFats * 1.05, specifier: "%.f")) g")
                }
                .padding(.horizontal, 35)
                .frame(height: 35, alignment: .leading)
                .background(
                    Capsule()
                        .fill(Color.fatColor)
                        .padding(.horizontal)
                )
                HStack(spacing: 1) {
                    Text("Carbs: ")
                        .bold()
                    Text("\(viewModel.user.previousCarbs, specifier: "%.f") g")
                    Spacer()
                    Text("(\(viewModel.user.previousCarbs * 0.95, specifier: "%.f") - \(viewModel.user.previousCarbs * 1.05, specifier: "%.f")) g")
                }
                .padding(.horizontal, 35)
                .frame(height: 35, alignment: .leading)
                .background(
                    Capsule()
                        .fill(Color.carbColor)
                        .padding(.horizontal)
                )
                HStack(spacing: 1) {
                    Text("Protein: ")
                        .bold()
                    Text("\(viewModel.user.previousProtein, specifier: "%.f") g")
                    Spacer()
                    Text("(\(viewModel.user.previousProtein * 0.95, specifier: "%.f") - \(viewModel.user.previousProtein * 1.05, specifier: "%.f")) g")
                }
                .padding(.horizontal, 35)
                .frame(height: 35, alignment: .leading)
                .background(
                    Capsule()
                        .fill(Color.proteinColor)
                        .padding(.horizontal)
                )
            }
        }
    }
    
    //MARK: MOST RECENT WEIGHT
    private var mostRecentWeight: some View {
        VStack(alignment: .center) {
            SectionHeaderText(title: "Most Recent Weight")
                //.padding(.trailing, 15)
                //.padding()
            
            HStack {
                if viewModel.user.previousWeight == 0.0 {
                    Text("Weight:")
                        .bold()
                    Spacer()
                    Text("Date:")
                        .bold()
                        .frame(width: 200)
                } else {
                    Text("Weight: ")
                        .bold()
                    Text("\(viewModel.user.previousWeight, specifier: "%.1f") lbs")
                    Spacer()
                    HStack {
                        Text("Date: ")
                            .bold()
                        Text(viewModel.user.previousDate)
                    }
                    .frame(width: 130)
                }
            }
            .padding(.horizontal, 35)
            .frame(height: 35)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.calorieColor, lineWidth: 4)
                    .frame(height: 35)
                    .padding()
            )
            
//            VStack {
//                if viewModel.user.previousWeight == 0.0 {
//                    Text("")
//                        .font(.title2)
//                        .bold()
//                        .padding(.top, 40)
//                        .padding(.bottom, 5)
//                    Text("")
//                        .bold()
//                } else {
//                    Text("\(viewModel.user.previousWeight, specifier: "%.1f") lbs")
//                        .font(.title2)
//                        .bold()
//                        .padding(.top, 40)
//                        .padding(.bottom, 5)
//                    Text(viewModel.user.previousDate)
//                        .bold()
//                }
//
//                Spacer()
//            }
//            .background(
//                RoundedRectangle(cornerRadius: 25)
//                    .stroke(Color.calorieColor, lineWidth: 4)
//                    .frame(width: 145, height: 145)
//            )
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
                        .bold()
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
