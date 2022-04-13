//
//  CreateNewProfile.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 3/7/22.
//

import SwiftUI

struct CreateNewProfile: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: EnvironmentViewModel
    @State var showCurrentEatingHabits: Bool = false
    
    @Binding var newUser: Bool
    @Binding var showInstructions: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                AddUserInfoScreen()
                
                Spacer()

                //NavigationLink {
                    //guard viewModel.isValidForm else { return }
                    //CurrentEatingHabits(newUser: $newUser, showInstructions: $showInstructions)
                Button {
                    guard viewModel.isValidForm else { return }
                    withAnimation(.spring()) {
                        showCurrentEatingHabits.toggle()
                    }
                } label: {
                    Text("Continue")
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
            .fullScreenCover(isPresented: $showCurrentEatingHabits) {
                CurrentEatingHabits(newUser: $newUser, showInstructions: $showInstructions, showCurrentEatingHabits: $showCurrentEatingHabits)
            }

        }
        .navigationTitle("Create New Profile")
    }
}

//struct CreateNewProfile_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateNewProfile()
//    }
//}
