//
//  CalculatorUI.swift
//  MenuBarCalculator
//
//  Created by Jared Schoeny on 10/30/23.
//  Copyright © 2023 Jared Schoeny. All rights reserved.
//

import SwiftUI

struct CalculatorButtonStyle: ButtonStyle {
    let colors = [Color("Gray"), Color("Orange"), Color("Dark Gray"), Color("Orange Selected")]
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
    @State var calculatorString = "0"
    @State var decimalPlace : Int = 0
    @State var usingDecimal : Bool = false
    
    @State var app : AppDelegate
    let numberFormat = NumberFormatter()

    init(appDelegate: AppDelegate) {
        app = appDelegate
        
        numberFormat.numberStyle = .decimal
        numberFormat.maximumFractionDigits = 10
        numberFormat.minimumFractionDigits = 0
    }
    
    func updateNumber(_ number: NSNumber) {
        app.calculatorValue = number
        calculatorString = (numberFormat.string(from: app.calculatorValue) ?? "0")
    }

    func appendNumber(_ number: NSNumber) {
        if(usingDecimal) {
            decimalPlace += 1
            updateNumber(NSNumber(value: app.calculatorValue.doubleValue + (number.doubleValue / pow(10, Double(decimalPlace)))))
            if(calculatorString.firstIndex(of: ".") == nil) {
                calculatorString = calculatorString + "."
            }
            var realDecimalPlaces = calculatorString.distance(from: calculatorString.firstIndex(of: ".")!, to: calculatorString.endIndex) - 1
            while(realDecimalPlaces < decimalPlace) {
                calculatorString = calculatorString + "0"
                realDecimalPlaces += 1
            }
        }
        else {
            decimalPlace = 0
            updateNumber(NSNumber(value: app.calculatorValue.doubleValue * 10 + number.doubleValue))
        }
    }
    
    func clearValue() {
        if(app.calculatorValue == 0) {
            app.update()
            return
        }
        app.calculatorValue = 0
        decimalPlace = 0
        usingDecimal = false
        calculatorString = "0"
        app.update(value: calculatorValue)
    }

    func enableDecimal() {
        if(!usingDecimal) {
            usingDecimal = true
            decimalPlace = 0
            calculatorString += "."
        }
    }
    
    var body: some View {
        VStack(spacing: 1) {
            HStack(spacing: 0) {
                Spacer()
                Text(calculatorString)
                    .font(.largeTitle)
            }.padding(EdgeInsets(top: 20, leading: 0, bottom: 10, trailing: 10))
            HStack(spacing: 1) {
                Button(action: {clearValue()}) {
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
                Button(action: {appendNumber(7)}) {
                    Text("7")
                }
                Button(action: {appendNumber(8)}) {
                    Text("8")
                }
                Button(action: {appendNumber(9)}) {
                    Text("9")
                }
                Button(action: {}) {
                    Text("×")
                }.buttonStyle(CalculatorButtonStyle(colorIndex: 1))
            }
            HStack(spacing: 1) {
                Button(action: {appendNumber(4)}) {
                    Text("4")
                }
                Button(action: {appendNumber(5)}) {
                    Text("5")
                }
                Button(action: {appendNumber(6)}) {
                    Text("6")
                }
                Button(action: {}) {
                    Text("-")
                }.buttonStyle(CalculatorButtonStyle(colorIndex: 1))
            }
            HStack(spacing: 1) {
                Button(action: {appendNumber(1)}) {
                    Text("1")
                }
                Button(action: {appendNumber(2)}) {
                    Text("2")
                }
                Button(action: {appendNumber(3)}) {
                    Text("3")
                }
                Button(action: {}) {
                    Text("+")
                }.buttonStyle(CalculatorButtonStyle(colorIndex: 1))
            }
            HStack(spacing: 1) {
                Button(action: {appendNumber(0)}) {
                    Text("0")
                }.buttonStyle(CalculatorButtonStyle(span: 2))
                Button(action: {enableDecimal()}) {
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
