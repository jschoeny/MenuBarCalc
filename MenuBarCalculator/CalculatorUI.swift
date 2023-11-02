//
//  CalculatorUI.swift
//  MenuBarCalculator
//
//  Created by Jared Schoeny on 10/30/23.
//  Copyright © 2023 Jared Schoeny. All rights reserved.
//

import SwiftUI
import Combine

struct CalculatorButtonStyle: ButtonStyle {
    let colors = [Color("Gray"), Color("Orange"), Color("Dark Gray"), Color("Orange Selected")]
    var colorIndex : Int = 0
    var span : Int = 1
    var border : Bool = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 50 * CGFloat(span) + (1 * CGFloat(span-1)), height: 50)
            .background(colors[colorIndex])
            .foregroundColor(.white)
            .cornerRadius(0)
            .font(.system(size: colorIndex != 1 ? 20 : 26, weight: .semibold, design: .monospaced))
            .opacity(configuration.isPressed ? 0.5 : 1)
            .overlay(
                border ?
                    Rectangle()
                        .stroke(Color.white, lineWidth: 1)
                : nil
            )
    }
}

enum CalculatorOperation {
    case add
    case subtract
    case multiply
    case divide
    case none
    case cancelled
}

enum Focus : Hashable {
    case focused
}

struct CalculatorUI: View {
    @Namespace var mainNamespace
    @State var calculatorString = "0"
    @State var decimalPlace : Int = 0
    @State var usingDecimal : Bool = false
    @State var valueEntered : Bool = false
    @State var valueCalculated : Bool = false
    @State var pendingSecondaryValue : Bool = false
    @State var currentOp : CalculatorOperation = .none
    @State var previousOp : CalculatorOperation = .none
    @State private var calculatorTyper = ""
    @FocusState public var focus : Focus?
    
    @State var app : AppDelegate
    let numberFormat = NumberFormatter()

    init(appDelegate: AppDelegate) {
        app = appDelegate
        focus = nil
        
        numberFormat.numberStyle = .decimal
        numberFormat.maximumFractionDigits = 10
        numberFormat.minimumFractionDigits = 0
    }
    
    func updateNumber(_ number: NSNumber) {
        app.calculatorValue = number
        calculatorString = (numberFormat.string(from: app.calculatorValue) ?? "0")
    }

    func appendNumber(_ number: NSNumber) {
        valueEntered = true
        if(pendingSecondaryValue) {
            app.calculatorValue = 0
            pendingSecondaryValue = false
        }
        if(calculatorString.replacingOccurrences(of: ",", with: "").count >= 12) {
            return
        }
        if(currentOp == .cancelled) {
            currentOp = .none
            updateNumber(number)
            decimalPlace = 0
            usingDecimal = false
            return
        }
        if(valueCalculated) {
            app.calculatorValue = 0
            decimalPlace = 0
            usingDecimal = false
            valueCalculated = false
        }
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
        valueEntered = false
        if(currentOp == .cancelled) {
            updateNumber(0)
            decimalPlace = 0
            usingDecimal = false
            return
        }
        if(currentOp != .none) {
            currentOp = .cancelled
            updateNumber(app.previousValue)
            if(calculatorString.firstIndex(of: ".") == nil) {
                decimalPlace = 0
                usingDecimal = false
            }
            else {
                decimalPlace = calculatorString.distance(from: calculatorString.firstIndex(of: ".")!, to: calculatorString.endIndex) - 1
            }
            return
        }
        if(app.calculatorValue == 0) {
            app.update()
            previousOp = .none
        }
        app.previousValue = app.calculatorValue
        app.calculatorValue = 0
        decimalPlace = 0
        usingDecimal = false
        calculatorString = "0"
    }

    func enableDecimal() {
        valueEntered = true
        if(pendingSecondaryValue) {
            updateNumber(0)
            pendingSecondaryValue = false
        }
        if(currentOp == .cancelled || valueCalculated) {
            currentOp = .none
            updateNumber(0)
            decimalPlace = 0
            usingDecimal = false
            valueCalculated = false
        }
        if(!usingDecimal) {
            usingDecimal = true
            decimalPlace = 0
            calculatorString += "."
        }
    }
    
    func negateValue() {
        updateNumber(NSNumber(value: -app.calculatorValue.doubleValue))
    }
    
    func percentValue() {
        updateNumber(NSNumber(value: app.calculatorValue.doubleValue / 100))
    }
    
    func calculateValue() {
        var op = currentOp
        var a = app.previousValue
        var b = app.calculatorValue
        if(previousOp != .none && currentOp == .none) {
            op = previousOp
            a = app.calculatorValue
            b = app.previousValue
        }
        let v = NSNumber(value: app.calculatorValue.doubleValue)
        switch(op) {
        case .add:
            updateNumber(NSNumber(value: a.doubleValue + b.doubleValue))
            break;
        case .subtract:
            updateNumber(NSNumber(value: a.doubleValue - b.doubleValue))
            break;
        case .multiply:
            updateNumber(NSNumber(value: a.doubleValue * b.doubleValue))
            break;
        case .divide:
            updateNumber(NSNumber(value: a.doubleValue / b.doubleValue))
            break;
        default:
            updateNumber(v)
            break;
        }
        if(previousOp == .none && currentOp != .none) {
            previousOp = currentOp
            app.previousValue = v
        }
        currentOp = .none
        valueCalculated = true
    }

    func setOperation(_ op: CalculatorOperation) {
        app.previousValue = app.calculatorValue
        currentOp = op
        previousOp = .none
        decimalPlace = 0
        usingDecimal = false
        pendingSecondaryValue = true
    }
    
    func performButtonPress(key: String) {
        switch(key) {
        case "0":
            appendNumber(0)
            break
        case "1":
            appendNumber(1)
            break
        case "2":
            appendNumber(2)
            break
        case "3":
            appendNumber(3)
            break
        case "4":
            appendNumber(4)
            break
        case "5":
            appendNumber(5)
            break
        case "6":
            appendNumber(6)
            break
        case "7":
            appendNumber(7)
            break
        case "8":
            appendNumber(8)
            break
        case "9":
            appendNumber(9)
            break
        case ".":
            enableDecimal()
            break
        case "+":
            setOperation(.add)
            break
        case "-":
            setOperation(.subtract)
            break
        case "x":
            setOperation(.multiply)
            break
        case "*":
            setOperation(.multiply)
            break
        case "/":
            setOperation(.divide)
            break
        case "=":
            calculateValue()
            break
        case "%":
            percentValue()
            break
        case "delete":
            if(pendingSecondaryValue || valueCalculated) {
                break
            }
            if(usingDecimal) {
                if(decimalPlace > 0) {
                    decimalPlace -= 1
                    let newValue = NSNumber(value: floor(app.calculatorValue.doubleValue * pow(10, Double(decimalPlace))) / pow(10, Double(decimalPlace)))
                    updateNumber(newValue)
                }
                else {
                    usingDecimal = false
                    decimalPlace = 0
                    updateNumber(NSNumber(value: floor(app.calculatorValue.doubleValue)))
                }
            }
            else if(app.calculatorValue == 0) {
                if(currentOp != .none) {
                    break
                }
                app.update()
            }
            else {
                updateNumber(NSNumber(value: floor(app.calculatorValue.doubleValue / 10)))
            }
            if(app.calculatorValue == 0) {
                valueEntered = false
            }
            break
        default:
            break
        }
    }

    var body: some View {
        VStack(spacing: 1) {
            HStack(spacing: 0) {
                TextField("", text: $calculatorTyper)
                    .font(.system(size: 30))
                    .frame(minWidth: 180, maxWidth: 180, minHeight: 40, maxHeight: 40, alignment: .trailing)
                    .prefersDefaultFocus(in: mainNamespace)
                    .focused($focus, equals: .focused)
                    .opacity(0)
                    .textSelection(.disabled)
                    .overlay {
                        Text(calculatorString)
                            .font(.system(size: 30))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .frame(minWidth: 180, maxWidth: 180, minHeight: 40, maxHeight: 40, alignment: .trailing)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            focus = .focused
                        }
                    }
                    .onReceive(Just(calculatorTyper)) { newValue in
                        if(newValue.isEmpty) {
                            performButtonPress(key: "delete")
                        }
                        else {
                            let val = newValue.replacingOccurrences(of: " ", with: "")
                            performButtonPress(key: val)
                        }
                        calculatorTyper = " "
                    }
                    .onSubmit {
                        calculateValue()
                    }
            }.padding(EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10))
            HStack(spacing: 1) {
                Button(action: {clearValue()}) {
                    Text(valueEntered ? "C" : "AC")
                }.buttonStyle(CalculatorButtonStyle(colorIndex: 2))
                Button(action: {negateValue()}) {
                    Text("+/-")
                }.buttonStyle(CalculatorButtonStyle(colorIndex: 2))
                Button(action: {percentValue()}) {
                    Text("%")
                }.buttonStyle(CalculatorButtonStyle(colorIndex: 2))
                Button(action: {setOperation(.divide)}) {
                    Text("÷")
                }.buttonStyle(CalculatorButtonStyle(colorIndex: currentOp == .divide ? 3 : 1, border: currentOp == .divide))
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
                Button(action: {setOperation(.multiply)}) {
                    Text("×")
                }.buttonStyle(CalculatorButtonStyle(colorIndex: currentOp == .multiply ? 3 : 1, border: currentOp == .multiply))
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
                Button(action: {setOperation(.subtract)}) {
                    Text("-")
                }.buttonStyle(CalculatorButtonStyle(colorIndex: currentOp == .subtract ? 3 : 1, border: currentOp == .subtract))
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
                Button(action: {setOperation(.add)}) {
                    Text("+")
                }.buttonStyle(CalculatorButtonStyle(colorIndex: currentOp == .add ? 3 : 1, border: currentOp == .add))
            }
            HStack(spacing: 1) {
                Button(action: {appendNumber(0)}) {
                    Text("0")
                }.buttonStyle(CalculatorButtonStyle(span: 2))
                Button(action: {enableDecimal()}) {
                    Text(".")
                }
                Button(action: {calculateValue()}) {
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
