//
//  WeightView.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 2/21/22.
//

import SwiftUI
import OrderedCollections

struct WeightHistoryView: View {
    
    @EnvironmentObject var viewModel: EnvironmentViewModel
    @State private var isShowingAdjustedMacros: Bool = false
    @State private var showActionSheet: Bool = false
    @State private var dismiss: Bool = true
    @State private var weightCount: Int = 0
        
    var body: some View {
        NavigationView {
            VStack {
                GraphView(user: viewModel.user)
                    .padding(.vertical)
                
                userWeighInInfo

            }
            .navigationTitle("Weight History")
            .navigationBarItems(trailing: addButton)
            .fullScreenCover(isPresented: $isShowingAdjustedMacros) {
                AdjustedMacroView(isShowingAdjustedMacros: $isShowingAdjustedMacros)
            }
        }
        .onAppear {
            viewModel.retrieveUser()
            viewModel.user.stringWeight = ""
            viewModel.user.weighInDate = Date()
        }
    }
}



extension WeightHistoryView {
    
    //MARK: User Weigh-in Info
    private var userWeighInInfo: some View {
        List {
            Section {
                ForEach(viewModel.user.reversedWeighIns.keys.indices, id: \.self) { index in
                    NavigationLink {
                        EditWeightView(isShowingAdjustedMacros: $isShowingAdjustedMacros, dismiss: $dismiss, selectedIndex: index)
                        
                    } label: {
                        HStack(spacing: 8) {
                            
                            //MARK: Weight
                            Text("\(viewModel.user.reversedWeighIns.elements[index].value[0], specifier: "%.1f")")
                                .frame(width: 60)
                            
                            //MARK: Date
                            Text(dateFormatter(date: viewModel.user.reversedWeighIns.elements[index].key))
                                .frame(width: 67)
                            
                            //MARK: Calories
                            if viewModel.user.reversedWeighIns.elements[index].value[1] == 0.0 {
                                Text("")
                                    .frame(width: 60, height: 21)
                            } else {
                                Text("\(viewModel.user.reversedWeighIns.elements[index].value[1], specifier: "%.f")")
                                    .frame(width: 60)
                                    .background(Color.calorieColor)
                                    .cornerRadius(20)
                            }
                            
                            //MARK: Fats
                            if viewModel.user.reversedWeighIns.elements[index].value[2] == 0.0 {
                                Text("")
                                    .frame(width: 42, height: 21)
                            } else {
                                Text("\(viewModel.user.reversedWeighIns.elements[index].value[2], specifier: "%.f")")
                                    .frame(width: 42)
                                    .background(Color.fatColor)
                                    .cornerRadius(20)
                            }
                            
                            //MARK: Carbs
                            if viewModel.user.reversedWeighIns.elements[index].value[3] == 0.0 {
                                Text("")
                                    .frame(width: 42, height: 21)
                            } else {
                                Text("\(viewModel.user.reversedWeighIns.elements[index].value[3], specifier: "%.f")")
                                    .frame(width: 42)
                                    .background(Color.carbColor)
                                    .cornerRadius(20)
                            }
                            
                            //MARK: Protein
                            if viewModel.user.reversedWeighIns.elements[index].value[4] == 0.0 {
                                Text("")
                                    .frame(width: 42, height: 21)
                            } else {
                                Text("\(viewModel.user.reversedWeighIns.elements[index].value[4], specifier: "%.f")")
                                    .frame(width: 42)
                                    .background(Color.proteinColor)
                                    .cornerRadius(20)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            } header: {
                HStack(spacing: 8) {
                    Text("Weight")
                        .bold()
                        .frame(width: 60)
                    Text("Date")
                        .bold()
                        .frame(width: 67)
                    Text("Cal")
                        .bold()
                        .frame(width: 60)
                        .background(Color.calorieColor)
                        .cornerRadius(20)
                    Text("F")
                        .bold()
                        .frame(width: 42)
                        .background(Color.fatColor)
                        .cornerRadius(20)
                    Text("C")
                        .bold()
                        .frame(width: 42)
                        .background(Color.carbColor)
                        .cornerRadius(20)
                    Text("P")
                        .bold()
                        .frame(width: 42)
                        .background(Color.proteinColor)
                        .cornerRadius(20)
                }
                .foregroundColor(.primary)
                .font(.headline)
            }
        }
        .listStyle(InsetListStyle())
    }
    
    
    
    //MARK: Add Button
    private var addButton: some View {
        NavigationLink {
            withAnimation(.spring()) {
                AddNewWeightScreen(isShowingAdjustedMacros: $isShowingAdjustedMacros)
            }
        } label: {
            Image(systemName: "plus.circle.fill")
                .foregroundColor(.green)
        }
    }
    
    func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        return formatter.string(from: date)
    }
}
