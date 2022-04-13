//
//  AdjustedMacroView.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 2/22/22.
//

import SwiftUI

struct AdjustedMacroView: View {
    
    @EnvironmentObject var viewModel: EnvironmentViewModel
    @Binding var isShowingAdjustedMacros: Bool
    
    //MARK: Body
    var body: some View {
               
        VStack {
            
            Spacer()
            
            SectionHeaderText(title: "Weigh-In")
                .padding(.trailing, 15) //has 15 leading padding - this centers it
            
            userWeighInInfo
            
            Spacer()
            
            SectionHeaderText(title: "Calorie/Macro Changes")
                .padding(.trailing, 15) //has 15 leading padding - this centers it
            
            calorieMacroChanges
            
            Spacer()
            
            continueButton
        }
    }
}


//MARK: Functions
extension AdjustedMacroView {
    
    //MARK: WeightStatusTextColor
    func weightStatusTextColor(weightChange: Double) -> Color {
        if weightChange < 0 {
            return .red
        } else if weightChange > 0 {
            return .green
        } else {
            return .accentColor
        }
    }
    
    //MARK: MacroStatusTextColor
    func macroStatusTextColor(weightChange: Double, previousWeight: Double) -> Color {
        switch viewModel.user.goal {
        
        //MARK: FatLoss Colors
        case "Fat Loss":
            switch previousWeight {
            case 0.0..<200.0:
                switch weightChange {
                case (-0.39)...(1000):
                    return .red
                case (-1000)..<(-3.0):
                    return .green
                default: // (-3.0)...(-0.4) = lose 0.4 - 3 pounds in a week
                    return .accentColor
                }
            case 200.0..<250.0:
                switch weightChange {
                case (-0.39)...(1000):
                    return .red
                case (-1000)..<(-3.5):
                    return .green
                default: // (-3.5)...(-0.4) = lose 0.4 - 3.5 pounds in a week
                    return .accentColor
                }
            case 250.0..<300.0:
                switch weightChange {
                case (-0.39)...(1000):
                    return .red
                case (-1000)..<(-4.0):
                    return .green
                default: // (-4.0)...(-0.4) = lose 0.4 - 4 pounds in a week
                    return .accentColor
                }
            case 300.0..<350.0:
                switch weightChange {
                case (-0.39)...(1000):
                    return .red
                case (-1000)..<(-5.0):
                    return .green
                default: // (-5.0)...(-0.4) = lose 0.4 - 5 pounds in a week
                    return .accentColor
                }
            default:
                switch weightChange {
                case (-0.39)...(1000):
                    return .red
                case (-1000)..<(-6.0):
                    return .green
                default: // (-6.0)...(-0.4) = lose 0.4 - 6 pounds in a week
                    return .accentColor
                }
            }
        
        //MARK: Maintenance Colors
        case "Maintenance":
            switch previousWeight {
            case 0.0..<200.0:
                switch weightChange {
                case (1.01)...(1000):
                    return .red
                case (-1000)..<(-1.0):
                    return .green
                default: // (-1.0)...(1.0) = +/- 1 lb in a week
                    return .accentColor
                }
            case 200.0..<250.0:
                switch weightChange {
                case (1.51)...(1000):
                    return .red
                case (-1000)..<(-1.5):
                    return .green
                default: // (-1.5)...(1.5) = +/- 1.5 lbs in a week
                    return .accentColor
                }
            default:
                switch weightChange {
                case (2.01)...(1000):
                    return .red
                case (-1000)..<(-2.0):
                    return .green
                default: // (-2.0)...(2.0) = +/- 2 lbs in a week
                    return .accentColor
                }
            }
        
        //MARK: Muscle Growth Colors
        default: //Muscle Growth
            switch weightChange {
            case (2.01)...(1000):
                return .red
            case (-1000)..<(0.5):
                return .green
            default: // (-1.0)...(1.0) = +/- 1 lb in a week
                return .accentColor
            }
        }
    }
    
    //MARK: ArrowType
    func arrowType(weightChange: Double, previousWeight: Double) -> String {
        switch viewModel.user.goal {
        
        //MARK: FatLoss Arrow
        case "Fat Loss":
            switch previousWeight {
            case 0.0..<200.0:
                switch weightChange {
                case (2.01)...(1000):
                    return "RedDownArrow3"
                case (0.51)..<(2.01):
                    return "RedDownArrow2"
                case (-0.39)..<(0.51):
                    return "RedDownArrow"
                case (-5.0)..<(-3.0):
                    return "GreenUpArrow"
                case (-6.0)..<(-5.0):
                    return "GreenUpArrow2"
                case (-1000)..<(-6.0):
                    return "GreenUpArrow3"
                default: // (3.0)...(-0.4) = lose 0.4 - 3 pounds in a week
                    return ""
                }
            case 200.0..<250.0:
                switch weightChange {
                case (2.01)...(1000):
                    return "RedDownArrow3"
                case (0.51)..<(2.01):
                    return "RedDownArrow2"
                case (-0.39)..<(0.51):
                    return "RedDownArrow"
                case (-5.5)..<(-3.5):
                    return "GreenUpArrow"
                case (-6.5)..<(-5.5):
                    return "GreenUpArrow2"
                case (-1000)..<(-6.5):
                    return "GreenUpArrow3"
                default: // (-3.5)...(-0.4) = lose 0.4 - 3.5 pounds in a week
                    return ""
                }
            case 250.0..<300.0:
                switch weightChange {
                case (2.01)...(1000):
                    return "RedDownArrow3"
                case (0.51)..<(2.01):
                    return "RedDownArrow2"
                case (-0.39)..<(0.51):
                    return "RedDownArrow"
                case (-6.0)..<(-4.0):
                    return "GreenUpArrow"
                case (-7.0)..<(-6.0):
                    return "GreenUpArrow2"
                case (-1000)..<(-7.0):
                    return "GreenUpArrow3"
                default: // (-4.0)...(-0.4) = lose 0.4 - 4 pounds in a week
                    return ""
                }
            case 300.0..<350.0:
                switch weightChange {
                case (2.01)...(1000):
                    return "RedDownArrow3"
                case (0.51)..<(2.01):
                    return "RedDownArrow2"
                case (-0.39)..<(0.51):
                    return "RedDownArrow"
                case (-7.0)..<(-5.0):
                    return "GreenUpArrow"
                case (-8.0)..<(-7.0):
                    return "GreenUpArrow2"
                case (-1000)..<(-8.0):
                    return "GreenUpArrow3"
                default: // (-5.0)...(-0.4) = lose 0.4 - 5 pounds in a week
                    return ""
                }
            default: //350lbs or more
                switch weightChange {
                case (2.01)...(1000):
                    return "RedDownArrow3"
                case (0.51)..<(2.01):
                    return "RedDownArrow2"
                case (-0.39)..<(0.51):
                    return "RedDownArrow"
                case (-7.5)..<(-6.0):
                    return "GreenUpArrow"
                case (-8.5)..<(-7.5):
                    return "GreenUpArrow2"
                case (-1000)..<(-8.5):
                    return "GreenUpArrow3"
                default: // (-6.0)...(-0.4) = lose 0.4 - 6 pounds in a week
                    return ""
                }
            }
        
        //MARK: Maintenance Arrow
        case "Maintenance":
            switch previousWeight {
            case 0.0..<200.0:
                switch weightChange {
                case (3.01)...(1000):
                    return "RedDownArrow3"
                case (2.01)..<(3.01):
                    return "RedDownArrow2"
                case (1.01)..<(2.01):
                    return "RedDownArrow"
                case (-2.0)..<(-1.0):
                    return "GreenUpArrow"
                case (-3.0)..<(-2.0):
                    return "GreenUpArrow2"
                case (-1000)..<(-3.0):
                    return "GreenUpArrow3"
                default: // (-1.0)...(1.0) = +/- 1 lb in a week
                    return ""
                }
            case 200.0..<250.0:
                switch weightChange {
                case (3.51)...(1000):
                    return "RedDownArrow3"
                case (2.51)..<(3.51):
                    return "RedDownArrow2"
                case (1.51)..<(2.51):
                    return "RedDownArrow"
                case (-2.5)..<(-1.5):
                    return "GreenUpArrow"
                case (-3.5)..<(-2.5):
                    return "GreenUpArrow2"
                case (-1000)..<(-3.5):
                    return "GreenUpArrow3"
                default: // (-1.5)...(1.5) = +/- 1.5 lbs in a week
                    return ""
                }
            default: // 250+
                switch weightChange {
                case (4.01)...(1000):
                    return "RedDownArrow3"
                case (3.01)..<(4.01):
                    return "RedDownArrow2"
                case (2.01)..<(3.01):
                    return "RedDownArrow"
                case (-3.0)..<(-2.0):
                    return "GreenUpArrow"
                case (-4.0)..<(-3.0):
                    return "GreenUpArrow2"
                case (-1000)..<(-4.0):
                    return "GreenUpArrow3"
                default: // (-2.0)...(2.0) = +/- 2 lb in a week
                    return ""
                }
            }
            
        //MARK: Muscle Growth Arrow
        default:
            switch previousWeight {
            case 0.0..<200.0:
                switch weightChange {
                case (4.0)...(1000):
                    return "RedDownArrow3"
                case (3.0)..<(4.0):
                    return "RedDownArrow2"
                case (2.01)..<(3.0):
                    return "RedDownArrow"
                case (-0.1)..<(0.5):
                    return "GreenUpArrow"
                case (-1.5)..<(-0.1):
                    return "GreenUpArrow2"
                case (-1000)..<(-1.5):
                    return "GreenUpArrow3"
                default: // (0.5)...(2.0) = gain 0.5 - 2 lbs in a week
                    return ""
                }
            default:
                switch weightChange {
                case (4.5)...(1000):
                    return "RedDownArrow3"
                case (3.5)..<(4.5):
                    return "RedDownArrow2"
                case (2.01)..<(3.5):
                    return "RedDownArrow"
                case (-0.1)..<(0.5):
                    return "GreenUpArrow"
                case (-1.5)..<(-0.1):
                    return "GreenUpArrow2"
                case (-1000)..<(-1.5):
                    return "GreenUpArrow3"
                default: // (0.5)...(2.0) = gain 0.5 - 2 lbs in a week
                    return ""
                }
            }
        }
    }
    
    //MARK: AdjustmentStrings
    func adjustmentString(weightChange: Double, previousWeight: Double) -> String {
        switch viewModel.user.goal {
        
        //MARK: FatLoss String
        case "Fat Loss":
            switch previousWeight {
            case 0.0..<200.0:
                switch weightChange {
                case (2.01)...(1000):
                    return "Your calories are too high, we've made significant drops for next week."
                case (0.51)..<(2.01):
                    return "Looks like we've overshot your calorie needs, we are making some tweaks for next week."
                case (-0.39)..<(0.51):
                    return "We didn't see as much movement on the scale as expected this week, we will make a small drop to accelerate your progress."
                case (-5.0)..<(-3.0):
                    return "We may have been a bit low on calories, we're adding a few more in this week."
                case (-6.0)..<(-5.0):
                    return "That's a lot of weight loss! We are going to up your calories this week to make sure we aren't losing weight too quickly."
                case (-1000)..<(-6.0):
                    return "Your body needs way more calories! We are going to make sure you are eating a lot more this week (and continue losing body fat)."
                default: // (-3.0)...(-0.4) = lose 0.4 - 3 pounds in a week
                    return "Your calories and macros are right where they need to be, we don't need to change a thing."
                }
            case 200.0..<250.0:
                switch weightChange {
                case (2.01)...(1000):
                    return "Your calories are too high, we've made significant drops for next week."
                case (0.51)..<(2.01):
                    return "Looks like we've overshot your calorie needs, we are making some tweaks for next week."
                case (-0.39)..<(0.51):
                    return "We didn't see as much movement on the scale as expected this week, we will make a small drop to accelerate your progress."
                case (-5.5)..<(-3.5):
                    return "We may have been a bit low on calories, we're adding a few more in this week."
                case (-6.5)..<(-5.5):
                    return "That's a lot of weight loss! We are going to up your calories this week to make sure we aren't losing weight too quickly."
                case (-1000)..<(-6.5):
                    return "Your body needs way more calories! We are going to make sure you are eating a lot more this week (and continue losing body fat)."
                default: // (-3.5)...(-0.4) = lose 0.4 - 3.5 pounds in a week
                    return "Your calories and macros are right where they need to be, we don't need to change a thing."
                }
            case 250.0..<300.0:
                switch weightChange {
                case (2.01)...(1000):
                    return "Your calories are too high, we've made significant drops for next week."
                case (0.51)..<(2.01):
                    return "Looks like we've overshot your calorie needs, we are making some tweaks for next week."
                case (-0.39)..<(0.51):
                    return "We didn't see as much movement on the scale as expected this week, we will make a small drop to accelerate your progress."
                case (-6.0)..<(-4.0):
                    return "We may have been a bit low on calories, we're adding a few more in this week."
                case (-7.0)..<(-6.0):
                    return "That's a lot of weight loss! We are going to up your calories this week to make sure we aren't losing weight too quickly."
                case (-1000)..<(-7.0):
                    return "Your body needs way more calories! We are going to make sure you are eating a lot more this week (and continue losing body fat)."
                default: // (-4.0)...(-0.4) = lose 0.4 - 4 pounds in a week
                    return "Your calories and macros are right where they need to be, we don't need to change a thing."
                }
            case 300.0..<350.0:
                switch weightChange {
                case (2.01)...(1000):
                    return "Your calories are too high, we've made significant drops for next week."
                case (0.51)..<(2.01):
                    return "Looks like we've overshot your calorie needs, we are making some tweaks for next week."
                case (-0.39)..<(0.51):
                    return "We didn't see as much movement on the scale as expected this week, we will make a small drop to accelerate your progress."
                case (-7.0)..<(-5.0):
                    return "We may have been a bit low on calories, we're adding a few more in this week."
                case (-8.0)..<(-7.0):
                    return "That's a lot of weight loss! We are going to up your calories this week to make sure we aren't losing weight too quickly."
                case (-1000)..<(-8.0):
                    return "Your body needs way more calories! We are going to make sure you are eating a lot more this week (and continue losing body fat)."
                default: // (-5.0)...(-0.4) = lose 0.4 - 5 pounds in a week
                    return "Your calories and macros are right where they need to be, we don't need to change a thing."
                }
            default:
                switch weightChange {
                case (2.01)...(1000):
                    return "Your calories are too high, we've made significant drops for next week."
                case (0.51)..<(2.01):
                    return "Looks like we've overshot your calorie needs, we are making some tweaks for next week."
                case (-0.39)..<(0.51):
                    return "We didn't see as much movement on the scale as expected this week, we will make a small drop to accelerate your progress."
                case (-7.5)..<(-6.0):
                    return "We may have been a bit low on calories, we're adding a few more in this week."
                case (-8.5)..<(-7.5):
                    return "That's a lot of weight loss! We are going to up your calories this week to make sure we aren't losing weight too quickly."
                case (-1000)..<(-8.5):
                    return "Your body needs way more calories! We are going to make sure you are eating a lot more this week (and continue losing body fat)."
                default: // (-6.0)...(-0.4) = lose 0.4 - 6 pounds in a week
                    return "Your calories and macros are right where they need to be, we don't need to change a thing."
                }
            }
        //MARK: Maintenance String
        case "Maintenance":
            switch previousWeight {
            case 0.0..<200.0:
                switch weightChange {
                case (3.01)...(1000):
                    return "Your calories are too high, we've made significant drops for next week."
                case (2.01)..<(3.01):
                    return "Looks like we've overshot your calorie needs, we are making some tweaks for next week."
                case (1.01)..<(2.01):
                    return "We are slightly higher than we want to be, we will make a small drop for next week."
                case (-2.0)..<(-1.0):
                    return "We may have been a bit low on calories, we're adding a few more in this week."
                case (-3.0)..<(-2.0):
                    return "Your weight is lower than we expected, let's bump up your calories this week."
                case (-1000)..<(-3.0):
                    return "Your body needs way more calories! We are going to make sure you are eating a lot more this week."
                default: // (-1.0)...(1.0) = +/- 1 lb in a week
                    return "Your calories and macros are right where they need to be, we don't need to change a thing."
                }
            case 200.0..<250.0:
                switch weightChange {
                case (3.51)...(1000):
                    return "Your calories are too high, we've made significant drops for next week."
                case (2.51)..<(3.51):
                    return "Looks like we've overshot your calorie needs, we are making some tweaks for next week."
                case (1.51)..<(2.51):
                    return "We are slightly higher than we want to be, we will make a small drop for next week."
                case (-2.5)..<(-1.5):
                    return "We may have been a bit low on calories, we're adding a few more in this week."
                case (-3.5)..<(-2.5):
                    return "Your weight is lower than we expected, let's bump up your calories this week."
                case (-1000)..<(-3.5):
                    return "Your body needs way more calories! We are going to make sure you are eating a lot more this week."
                default: // (-1.5)...(1.5) = +/- 1.5 lbs in a week
                    return "Your calories and macros are right where they need to be, we don't need to change a thing."
                }
            default:
                switch weightChange {
                case (4.01)...(1000):
                    return "Your calories are too high, we've made significant drops for next week."
                case (3.01)..<(4.01):
                    return "Looks like we've overshot your calorie needs, we are making some tweaks for next week."
                case (2.01)..<(3.01):
                    return "We are slightly higher than we want to be, we will make a small drop for next week."
                case (-3.0)..<(-2.0):
                    return "We may have been a bit low on calories, we're adding a few more in this week."
                case (-4.0)..<(-3.0):
                    return "Your weight is lower than we expected, let's bump up your calories this week."
                case (-1000)..<(-4.0):
                    return "Your body needs way more calories! We are going to make sure you are eating a lot more this week."
                default: // (-2.0)...(2.0) = +/- 2 lbs in a week
                    return "Your calories and macros are right where they need to be, we don't need to change a thing."
                }
            }
        //MARK: Muscle Growth String
        default: //Muscle Growth
            switch previousWeight {
            case 0.0..<200.0:
                switch weightChange {
                case (4.0)...(1000):
                    return "Your calories are too high, we've made significant drops for next week."
                case (3.0)..<(4.0):
                    return "Looks like we've overshot your calorie needs, we are making some tweaks for next week."
                case (2.01)..<(3.0):
                    return "We are slightly higher than we want to be, we will make a small drop for next week."
                case (-0.1)..<(0.5):
                    return "We may have been a bit low on calories, we're adding a few more in this week."
                case (-1.5)..<(-0.1):
                    return "Your weight is lower than we expected, let's bump up your calories this week."
                case (-1000)..<(-1.5):
                    return "Your body needs way more calories! We are going to make sure you are eating a lot more this week."
                default: // (0.5)...(2.0) = gain 0.5 - 2 lbs in a week
                    return "Your calories and macros are right where they need to be, we don't need to change a thing."
                }
            default: // 200.0+
                switch weightChange {
                case (4.5)...(1000):
                    return "Your calories are too high, we've made significant drops for next week."
                case (3.5)..<(4.5):
                    return "Looks like we've overshot your calorie needs, we are making some tweaks for next week."
                case (2.01)..<(3.5):
                    return "We are slightly higher than we want to be, we will make a small drop for next week."
                case (-0.1)..<(0.5):
                    return "We may have been a bit low on calories, we're adding a few more in this week."
                case (-1.5)..<(-0.1):
                    return "Your weight is lower than we expected, let's bump up your calories this week."
                case (-1000)..<(-1.5):
                    return "Your body needs way more calories! We are going to make sure you are eating a lot more this week."
                default: // (0.5)...(2.0) = gain 0.5 - 2 lbs in a week
                    return "Your calories and macros are right where they need to be, we don't need to change a thing."
                }
            }
        }
    }
    
    //MARK: New Macro Variables
    
    private var newCalories: some View {
        HStack {
            Text("Calories: ")
                .bold()
                .frame(width: 80, alignment: .leading)
            Text("\(viewModel.user.previousCalories, specifier: "%.f")")
                .foregroundColor(macroStatusTextColor(weightChange: viewModel.user.previousWeightChange, previousWeight: viewModel.user.previousWeight))
            
            //if viewModel.user.goal == "Fat Loss" {
                Arrows(imageName: arrowType(weightChange: viewModel.user.previousWeightChange, previousWeight: viewModel.user.previousWeight))
            //} //ADD IN MAINTENANCE AND MUSCLE GROWTH ARROW TYPES
            
            Text("(\(viewModel.user.previousCalories - viewModel.user.lastPreviousCalories, specifier: "%.f"))")
                .foregroundColor(macroStatusTextColor(weightChange: viewModel.user.previousWeightChange, previousWeight: viewModel.user.previousWeight))
        }
    }
    
    private var newFats: some View {
        HStack {
            Text("Fats: ")
                .bold()
                .frame(width: 80, alignment: .leading)
            Text("\(viewModel.user.previousFats, specifier: "%.f") g")
                .foregroundColor(macroStatusTextColor(weightChange: viewModel.user.previousWeightChange, previousWeight: viewModel.user.previousWeight))
            
            //if viewModel.user.goal == "Fat Loss" {
                Arrows(imageName: arrowType(weightChange: viewModel.user.previousWeightChange, previousWeight: viewModel.user.previousWeight))
            //} //ADD IN MAINTENANCE AND MUSCLE GROWTH ARROW TYPES
            
            Text("(\(viewModel.user.previousFats - viewModel.user.lastPreviousFats, specifier: "%.f")g)")
                .foregroundColor(macroStatusTextColor(weightChange: viewModel.user.previousWeightChange, previousWeight: viewModel.user.previousWeight))
        }
    }
    
    private var newCarbs: some View {
        HStack {
            Text("Carbs: ")
                .bold()
                .frame(width: 80, alignment: .leading)
            Text("\(viewModel.user.previousCarbs, specifier: "%.f") g")
                .foregroundColor(macroStatusTextColor(weightChange: viewModel.user.previousWeightChange, previousWeight: viewModel.user.previousWeight))
            
            //if viewModel.user.goal == "Fat Loss" {
                Arrows(imageName: arrowType(weightChange: viewModel.user.previousWeightChange, previousWeight: viewModel.user.previousWeight))
            //} //ADD IN MAINTENANCE AND MUSCLE GROWTH ARROW TYPES
            
            Text("(\(viewModel.user.previousCarbs - viewModel.user.lastPreviousCarbs, specifier: "%.f")g)")
                .foregroundColor(macroStatusTextColor(weightChange: viewModel.user.previousWeightChange, previousWeight: viewModel.user.previousWeight))
        }
    }
    
    private var newProtein: some View {
        HStack {
            Text("Protein: ")
                .bold()
                .frame(width: 80, alignment: .leading)
            Text("\(viewModel.user.previousProtein, specifier: "%.f") g")
            
//            if viewModel.user.goal == "Fat Loss" {
//                Arrows(imageName: arrowType(weightChange: weightChange))
//            } //ADD IN MAINTENANCE AND MUSCLE GROWTH ARROW TYPES
            
            Text("(\(viewModel.user.previousProtein - viewModel.user.lastPreviousProtein, specifier: "%.f")g)")
                //.foregroundColor(macroStatusTextColor(weightChange: viewModel.user.weightChange))
        }
    }
    
    //MARK: Views - - - - - - - - - - - -
    
    //MARK: User Weigh-In Info
    
    private var userWeighInInfo: some View {
        VStack{
            Text("Previous Weight: \(viewModel.user.lastPreviousWeight, specifier: "%.1f") lbs")
                .bold()
                .padding()
                .padding(.horizontal)
                .frame(width: UIScreen.main.bounds.width * 0.72, height: 40, alignment: .leading)
                .background(
                    Capsule()
                        .stroke(Color.calorieColor, lineWidth: 3)
                )
            Text("Current Weight: \(viewModel.user.previousWeight, specifier: "%.1f") lbs")
                .bold()
                .padding()
                .padding(.horizontal)
                .frame(width: UIScreen.main.bounds.width * 0.72, height: 40, alignment: .leading)
                .background(
                    Capsule()
                        .stroke(Color.calorieColor, lineWidth: 3)
                )
            Text("Weight Change: \(viewModel.user.previousWeightChange, specifier: "%.1f") lbs")
                .bold()
                .padding()
                .padding(.horizontal)
                .foregroundColor(weightStatusTextColor(weightChange: viewModel.user.previousWeightChange))
                .frame(width: UIScreen.main.bounds.width * 0.72, height: 40, alignment: .leading)
                .background(
                    Capsule()
                        .stroke(Color.calorieColor, lineWidth: 3)
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.calorieColor, lineWidth: 3)
                .frame(width: UIScreen.main.bounds.width * 0.98)
        )
    }
    
    //MARK: Calorie/Macro Changes
    private var calorieMacroChanges: some View {
        VStack {
            VStack {
                Text(adjustmentString(weightChange: viewModel.user.previousWeightChange, previousWeight: viewModel.user.previousWeight))
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.calorieColor)
                )
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            
            VStack(alignment: .leading) {
                newCalories
                    .padding()
                    .padding(.horizontal)
                    .frame(width: UIScreen.main.bounds.width * 0.72, height: 40, alignment: .leading)
                    .background(
                        Capsule()
                            .stroke(Color.calorieColor, lineWidth: 3)
                    )
                newFats
                    .padding()
                    .padding(.horizontal)
                    .frame(width: UIScreen.main.bounds.width * 0.72, height: 40, alignment: .leading)
                    .background(
                        Capsule()
                            .stroke(Color.fatColor, lineWidth: 3)
                    )
                newCarbs
                    .padding()
                    .padding(.horizontal)
                    .frame(width: UIScreen.main.bounds.width * 0.72, height: 40, alignment: .leading)
                    .background(
                        Capsule()
                            .stroke(Color.carbColor, lineWidth: 3)
                    )
                newProtein
                    .padding()
                    .padding(.horizontal)
                    .frame(width: UIScreen.main.bounds.width * 0.72, height: 40, alignment: .leading)
                    .background(
                        Capsule()
                            .stroke(Color.proteinColor, lineWidth: 3)
                    )
            }
        }
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.calorieColor, lineWidth: 3)
                .frame(width: UIScreen.main.bounds.width * 0.98)
        )
    }
    
    
    //MARK: Continue Button
    private var continueButton: some View {
        Button {
            isShowingAdjustedMacros.toggle()
            viewModel.user.stringWeight = ""
        } label: {
            Text("Continue")
                .bold()
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .tint(.buttonColor)
        .controlSize(.large)
    }
}





