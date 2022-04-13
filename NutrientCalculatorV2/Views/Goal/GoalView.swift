//
//  GoalView.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 2/26/22.
//

import SwiftUI

struct GoalView: View {
    
    @EnvironmentObject var viewModel: EnvironmentViewModel
    @Binding var isShowingGoalInfo: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                SectionHeaderText(title: "Goal: ")
                    .padding(.leading, 10)
                if viewModel.user.goal == "" {
                    Text("Placeholder")
                        .font(.body)
                        .bold()
                        .opacity(0.0)
                }
                Text(viewModel.user.goal + " " + getGoalSymbol())
                    .font(.body)
                    .bold()
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "info.circle") //Add this popup in later!
                    .padding(.trailing, 25)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isShowingGoalInfo.toggle()
                        }
                    }
            }
            
            GoalDescriptions()
            
            Picker(selection: $viewModel.user.goal) {
                ForEach(viewModel.goalOptions, id: \.self) { goal in
                    Text(goal).tag(goal)
                }
            } label: {
                Text("Goal")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            //.padding(.bottom, 5)
        }
    }
    
    func getGoalSymbol() -> String {
        if viewModel.user.goal == "Fat Loss" {
            return "🔥"
        } else if viewModel.user.goal == "Maintenance" {
            return "🏋️‍♂️"
        } else if viewModel.user.goal == "Muscle Growth" {
            return "💪"
        } else {
            return ""
        }
    }
}

//struct GoalView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalView()
//    }
//}
