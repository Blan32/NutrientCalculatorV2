//
//  DashboardTabView.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 2/4/22.
//

import SwiftUI

struct DashboardTabView: View {
    
    @StateObject var viewModel: EnvironmentViewModel = EnvironmentViewModel()
    @AppStorage("new_user") var newUser: Bool = true
    @State private var showInstructions: Bool = false
    
    var body: some View {
        ZStack {
            TabView {
                DashboardView(showInstructions: $showInstructions)
                    .tabItem {
                        Label("", systemImage: "house")
                    }
                WeightHistoryView()
                    .tabItem {
                        Label("", systemImage: "square.and.pencil")
                    }
                ProfileView()
                    .tabItem {
                        Label("", systemImage: "person")
                    }
            }
            .fullScreenCover(isPresented: $newUser) {
                OnboardingView(newUser: $newUser, showInstructions: $showInstructions)
            }
            Instructions(showInstructions: $showInstructions)
                .offset(y: showInstructions ? -135 : -UIScreen.main.bounds.height)
        }
        .environmentObject(viewModel)
    }
}

struct DashboardTabView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardTabView()
    }
}


