//
//  ProfileView.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 2/4/22.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var viewModel: EnvironmentViewModel
    
    //Text that pops up confirming profile info is saved
    @State private var isProfileSavedVisible: Bool = false
        
    var body: some View {
        NavigationView {
            ScrollView {
                
                AddUserInfoScreen()

                if isProfileSavedVisible == true {
                    Text("Profile Saved")
                        .font(.caption)
                        .foregroundColor(.green)
                        .bold()
                        .frame(height: 12)
                        .padding(.top, 3)
                }
                
                saveProfileButton
            }
            .navigationTitle(Text("Profile"))
            .onAppear(perform: viewModel.retrieveUser)
            .onAppear(perform: resetIsCompletedVisible)
        }
    }
}

extension ProfileView {
    private var saveProfileButton: some View {
        Button {
            viewModel.saveProfile()
            withAnimation(.spring()) {
                isProfileSavedVisible = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.spring()) {
                    isProfileSavedVisible = false
                }
            }
        } label: {
            Text("Save Profile")
                .font(.headline)
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
    
    func resetIsCompletedVisible() {
        isProfileSavedVisible = false
    }
}
