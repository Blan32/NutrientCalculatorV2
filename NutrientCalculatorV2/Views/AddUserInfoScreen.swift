//
//  AddUserInfoScreen.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 2/7/22.
//

import SwiftUI

struct AddUserInfoScreen: View {
    
    @EnvironmentObject var viewModel: EnvironmentViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @FocusState private var focusedTextField: FormTextField?
    
    @State var showActivityInfo: Bool = false
    @State private var isShowingGoalInfo: Bool = false
    
    enum FormTextField {
        case name
        case height
        case age
        case email
    }
        
    var body: some View {
        ZStack {
            VStack {
                userName
                
                HStack(spacing: 10) {
                    userHeight
                    userAge
                }
                userEmail
                
                userBiologicalSex
                
                userActivityLevel
                
                userGoal
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    keyboardDownButton
                    Spacer()
                    keyboardNextButton
                }
            }
            
            ActivityInfo(showActivityInfo: $showActivityInfo)
                    .offset(y: showActivityInfo ? 0 : UIScreen.main.bounds.height)
            
            .overlay(content: {
                GoalInfo(isShowingGoalInfo: $isShowingGoalInfo)
                        .offset(y: isShowingGoalInfo ? 0 : UIScreen.main.bounds.height)
            })
        }
    }
}


extension AddUserInfoScreen {
    
    //MARK: Keyboard Buttons
    private var keyboardDownButton: some View {
        Button {
            focusedTextField = nil
        } label: {
            Image(systemName: "keyboard.chevron.compact.down")
        }
    }
    
    private var keyboardNextButton: some View {
        Button {
            if focusedTextField == .name {
                focusedTextField = .height
            } else if focusedTextField == .height {
                focusedTextField = .age
            } else if focusedTextField == .age {
                focusedTextField = .email
            } else {
                focusedTextField = nil
            }
        } label: {
            Text(focusedTextField == .email ? "Done" : "Next")
        }
    }
    
    // MARK: Name
    private var userName: some View {
        VStack {
            SectionHeaderText(title: "Name:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 5)
                .padding(.leading, 10)
            TextField("Name", text: $viewModel.user.name)
                .font(.body)
                .padding(6)
                .padding(.leading, 10)
                .background(colorScheme == .light ? Color.black.opacity(0.1) : Color.white.opacity(0.1))
                .cornerRadius(30)
                .padding(.leading, 15)
                .focused($focusedTextField, equals: .name)
                .onSubmit {
                    focusedTextField = .height
                }
                .submitLabel(.next)
        }
        .padding(.trailing)
    }
    
    // MARK: Height
    private var userHeight: some View {
        VStack {
            SectionHeaderText(title: "Height (inches):")
                .frame(maxWidth: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                .padding(.top, 5)
                .padding(.leading, 10)
            TextField("Height (inches)", text: $viewModel.user.stringHeight)
                .font(.body)
                .padding(6)
                .padding(.leading, 10)
                .background(colorScheme == .light ? Color.black.opacity(0.1) : Color.white.opacity(0.1))
                .frame(maxWidth: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                .cornerRadius(30)
                .padding(.leading, 15)
                .keyboardType(.decimalPad)
                .focused($focusedTextField, equals: .height)
        }
    }
    
    // MARK: Age
    private var userAge: some View {
        VStack(alignment: .leading) {
            SectionHeaderText(title: "Age:")
                .frame(maxWidth: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                .padding(.top, 5)
                //.padding(.leading, 5)
            TextField("Age", text: $viewModel.user.stringAge)
                .font(.body)
                .padding(6)
                .padding(.leading, 10)
                .background(colorScheme == .light ? Color.black.opacity(0.1) : Color.white.opacity(0.1))
                .frame(maxWidth: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                .cornerRadius(30)
                .padding(.trailing, 15)
                //.padding(.bottom, 5)
                .keyboardType(.numberPad)
                .focused($focusedTextField, equals: .age)
        }
    }
    
    // MARK: Email
    private var userEmail: some View {
        VStack {
            SectionHeaderText(title: "Email:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 5)
                .padding(.leading, 10)
            TextField("Email", text: $viewModel.user.email)
                .font(.body)
                .padding(6)
                .padding(.leading, 10)
                .background(colorScheme == .light ? Color.black.opacity(0.1) : Color.white.opacity(0.1))
                .cornerRadius(30)
                .padding(.horizontal, 15)
                .padding(.bottom, 12)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .focused($focusedTextField, equals: .email)
                .onSubmit {
                    focusedTextField = nil
                }
                .submitLabel(.continue)
        }
    }
    
    // MARK: Biological Sex
    private var userBiologicalSex: some View {
        VStack {
            HStack {
                SectionHeaderText(title: "Biological Sex: ")
                    .padding(.leading, 10)
                Text(viewModel.user.sex)
                    .font(.body)
                    .bold()
                    .foregroundColor(viewModel.user.sex == "Male" ? .blue : .pink)
                if viewModel.user.sex == "Male" {
                    Text("♂︎")
                        .font(.body)
                        .bold()
                        .foregroundColor(.blue)
                } else if viewModel.user.sex == "Female" {
                    Text("♀︎")
                        .font(.body)
                        .bold()
                        .foregroundColor(.pink)
                } else {
                    Text("Placeholder")
                        .font(.body)
                        .bold()
                        .opacity(0.0)
                }
                Spacer()
            }
            
            Picker(selection: $viewModel.user.sex) {
                ForEach(viewModel.sexes, id: \.self) { sex in
                    Text(sex).tag(sex)
                }
            } label: {
                Text("Biological Sex")
                    
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.bottom, 12)
        }
    }
    
    // MARK: Activity Level
    private var userActivityLevel: some View {
        VStack {
            HStack {
                SectionHeaderText(title: "Activity Level: ")
                    .padding(.leading, 10)
                if viewModel.user.activityLevel == "" {
                    Text("Placeholder")
                        .font(.body)
                        .bold()
                        .opacity(0.0)
                }
                Text(viewModel.user.activityLevel)
                    .font(.body)
                    .bold()
                    .foregroundColor(activityTextColor())
                Spacer()
                Image(systemName: "info.circle")
                    .padding(.trailing, 25)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showActivityInfo.toggle()
                        }
                    }
            }
            
            Picker(selection: $viewModel.user.activityLevel) {
                ForEach(viewModel.activityOptions, id: \.self) { activity in
                    Text(activity).tag(activity)
                }
            } label: {
                Text("Activity Level")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.bottom, 12)
        }
    }
    
    func activityTextColor() -> Color {
        switch viewModel.user.activityLevel {
        case "None":
            return Color.primary
        case "Low":
            return Color.blue
        case "Moderate":
            return Color.green
        case "High":
            return Color.yellow
        case "Extreme":
            return Color.red
        default:
            return Color.primary
        }
    }
    
    // MARK: Goal
    private var userGoal: some View {
        GoalView(isShowingGoalInfo: $isShowingGoalInfo)
    }
}
