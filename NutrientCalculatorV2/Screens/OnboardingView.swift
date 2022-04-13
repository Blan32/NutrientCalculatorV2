//
//  OnBoardingView.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 2/4/22.
//

import SwiftUI

//MARK: VIEW

struct OnboardingView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: EnvironmentViewModel
    
    @Binding var newUser: Bool
    @Binding var showInstructions: Bool
        
    var body: some View {

        NavigationView {
            VStack {
                welcomeScreen
                
                Spacer()
                
                bottomButton
            }
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
    }
}

extension OnboardingView {
    
    //MARK: Welcome Screen
    private var welcomeScreen: some View {
        VStack {
                        
            Image("HypertroFit")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .padding(.top, 20)
                .background(
                    colorScheme == .light ?
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 260, height: 260) : nil)
                .padding(.bottom, 80)

            Text("Nutrient Calculator")
                .font(.title)
                .bold()
                        
            Text("Are you ready to get in the best shape of your life? With a few pieces of information we will be able to develop a customized nutrition plan for you that updates each week based on your progress.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
        }
    }
    
    // MARK: Bottom Button
    private var bottomButton: some View {
        NavigationLink {
            CreateNewProfile(newUser: $newUser, showInstructions: $showInstructions)
        } label: {
            Text("Get Started")
                .font(.title3)
                .bold()
                .frame(height: 30)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .tint(.buttonColor)
        .padding()
        .padding(.bottom, 30)
    }
}

