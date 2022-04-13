//
//  User.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 2/4/22.
//

import SwiftUI
import OrderedCollections

class User: Codable, ObservableObject {
    
    //MARK: Profile Info - User Enters
    var name: String = ""
    var stringHeight: String = ""
    var stringAge: String = ""
    var email: String = ""
    var sex: String = ""
    var activityLevel: String = ""
    var goal: String = ""
    
    var height: Double {
        if stringHeight == "" {
            return 0.0
        } else {
            return Double(stringHeight) ?? 0.0
        }
    }
    
    var age: Double {
        if stringAge == "" {
            return 0.0
        } else {
            return Double(stringAge) ?? 0.0
        }
    }

    //MARK: Date Variables
    var weighInDate: Date = Date()
    
    var previousFullDate: Date {
        if totalWeighIns > 0 {
            return sortedWeighIns.elements[totalWeighIns - 1].key
        } else {
            return Date()
        }
    }
    
    var previousDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
                
        if totalWeighIns > 0 {
            return formatter.string(from: sortedWeighIns.elements[totalWeighIns - 1].key)
        } else {
            return ""
        }
    }
    
    var firstDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        if totalWeighIns > 0 {
            return formatter.string(from: sortedWeighIns.elements[0].key)
        } else {
            return ""
        }
    }
    
    var datesArray: [String] {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        let sortedKeys = previousWeighIns.keys.sorted().reversed()
        var sortedDates = [String]()
        
        for key in sortedKeys {
            sortedDates.append((formatter.string(from: key)))
        }
        return sortedDates
    }
    
    //MARK: Weight/Height Variables
    var stringWeight: String = ""
    
    var weight: Double {
        if stringWeight == "" {
            return 0.0
        } else {
            return Double(stringWeight) ?? 0.0
        }
    }
    
    var weightKg: Double {
        return weight / 2.205
    }
    
    var heightCm: Double {
        return height * 2.54
    }
    
    var totalWeighIns: Int {
        return previousWeighIns.count
    }
    
    var previousWeight: Double {        
        if totalWeighIns > 0 {
            return sortedWeighIns.elements[totalWeighIns - 1].value[0]
        } else {
            return 0.0
        }
    }
    
    var previousStringWeight: String {
        if previousWeight == 0.0 {
            return ""
        } else {
            return "\(previousWeight)"
        }
    }
    
    var lastPreviousWeight: Double {
        if totalWeighIns >= 2 {
            return sortedWeighIns.elements[totalWeighIns - 2].value[0]
        } else {
            return 0.0
        }
    }
    
    var weightChange: Double {
        if totalWeighIns >= 2 {
            return weight - lastPreviousWeight
        } else {
            return 0.0
        }
    }
    
    var previousWeightChange: Double {
        if totalWeighIns >= 2 {
            return previousWeight - lastPreviousWeight
        } else {
            return 0.0
        }
    }
        
    var weightArray: [Double] { //For displaying weights on the graph
        var weights = [Double]()
        
        if totalWeighIns > 0 {
            for index in 1...totalWeighIns {
                weights.append(sortedWeighIns.elements[index - 1].value[0])
            }
        } else {
            weights.append(0.0)
        }
        return weights
    }
    
    //MARK: Dictionaries
    var previousWeighIns: OrderedDictionary <Date, [Double]> = [:]
    
    var sortedWeighIns: OrderedDictionary <Date, [Double]> = [:]
    
    var reversedWeighIns: OrderedDictionary <Date, [Double]> = [:]
    
    //MARK: Input Macros/WeightChange
    
    var inputFats: String = ""
    var inputCarbs: String = ""
    var inputProtein: String = ""
    var inputCalories: String = ""
    
    var inputWeightChange: Double = 0.0
    var weeklyInputWeightChange: Double {
        if inputWeightChange == 0.0 {
            return 0.0
        } else {
            return inputWeightChange / 4
        }
    }
    
    var inputCalorieMultiplier: Double {
        switch goal {
        case "Fat Loss":
            switch weeklyInputWeightChange {
            case 3.0 ... 1000: // gaining 3+ lbs per week - reduce by 15%, will be reduced further in calorie calc
                return 0.8
            case 1.0 ..< 3.0: // gaining 1-3lbs per week - reduce by 7.5%, will be reduced further in calorie calc
                return 0.9
            case -1.0 ..< 1.0: // losing/gaining 0-1lb per week - effectively maintenance
                return 1.0
            case -3.0 ..< -1.0: // calories are where they should be to start (so we increase them here to account for fat loss multiplier)
                return 1.15
            default: // calories are too low - losing more than 4lbs per week (increase by 10%)
                return 1.3
            }
        //Add Maintenance
        //Add Muscle Growth
        default:
            return 1.0
        }
    }
    
    //MARK: BMR, TDEE, Macros
    var maleBMR: Double {
        return (weightKg * 10) + (6.25 * heightCm) - (5 * age) + 5
    }
    
    var femaleBMR: Double {
        return (weightKg * 10) + (6.25 * heightCm) - (5 * age) - 161
    }
    
    var activityMultiplier: Double {
        if activityLevel == "None" {
            return 1.2
        } else if activityLevel == "Low" {
            return 1.375
        } else if activityLevel == "Moderate" {
            return 1.55
        } else if activityLevel == "High" {
            return 1.725
        } else if activityLevel == "Extreme" {
            return 1.9
        } else {
            return 0.0
        }
    }
    
    var maintenanceCalories: Double { //switch on inputCalories
        switch inputCalories {
        case "": // if no input calories are entered, use regular calculations
            if sex == "Male" {
                return maleBMR * activityMultiplier
            } else {
                return femaleBMR * activityMultiplier
            }
        default: // if input calories are entered calculate off of those
            return inputCalorieMultiplier * (Double(inputCalories) ?? 0)
        }
    }
    
    var calories: Double {
        switch goal {
        case "Fat Loss":
            return maintenanceCalories * 0.875
        case "Maintenance":
            return maintenanceCalories
        default: //Muscle Growth
            return maintenanceCalories * 1.125
        }
    }
    
    //MARK: Fats
    var fats: Double {
        switch inputCalories {
        case "":
            switch weight {
            case 0.0..<200.0:
                return weightKg * 1.1
            case 200.0..<250.0:
                return weightKg * 1.05
            case 250.0..<300.0:
                return weightKg * 0.975
            case 300.0..<350.0:
                return weightKg * 0.925
            default:
                return weightKg * 0.875
            }
        default:
            return calories * 0.25 / 9
        }
        
    }
    
    //MARK: Carbs
    var carbs: Double {
        return (calories - (9 * fats) - (4 * protein)) / 4
    }
    
    //MARK: Protein
    var protein: Double {
        switch activityLevel {
        case "None":
            switch weight {
            case 0.0..<200.0:
                return weight * 0.95
            case 200.0..<250.0:
                return weight * 0.9
            case 250.0..<300.0:
                return weight * 0.8
            case 300.0..<350.0:
                return weight * 0.7
            default:
                return weight * 0.6
            }
        case "Low":
            switch weight {
            case 0.0..<200.0:
                return weight * 0.975
            case 200.0..<250.0:
                return weight * 0.95
            case 250.0..<300.0:
                return weight * 0.825
            case 300.0..<350.0:
                return weight * 0.725
            default:
                return weight * 0.625
            }
        case "Moderate":
            switch weight {
            case 0.0..<200.0:
                return weight * 1
            case 200.0..<250.0:
                return weight * 1
            case 250.0..<300.0:
                return weight * 0.875
            case 300.0..<350.0:
                return weight * 0.75
            default:
                return weight * 0.65
            }
        case "High":
            switch weight {
            case 0.0..<200.0:
                return weight * 1.05
            case 200.0..<250.0:
                return weight * 1.025
            case 250.0..<300.0:
                return weight * 0.9
            case 300.0..<350.0:
                return weight * 0.775
            default:
                return weight * 0.675
            }
        case "Extreme":
            switch weight {
            case 0.0..<200.0:
                return weight * 1.1
            case 200.0..<250.0:
                return weight * 1.05
            case 250.0..<300.0:
                return weight * 0.925
            case 300.0..<350.0:
                return weight * 0.8
            default:
                return weight * 0.7
            }
        default:
            return weight * 1
        }
    }
    
    //MARK: Reset Macros
    //These are used if the normal calculations would result in carb total of less than 30g
    var resetFats: Double {
        switch activityLevel {
        case "High":
            return calories * 0.3 / 9
        case "Extreme":
            return calories * 0.25 / 9
        default:
            return calories * 0.35 / 9
        }
    }
    
    var resetCarbs: Double {
        return (calories - (9 * resetFats) - (4 * resetProtein)) / 4
    }
    
    var resetProtein: Double {
        switch goal {
        case "Fat Loss":
            return calories * 0.5 / 4
        case "Maintenance":
            return calories * 0.45 / 4
        default:
            return calories * 0.4 / 4
        }
    }
        
    
    //MARK: Newly Adjusted Macros
    var newCalories = 0.0
    var newFats = 0.0
    var newCarbs = 0.0
    var newProtein = 0.0
    
    //MARK: Previous Macros
    var previousCalories: Double {
        if totalWeighIns > 0 {
            return sortedWeighIns.elements[totalWeighIns - 1].value[1]
        } else {
            return 0.0
        }
    }
    
    var previousFats: Double {
        if totalWeighIns > 0 {
            return sortedWeighIns.elements[totalWeighIns - 1].value[2]
        } else {
            return 0.0
        }
    }
    
    var previousCarbs: Double {
        if totalWeighIns > 0 {
            return sortedWeighIns.elements[totalWeighIns - 1].value[3]
        } else {
            return 0.0
        }
    }
    
    var previousProtein: Double {
        if totalWeighIns > 0 {
            return sortedWeighIns.elements[totalWeighIns - 1].value[4]
        } else {
            return 0.0
        }
    }
    
    //MARK: Last Previous Macros
    
    var lastPreviousCalories: Double {
        if totalWeighIns >= 2 {
            return sortedWeighIns.elements[totalWeighIns - 2].value[1]
        } else {
            return 0.0
        }
    }
    
    var lastPreviousFats: Double {
        if totalWeighIns >= 2 {
            return sortedWeighIns.elements[totalWeighIns - 2].value[2]
        } else {
            return 0.0
        }
    }
    
    var lastPreviousCarbs: Double {
        if totalWeighIns >= 2 {
            return sortedWeighIns.elements[totalWeighIns - 2].value[3]
        } else {
            return 0.0
        }
    }
    
    var lastPreviousProtein: Double {
        if totalWeighIns >= 2 {
            return sortedWeighIns.elements[totalWeighIns - 2].value[4]
        } else {
            return 0.0
        }
    }
    
    
    //MARK: Functions
    
    func sortWeighIns() -> OrderedDictionary <Date, [Double]> {
        let sortedKeys = previousWeighIns.keys.sorted()
        var sortedWeighIns: OrderedDictionary <Date, [Double]> = [:]
        
        for key in sortedKeys {
            sortedWeighIns[key] = previousWeighIns[key]
        }
        return sortedWeighIns
    }
}
