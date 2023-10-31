//
//  AppDelegate.swift
//  MenuBarCalculator
//
//  Created by Jared Schoeny on 10/30/23.
//  Copyright © 2023 Jared Schoeny. All rights reserved.
//

import Cocoa
import SwiftUI


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let numberFormat = NumberFormatter()
    var calculatorResult = ""
    var iconView: NSHostingView<AnyView>!

    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let calculator = CalculatorUI(appDelegate: self)
        let contentView = NSHostingView(rootView: calculator)
        contentView.frame = NSRect(x: 0, y: 0, width: 200, height: 325)
        
        let menuItem = NSMenuItem()
        menuItem.view = contentView
        let menu = NSMenu()
        menu.addItem(menuItem)
        
        statusItem.menu = menu
        
        numberFormat.numberStyle = .decimal
        numberFormat.maximumFractionDigits = 2
        numberFormat.minimumFractionDigits = 0
        
        calculatorResult = numberFormat.string(from: calculator.calculatorValue) ?? ""
        
        let iconSwiftUI = HStack(alignment: .center, content: {
            Spacer()
            Image("CalculatorIcon")
                .resizable()
                .frame(width: 16, height: 16)
            Spacer()
        }).padding(2)
        
        iconView = NSHostingView(rootView: AnyView(iconSwiftUI))
        iconView?.frame = NSRect(x: 0, y: 0, width: (iconView?.intrinsicContentSize.width)!, height: (iconView?.intrinsicContentSize.height)!)
        statusItem.button?.addSubview(iconView!)
        statusItem.button?.frame = iconView!.frame
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func update(value: NSNumber? = nil) {
        if(value != nil) {
            calculatorResult = numberFormat.string(from: value!) ?? ""
        }
        else {
            calculatorResult = ""
        }
        let iconSwiftUI = HStack(alignment: .center, content: {
            if(calculatorResult.isEmpty) {
                Spacer()
            }
            Image("CalculatorIcon")
                .resizable()
                .frame(width: 16, height: 16)
            if(!calculatorResult.isEmpty) {
                Text("= " + calculatorResult)
            }
            else {
                Spacer()
            }
        }).padding(2)
        
        iconView?.rootView = AnyView(iconSwiftUI)
        iconView?.frame = NSRect(x: 0, y: 0, width: (iconView?.intrinsicContentSize.width)!, height: (iconView?.intrinsicContentSize.height)!)
        statusItem.button?.frame = iconView!.frame
    }

}
