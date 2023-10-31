//
//  CalculatorUI.swift
//  MenuBarCalculator
//
//  Created by Jared Schoeny on 10/30/23.
//  Copyright © 2023 Jared Schoeny. All rights reserved.
//

import SwiftUI

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
                }
                Button(action: {}) {
                    Text("+/-")
                }
                Button(action: {}) {
                    Text("%")
                }
                Button(action: {}) {
                    Text("÷")
                }
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
                }
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
                }
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
                }
            }
            HStack(spacing: 1) {
                Button(action: {}) {
                    Text("0")
                }
                Button(action: {}) {
                    Text(".")
                }
                Button(action: {}) {
                    Text("=")
                }
            }
        }.padding()
            .fixedSize()
            .frame(minWidth: 200, minHeight: 300)
    }
}

//#Preview {
//    CalculatorUI(appDelegate: nil)
//}
