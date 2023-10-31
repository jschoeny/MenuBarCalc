//
//  CalculatorUI.swift
//  MenuBarCalculator
//
//  Created by Jared Schoeny on 10/30/23.
//  Copyright © 2023 Jared Schoeny. All rights reserved.
//

import SwiftUI

struct CalculatorButtonStyle: ButtonStyle {
    let colors = [Color.gray, Color.orange, Color(red: 0.3, green: 0.3, blue: 0.3)]
    var colorIndex : Int = 0
    var span : Int = 1
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 50 * CGFloat(span) + (1 * CGFloat(span-1)), height: 50)
            .background(colors[colorIndex])
            .foregroundColor(.white)
            .cornerRadius(0)
            .font(.system(size: colorIndex != 1 ? 20 : 26, weight: .semibold, design: .monospaced))
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

struct CalculatorUI: View {
    @State public var calculatorValue : NSNumber = 0
    @State var calculatorString = "0"
    
    @State var app : AppDelegate
    let numberFormat = NumberFormatter()

    init(appDelegate: AppDelegate) {
        app = appDelegate
        
        numberFormat.numberStyle = .decimal
        numberFormat.maximumFractionDigits = 10
        numberFormat.minimumFractionDigits = 0
    }

    var body: some View {
        VStack(spacing: 1) {
            HStack(spacing: 0) {
                Spacer()
                Text(calculatorString)
                    .font(.largeTitle)
            }.padding(EdgeInsets(top: 20, leading: 0, bottom: 10, trailing: 10))
            HStack(spacing: 1) {
                Button(action: {}) {
                    Text("AC")
                }.buttonStyle(CalculatorButtonStyle(colorIndex: 2))
                Button(action: {}) {
                    Text("+/-")
                }.buttonStyle(CalculatorButtonStyle(colorIndex: 2))
                Button(action: {}) {
                    Text("%")
                }.buttonStyle(CalculatorButtonStyle(colorIndex: 2))
                Button(action: {}) {
                    Text("÷")
                }.buttonStyle(CalculatorButtonStyle(colorIndex: 1))
            }
            HStack(spacing: 1) {
                Button(action: {}) {
                    Text("7")
                }
                Button(action: {}) {
                    Text("8")
                }
                Button(action: {}) {
                    Text("9")
                }
                Button(action: {}) {
                    Text("×")
                }.buttonStyle(CalculatorButtonStyle(colorIndex: 1))
            }
            HStack(spacing: 1) {
                Button(action: {}) {
                    Text("4")
                }
                Button(action: {}) {
                    Text("5")
                }
                Button(action: {}) {
                    Text("6")
                }
                Button(action: {}) {
                    Text("-")
                }.buttonStyle(CalculatorButtonStyle(colorIndex: 1))
            }
            HStack(spacing: 1) {
                Button(action: {}) {
                    Text("1")
                }
                Button(action: {}) {
                    Text("2")
                }
                Button(action: {}) {
                    Text("3")
                }
                Button(action: {}) {
                    Text("+")
                }.buttonStyle(CalculatorButtonStyle(colorIndex: 1))
            }
            HStack(spacing: 1) {
                Button(action: {}) {
                    Text("0")
                }.buttonStyle(CalculatorButtonStyle(span: 2))
                Button(action: {}) {
                    Text(".")
                }
                Button(action: {}) {
                    Text("=")
                }.buttonStyle(CalculatorButtonStyle(colorIndex: 1))
            }
        }.padding()
            .buttonStyle(CalculatorButtonStyle())
            .fixedSize()
            .frame(minWidth: 200, minHeight: 300)
    }
}

//#Preview {
//    CalculatorUI(appDelegate: nil)
//}
