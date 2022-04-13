//
//  GoalDescriptions.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 2/26/22.
//

import SwiftUI

struct GoalDescriptions: View {
    
    @EnvironmentObject var viewModel: EnvironmentViewModel
    
    var body: some View {
        switch viewModel.user.goal {
        case "Fat Loss":
            Text("Expect to lose 0.4 - 3 lbs per week on average (potentially higher if you have a lot of weight to lose).")
                .bold()
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 3)
                .padding(.horizontal, 25)
                .padding(.bottom, 10)
        case "Maintenance":
            Text("Expect to keep weight stable - great for strength focused training without weight gain.")
                .bold()
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 3)
                .padding(.horizontal, 25)
                .padding(.bottom, 10)
        case "Muscle Growth":
            Text("Expect to gain 0.5 - 2 lbs per week on average." + "\n")
                .bold()
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 3)
                .padding(.horizontal, 25)
                .padding(.bottom, 10)
        default:
            Text("")
        }
    }
}

struct GoalDescriptions_Previews: PreviewProvider {
    static var previews: some View {
        GoalDescriptions()
    }
}
