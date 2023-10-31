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
    var calculatorResult = ""

    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.menu = statusMenu
        // Assign random number to calculatorResult
        calculatorResult = String(Int.random(in: 0...1000))
        update()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func update() {
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
        
        let iconView = NSHostingView(rootView: iconSwiftUI)
        iconView.frame = NSRect(x: 0, y: 0, width: iconView.intrinsicContentSize.width, height: iconView.intrinsicContentSize.height)
        statusItem.button?.addSubview(iconView)
        statusItem.button?.frame = iconView.frame
    }

}
