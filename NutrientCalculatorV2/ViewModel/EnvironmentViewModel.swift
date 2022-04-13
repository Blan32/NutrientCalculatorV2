//
//  MetricsViewModel.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 2/4/22.
//

import SwiftUI
import OrderedCollections

class EnvironmentViewModel: ObservableObject {
    
    @AppStorage("user") private var userData: Data?
    @AppStorage("new_user") var newUser: Bool = true

    @Published var user = User()
    @Published var alertItem: AlertItem?
    
    //MARK: Profile Categories
    
    let sexes: [String] = [
        "Female", "Male"
    ]
    
    let activityOptions: [String] = [
        "None", "Low", "Moderate", "High", "Extreme"
    ]
    
    let goalOptions: [String] = [
        "Fat Loss", "Maintenance", "Muscle Growth"
    ]
    
    //MARK: Save Profile
    func saveProfile() {
        guard isValidForm else {
            return
        }
        
        do {
            let data = try JSONEncoder().encode(user)
            userData = data
            signIn()
        } catch {
            alertItem = AlertContext.invalidUserData
        }
    }
    
    //MARK: Save Weight
    func saveWeight() {
        guard isValidWeight else {
            return
        }
        
        do {
            addToDictionary()

            let data = try JSONEncoder().encode(user)
            userData = data
            signIn()
        } catch {
            alertItem = AlertContext.invalidUserData
        }
    }
    
    //MARK: Delete Weight
    func deleteWeight(index: Int) {
        do {
            user.reversedWeighIns.remove(at: index)
            
            //find the reversed index of reversedWeighIns to remove from sortedWeighIns and find that specific key to remove from previousWeighIns
            user.previousWeighIns.removeValue(forKey: user.sortedWeighIns.elements[abs(index - (user.totalWeighIns - 1))].key)
            user.sortedWeighIns = user.sortWeighIns()

            let data = try JSONEncoder().encode(user)
            userData = data
        } catch {
            alertItem = AlertContext.invalidUserData
        }
    }
    
    //MARK: Add To Dictionary
    func addToDictionary() {
        
        let previousDate = user.previousFullDate
        let previousWeight = user.previousWeight
        let previousCalories = user.previousCalories
        let previousFats = user.previousFats
        let previousCarbs = user.previousCarbs
        let previousProtein = user.previousProtein
        
        // if carbs would be under 30g or protein is over 50% of calories, use the percentage based calculations to adjust macros
        if user.carbs < 30 || user.protein * 4 > user.calories * 0.5 {
            user.previousWeighIns[user.weighInDate] = [user.weight, user.calories, user.resetFats, user.resetCarbs, user.resetProtein]
            user.sortedWeighIns = user.sortWeighIns()
        } else {
            user.previousWeighIns[user.weighInDate] = [user.weight, user.calories, user.fats, user.carbs, user.protein]
            user.sortedWeighIns = user.sortWeighIns()
        }

        // Checking for more than 1 weigh in, a new most recent weight, and previous calories aren't 0.0
        if user.totalWeighIns >= 2 && previousDate < user.weighInDate && user.lastPreviousCalories != 0.0 {
            switch user.goal {
            case "Fat Loss":
                let adjustedMacros: [Double] = adjustMacrosFatLoss(previousWeight: previousWeight,
                                                       weight: user.weight,
                                                       calories: previousCalories,
                                                       fats: previousFats,
                                                       carbs: previousCarbs,
                                                       protein: previousProtein,
                                                       weightChange: user.weightChange)
                
                user.newCalories = adjustedMacros[0]
                user.newFats = adjustedMacros[1]
                user.newCarbs = adjustedMacros[2]
                user.newProtein = adjustedMacros[3]
                
                user.previousWeighIns[user.weighInDate] = [user.weight, user.newCalories, user.newFats, user.newCarbs, user.newProtein]
                user.sortedWeighIns = user.sortWeighIns()
           
            case "Maintenance":
                let adjustedMacros: [Double] = adjustMacrosMaintenance(previousWeight: previousWeight,
                                                       weight: user.weight,
                                                       calories: previousCalories,
                                                       fats: previousFats,
                                                       carbs: previousCarbs,
                                                       protein: previousProtein,
                                                       weightChange: user.weightChange)
                
                user.newCalories = adjustedMacros[0]
                user.newFats = adjustedMacros[1]
                user.newCarbs = adjustedMacros[2]
                user.newProtein = adjustedMacros[3]
                
                user.previousWeighIns[user.weighInDate] = [user.weight, user.newCalories, user.newFats, user.newCarbs, user.newProtein]
                user.sortedWeighIns = user.sortWeighIns()
            
            default: //Muscle Growth
                let adjustedMacros: [Double] = adjustMacrosMuscleGrowth(previousWeight: previousWeight,
                                                       weight: user.weight,
                                                       calories: previousCalories,
                                                       fats: previousFats,
                                                       carbs: previousCarbs,
                                                       protein: previousProtein,
                                                       weightChange: user.weightChange)
                
                user.newCalories = adjustedMacros[0]
                user.newFats = adjustedMacros[1]
                user.newCarbs = adjustedMacros[2]
                user.newProtein = adjustedMacros[3]
                
                user.previousWeighIns[user.weighInDate] = [user.weight, user.newCalories, user.newFats, user.newCarbs, user.newProtein]
                user.sortedWeighIns = user.sortWeighIns()
            }
            
        } else if user.totalWeighIns >= 2 && previousDate > user.weighInDate {
            user.previousWeighIns[user.weighInDate] = [user.weight, 0.0, 0.0, 0.0, 0.0]
            user.sortedWeighIns = user.sortWeighIns()
        }
        
        let sortedKeys = user.sortedWeighIns.keys.reversed()
        var reversedWeighIns: OrderedDictionary <Date, [Double]> = [:]
        
        for key in sortedKeys {
            reversedWeighIns[key] = user.sortedWeighIns[key]
        }
        user.reversedWeighIns = reversedWeighIns
        user.stringWeight = ""
    }
    
    
    //MARK: Retrieve User/Sign In
    func retrieveUser() {
        guard let userData = userData else {
            return
        }
        
        do {
            user = try JSONDecoder().decode(User.self, from: userData)
        } catch {
            alertItem = AlertContext.invalidUserData
        }
    }
    
    func signIn() {
        newUser = false
    }
    
    //MARK: Validate Forms
    
    var isValidWeight: Bool {
        if user.stringWeight == "" || user.weight <= 0.0 || user.weight > 1000.0 {
            alertItem = AlertContext.invalidWeight
            return false
        }
        return true
    }
    
    var isValidForm: Bool {
        guard !user.name.isEmpty && !user.stringAge.isEmpty && !user.sex.isEmpty && !user.activityLevel.isEmpty && !user.goal.isEmpty else {
            alertItem = AlertContext.invalidSignUp
            return false
        }
        
        guard user.email.isValidEmail else {
            alertItem = AlertContext.invalidEmail
            return false
        }
        return true
    }
    
    var isValidMacros: Bool {
        guard user.inputCalories != "" else {
            alertItem = AlertContext.invalidMacros
            return false
        }
        return true
    }
    
    //MARK: AdjustMacros (Fat Loss)
    
    func adjustMacrosFatLoss(previousWeight: Double,
                      weight: Double,
                      calories: Double,
                      fats: Double,
                      carbs: Double,
                      protein: Double,
                      weightChange: Double) -> [Double] {
        
        //let weightChange = weight - previousWeight
        var newMacros: [Double]
        
        switch user.previousWeight {
        //MARK: <200: lose 3.0
        case 0.0..<200.0:
            switch weightChange {
            case (2.01)...(1000):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.9)
                print("Macro/Calorie Needs: Significantly Less")
            case (0.51)..<(2.01):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.93)
                print("Macro/Calorie Needs: Much Less")
            case (-0.39)..<(0.51):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.96)
                print("Macro/Calorie Needs: A Bit Less")
            case (-5.0)..<(-3.0):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.04)
                print("Macro/Calorie Needs: A Bit More")
            case (-6.0)..<(-5.0):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.07)
                print("Macro/Calorie Needs: Much More")
            case (-1000)..<(-6.0):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.1)
                print("Macro/Calorie Needs: Significantly More")
            default: // (-3.0)...(-0.4) = lose 0.4 - 3 pounds in a week
                newMacros = [calories, fats, carbs, protein]
                print("Macro/Calorie Needs: Exactly The Same")
            }
            print("Weight change: \(weightChange)")
            print(newMacros)
            return newMacros
        
        //MARK: 200 < 250: lose 3.5
        case 200.0..<250:
            switch weightChange {
            case (2.01)...(1000):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.9)
                print("Macro/Calorie Needs: Significantly Less")
            case (0.51)..<(2.01):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.93)
                print("Macro/Calorie Needs: Much Less")
            case (-0.39)..<(0.51):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.96)
                print("Macro/Calorie Needs: A Bit Less")
            case (-5.5)..<(-3.5):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.04)
                print("Macro/Calorie Needs: A Bit More")
            case (-6.5)..<(-5.5):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.07)
                print("Macro/Calorie Needs: Much More")
            case (-1000)..<(-6.5):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.1)
                print("Macro/Calorie Needs: Significantly More")
            default: // (-3.5)...(-0.4) = lose 0.4 - 3.5 pounds in a week
                newMacros = [calories, fats, carbs, protein]
                print("Macro/Calorie Needs: Exactly The Same")
            }
            print("Weight change: \(weightChange)")
            print(newMacros)
            return newMacros
        
        //MARK: 250 < 300: lose 4.0
        case 250..<300:
            switch weightChange {
            case (2.01)...(1000):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.9)
                print("Macro/Calorie Needs: Significantly Less")
            case (0.51)..<(2.01):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.93)
                print("Macro/Calorie Needs: Much Less")
            case (-0.39)..<(0.51):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.96)
                print("Macro/Calorie Needs: A Bit Less")
            case (-6.0)..<(-4.0):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.04)
                print("Macro/Calorie Needs: A Bit More")
            case (-7.0)..<(-6.0):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.07)
                print("Macro/Calorie Needs: Much More")
            case (-1000)..<(-7.0):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.1)
                print("Macro/Calorie Needs: Significantly More")
            default: // (-4.0)...(-0.4) = 4 pounds in a week
                newMacros = [calories, fats, carbs, protein]
                print("Macro/Calorie Needs: Exactly The Same")
            }
            print("Weight change: \(weightChange)")
            print(newMacros)
            return newMacros
        
        //MARK: 300 < 350: lose 5.0
        case 300..<350:
            switch weightChange {
            case (2.01)...(1000):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.9)
                print("Macro/Calorie Needs: Significantly Less")
            case (0.51)..<(2.01):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.93)
                print("Macro/Calorie Needs: Much Less")
            case (-0.39)..<(0.51):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.96)
                print("Macro/Calorie Needs: A Bit Less")
            case (-7.0)..<(-5.0):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.04)
                print("Macro/Calorie Needs: A Bit More")
            case (-8.0)..<(-7.0):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.07)
                print("Macro/Calorie Needs: Much More")
            case (-1000)..<(-8.0):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.1)
                print("Macro/Calorie Needs: Significantly More")
            default: // (-5.0)...(-0.4) = 5 pounds in a week
                newMacros = [calories, fats, carbs, protein]
                print("Macro/Calorie Needs: Exactly The Same")
            }
            print("Weight change: \(weightChange)")
            print(newMacros)
            return newMacros
            
        //MARK: 350+: lose 6.0
        default: // weight over 350lbs
            switch weightChange {
            case (2.01)...(1000):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.9)
                print("Macro/Calorie Needs: Significantly Less")
            case (0.51)..<(2.01):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.93)
                print("Macro/Calorie Needs: Much Less")
            case (-0.39)..<(0.51):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.96)
                print("Macro/Calorie Needs: A Bit Less")
            case (-7.5)..<(-6.0):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.04)
                print("Macro/Calorie Needs: A Bit More")
            case (-8.5)..<(-7.5):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.07)
                print("Macro/Calorie Needs: Much More")
            case (-1000)..<(-8.5):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.1)
                print("Macro/Calorie Needs: Significantly More")
            default: // (-6.0)...(-0.4) = 6 pounds in a week
                newMacros = [calories, fats, carbs, protein]
                print("Macro/Calorie Needs: Exactly The Same")
            }
            print("Weight change: \(weightChange)")
            print(newMacros)
            return newMacros
        }
    }
    
    //MARK: AdjustMacros(Maintenance)
    
    func adjustMacrosMaintenance(previousWeight: Double,
                      weight: Double,
                      calories: Double,
                      fats: Double,
                      carbs: Double,
                      protein: Double,
                      weightChange: Double) -> [Double] {
        
        //let weightChange = weight - previousWeight
        var newMacros: [Double]
        
        switch user.previousWeight {
        //MARK: <200: 2 lb variance
        case 0.0..<200.0:
            switch weightChange {
            case (3.01)...(1000):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.9)
                print("Macro/Calorie Needs: Significantly Less")
            case (2.01)..<(3.01):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.93)
                print("Macro/Calorie Needs: Much Less")
            case (1.01)..<(2.01):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.96)
                print("Macro/Calorie Needs: A Bit Less")
            case (-2.0)..<(-1.0):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.04)
                print("Macro/Calorie Needs: A Bit More")
            case (-3.0)..<(-2.0):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.07)
                print("Macro/Calorie Needs: Much More")
            case (-1000)..<(-3.0):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.1)
                print("Macro/Calorie Needs: Significantly More")
            default: // (-1.0)...(1.0) = +/- 1 lb in a week
                newMacros = [calories, fats, carbs, protein]
                print("Macro/Calorie Needs: Exactly The Same")
            }
            print("Weight change: \(weightChange)")
            print(newMacros)
            return newMacros
        
        //MARK: 200 < 250: 3 lb variance
        case 200.0..<250:
            switch weightChange {
            case (3.51)...(1000):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.9)
                print("Macro/Calorie Needs: Significantly Less")
            case (2.51)..<(3.51):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.93)
                print("Macro/Calorie Needs: Much Less")
            case (1.51)..<(2.51):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.96)
                print("Macro/Calorie Needs: A Bit Less")
            case (-2.5)..<(-1.5):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.04)
                print("Macro/Calorie Needs: A Bit More")
            case (-3.0)..<(-2.5):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.07)
                print("Macro/Calorie Needs: Much More")
            case (-1000)..<(-3.0):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.1)
                print("Macro/Calorie Needs: Significantly More")
            default: // (-1.5)...(1.5) = +/- 1.5 lbs in a week
                newMacros = [calories, fats, carbs, protein]
                print("Macro/Calorie Needs: Exactly The Same")
            }
            print("Weight change: \(weightChange)")
            print(newMacros)
            return newMacros
        
        //MARK: 250+: 4 lb variance
        default:
            switch weightChange {
            case (4.01)...(1000):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.9)
                print("Macro/Calorie Needs: Significantly Less")
            case (3.01)..<(4.01):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.93)
                print("Macro/Calorie Needs: Much Less")
            case (2.01)..<(3.01):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.96)
                print("Macro/Calorie Needs: A Bit Less")
            case (-3.0)..<(-2.0):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.04)
                print("Macro/Calorie Needs: A Bit More")
            case (-4.0)..<(-3.0):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.07)
                print("Macro/Calorie Needs: Much More")
            case (-1000)..<(-4.0):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.1)
                print("Macro/Calorie Needs: Significantly More")
            default: // (-2.0)...(2.0) = +/- 2 lbs in a week
                newMacros = [calories, fats, carbs, protein]
                print("Macro/Calorie Needs: Exactly The Same")
            }
            print("Weight change: \(weightChange)")
            print(newMacros)
            return newMacros
        }
    }
    
    //MARK: AdjustMacros(MuscleGrow)
    
    func adjustMacrosMuscleGrowth(previousWeight: Double,
                      weight: Double,
                      calories: Double,
                      fats: Double,
                      carbs: Double,
                      protein: Double,
                      weightChange: Double) -> [Double] {
        
        //let weightChange = weight - previousWeight
        var newMacros: [Double]
        
        switch user.previousWeight {
        //MARK: <200: +0.5 - 2 lbs
        case 0.0..<200.0:
            switch weightChange {
            case (4.0)...(1000):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.9)
                print("Macro/Calorie Needs: Significantly Less")
            case (3.0)..<(4.0):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.93)
                print("Macro/Calorie Needs: Much Less")
            case (2.01)..<(3.0):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.96)
                print("Macro/Calorie Needs: A Bit Less")
            case (-0.1)..<(0.5):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.04)
                print("Macro/Calorie Needs: A Bit More")
            case (-1.5)..<(-0.1):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.07)
                print("Macro/Calorie Needs: Much More")
            case (-1000)..<(-1.5):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.1)
                print("Macro/Calorie Needs: Significantly More")
            default: // (0.5)...(2.0) = gain 0.5 - 2 lbs in a week
                newMacros = [calories, fats, carbs, protein]
                print("Macro/Calorie Needs: Exactly The Same")
            }
            print("Weight change: \(weightChange)")
            print(newMacros)
            return newMacros
        
        //MARK: 200+: +0.5 - 2 lbs
            //higher upper calorie adjustment thresholds
        default: //200.0+
            switch weightChange {
            case (4.5)...(1000):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.9)
                print("Macro/Calorie Needs: Significantly Less")
            case (3.5)..<(4.5):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.93)
                print("Macro/Calorie Needs: Much Less")
            case (2.01)..<(3.5):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 0.96)
                print("Macro/Calorie Needs: A Bit Less")
            case (-0.1)..<(0.5):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.04)
                print("Macro/Calorie Needs: A Bit More")
            case (-1.5)..<(-0.1):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.07)
                print("Macro/Calorie Needs: Much More")
            case (-1000)..<(-1.5):
                newMacros = adjustMacrosHelper(calories: calories, fats: fats, carbs: carbs, protein: protein, calorieMultiplier: 1.1)
                print("Macro/Calorie Needs: Significantly More")
            default: // (0.5)...(2.0) = gain 0.5 - 2 lbs in a week
                newMacros = [calories, fats, carbs, protein]
                print("Macro/Calorie Needs: Exactly The Same")
            }
            print("Weight change: \(weightChange)")
            print(newMacros)
            return newMacros
        }
    }
    
    //MARK: AdjustMacrosHelper
    func adjustMacrosHelper(calories: Double,
                    fats: Double,
                    carbs: Double,
                    protein: Double,
                    calorieMultiplier: Double) -> [Double] {
        
        
        let newCalorieMultiplier = calorieMultiplier
        let newFatsMultiplier = 0.4
        let newCarbsMultiplier = 1.0 - newFatsMultiplier
        let newProteinMultiplier = 1.0
        
        let updatedCalories = calories * newCalorieMultiplier
        let updatedFats = fats - ((calories - updatedCalories) * newFatsMultiplier / 9)
        let updatedCarbs = carbs - ((calories - updatedCalories) * newCarbsMultiplier / 4)
        let updatedProtein = (protein * newProteinMultiplier)// - (user.weight - user.lastPreviousWeight)
        
        let updatedMacros = [updatedCalories, updatedFats, updatedCarbs, updatedProtein]
        
        return updatedMacros
    }
}
