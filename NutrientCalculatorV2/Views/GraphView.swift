//
//  GraphView.swift
//  NutrientCalculatorV2
//
//  Created by Kyle Blandford on 2/25/22.
//

import SwiftUI

struct GraphView: View {
    
    @EnvironmentObject var viewModel: EnvironmentViewModel
            
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let startDate: String
    private let endDate: String
    @State private var percentage: CGFloat = 0
    
    init(user: User) {
        data = user.weightArray
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        startDate = user.firstDate
        endDate = user.previousDate
    }
    
    var body: some View {
        VStack {
            graphView
                .frame(height: 200)
                .padding(.horizontal, 30)
                .background(chartBackground)
                .overlay(chartAxis, alignment: .leading)

            chartDateLabels
                .padding(.horizontal, 15)
        }
        .font(.caption)
        .foregroundColor(Color.gray)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.linear(duration: 1.5)) {
                    percentage = 1.0
                }
            }
        }
    }
}

extension GraphView {
    
    private var graphView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    
                    //xPosition index of 0 starts and 0 and adds based on width of the screen and number of data points with specific amount of remainder added onto each point to finish at end of screen
                    //if screen width of 100:
                    //3 weights:
                    //Index 0 -> x = 0 + (0) = 0,
                    //Index 1 -> x = 33.33 + ((1/(3-1)) * (100/3)) = 50,
                    //Index 2 -> x = 66.66 + ((2/(3-1)) * (100/3)) = 100
                    let xPosition = (CGFloat(index) * (geometry.size.width / CGFloat(data.count)) + ((CGFloat(index) / CGFloat((data.count - 1))) * (geometry.size.width / CGFloat(data.count))))
                    
                    let yAxis = maxY - minY
                    
                    //coordinates 0,0 start at top left on iphone so we need to invert it
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    
                    print(yPosition)
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yAxis == 0.0 ? geometry.size.height * 0.5 : yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yAxis == 0.0 ? geometry.size.height * 0.5 : yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(Color.graphColor, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
            .shadow(color: Color.graphColor, radius: 10, x: 0, y: 5)
            .shadow(color: Color.graphColor.opacity(0.5), radius: 10, x: 0, y: 10)
        }
    }
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartAxis: some View {
        VStack {
            if viewModel.user.totalWeighIns <= 1 || maxY - minY == 0.0 {
                Text("")
                Spacer()
                Text("")
                Spacer()
                let weight2 = (maxY + minY) / 2
                if weight2 == 0 {
                    Text("")
                } else {
                    Text("\(weight2, specifier: "%.1f")")
                }
                Spacer()
                Text("")
                Spacer()
            } else {
                Text("\(maxY, specifier: "%.1f")")
                Spacer()
                let weight1 = maxY - ((maxY - ((maxY + minY) / 2)) / 2)
                Text("\(weight1, specifier: "%.1f")")
                Spacer()
                let weight2 = (maxY + minY) / 2
                Text("\(weight2, specifier: "%.1f")")
                Spacer()
                let weight3 = minY + ((maxY - ((maxY + minY) / 2)) / 2)
                Text("\(weight3, specifier: "%.1f")")
                Spacer()
                Text("\(minY, specifier: "%.1f")")
            }
        }
    }
    
    private var chartDateLabels: some View {
        HStack {
            Text(startDate)
            Spacer()
            Text(endDate)
        }
    }
}

