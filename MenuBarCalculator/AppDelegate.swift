//
//  AppDelegate.swift
//  MenuBarCalculator
//
//  Created by Jared Schoeny on 10/30/23.
//  Copyright © 2023 Jared Schoeny. All rights reserved.
//

import Cocoa
import SwiftUI
import LaunchAtLogin

@NSApplicationMain
class AppDelegate: NSViewController, NSApplicationDelegate, NSMenuDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let numberFormat = NumberFormatter()
    public var calculatorValue: NSNumber = 0
    var calculatorResult = ""
    var iconView: NSHostingView<AnyView>!
    var calculator: CalculatorUI!

    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    @IBAction func launchAtLoginClicked(_ sender: NSMenuItem) {
        LaunchAtLogin.isEnabled = !LaunchAtLogin.isEnabled
        sender.state = LaunchAtLogin.isEnabled ? .on : .off
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        calculator = CalculatorUI(appDelegate: self)
        let contentView = NSHostingView(rootView: calculator)
        contentView.frame = NSRect(x: 0, y: 0, width: 200, height: 325)
        
        let menuItem = NSMenuItem()
        menuItem.view = contentView
        let menu = NSMenu()
        menu.delegate = self
        menu.identifier = NSUserInterfaceItemIdentifier("Calculator")
        menu.addItem(menuItem)
        menu.addItem(NSMenuItem.separator())
        let loginMenuItem = NSMenuItem()
        loginMenuItem.title = "Open At Login"
        loginMenuItem.action = #selector(launchAtLoginClicked(_:))
        menu.addItem(loginMenuItem)
        menu.addItem(withTitle: "Quit", action: #selector(quitClicked(_:)), keyEquivalent: "")
        
        statusItem.menu = menu
        
        numberFormat.numberStyle = .decimal
        numberFormat.maximumFractionDigits = 2
        numberFormat.minimumFractionDigits = 0
        
        calculatorResult = numberFormat.string(from: calculatorValue) ?? ""
        
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
    
    func menuDidClose(_ menu: NSMenu) {
        if(menu.identifier == NSUserInterfaceItemIdentifier("Calculator") && calculatorValue != 0) {
            update(value: calculatorValue)
        }
    }

}
