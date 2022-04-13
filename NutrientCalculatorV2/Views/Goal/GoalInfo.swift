//
//  GoalInfo.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 2/26/22.
//

import SwiftUI

struct GoalInfo: View {
    
    @Binding var isShowingGoalInfo: Bool
    
    var body: some View {
        
        VStack {
            Text("How To Change Your Goal")
                .bold()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Select a new goal and save a new current weight. This will change the macro/calorie adjustment algorithms based on your weight change each week.")
                    .multilineTextAlignment(.leading)
                
                Text("Changes will take effect after your next weigh in.")
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 20)
                
                Text("Fat Loss:")
                    .bold()
                    .italic()
                    .font(.caption)
                Text("Expect to lose 1 - 2 lbs per week on average (may be higher if you have a lot of weight to lose).")
                    .bold()
                    .font(.caption)

                Text("Maintenance:")
                    .bold()
                    .italic()
                    .font(.caption)
                Text("Expect to keep weight stable - great for strength focused training without weight gain.")
                    .bold()
                    .font(.caption)

                Text("Muscle Growth:")
                    .bold()
                    .italic()
                    .font(.caption)
                Text("Expect to gain 0.5 - 1.5 lbs per week on average.")
                    .bold()
                    .font(.caption)
            }
            .padding(.vertical)
            
            Button {
                withAnimation(.spring()) {
                    isShowingGoalInfo.toggle()
                }
            } label: {
                Text("Dismiss")
                    .bold()
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderless)
            //.buttonBorderShape(.capsule)
            .tint(.red)
            .controlSize(.regular)
        }
        .padding(.horizontal, 25)
        //.padding(.vertical, 30)
        //.padding(.bottom, 200)
        .frame(maxWidth: .infinity)
        .frame(height: 500)
        .background(.ultraThinMaterial)
        .cornerRadius(30)
    }
}

//struct GoalInfo_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalInfo()
//    }
//}
