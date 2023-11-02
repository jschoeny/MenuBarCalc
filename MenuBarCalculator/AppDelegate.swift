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
    var calcMenu = NSMenu()
    var contextMenu = NSMenu()

    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    @IBAction func launchAtLoginClicked(_ sender: NSMenuItem) {
        LaunchAtLogin.isEnabled = !LaunchAtLogin.isEnabled
        sender.state = LaunchAtLogin.isEnabled ? .on : .off
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        calculator = CalculatorUI(appDelegate: self)
        
        calcMenu.delegate = self
        calcMenu.identifier = NSUserInterfaceItemIdentifier("Calculator")
        
        let calculatorView = NSHostingView(rootView: calculator)
        calculatorView.frame = NSRect(x: 0, y: 0, width: 200, height: 325)
        let calcMenuItem = NSMenuItem()
        calcMenuItem.view = calculatorView
        calcMenu.addItem(calcMenuItem)
        
        contextMenu.delegate = self
        
        let loginMenuItem = NSMenuItem()
        loginMenuItem.title = "Open At Login"
        loginMenuItem.action = #selector(launchAtLoginClicked(_:))
        loginMenuItem.state = LaunchAtLogin.isEnabled ? .on : .off
        contextMenu.addItem(loginMenuItem)
        contextMenu.addItem(withTitle: "Quit", action: #selector(quitClicked(_:)), keyEquivalent: "")
        
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
        statusItem.button?.action = #selector(self.statusBarButtonClicked(sender:))
        statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }
    
    @objc func statusBarButtonClicked(sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
    
        if event.type ==  NSEvent.EventType.rightMouseUp || event.modifierFlags.contains(.control) {
            statusItem.menu = contextMenu
        } else {
            statusItem.menu = calcMenu
        }
        statusItem.button?.performClick(nil)
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
        statusItem.menu = nil
        if(menu.identifier == NSUserInterfaceItemIdentifier("Calculator") && calculatorValue != 0) {
            update(value: calculatorValue)
        }
    }

}
