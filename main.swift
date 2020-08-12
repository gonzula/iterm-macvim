//
//  main.swift
//  Vim
//
//  Created by Gonzo on 12/08/20.
//  Copyright © 2020 Gonzo. All rights reserved.
//

import Cocoa

let delegate = AppDelegate()
NSApplication.shared.delegate = delegate
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
