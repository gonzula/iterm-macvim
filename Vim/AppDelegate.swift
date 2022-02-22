//
//  AppDelegate.swift
//  Vim
//
//  Created by Gonzo on 12/08/20.
//  Copyright © 2020 Gonzo. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
//    @IBOutlet weak var window: NSWindow!
    
    var alreadyFinishedLaunching = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("applicationDidFinishLaunching")
        alreadyFinishedLaunching = true
    }
    
    func applicationOpenUntitledFile(_ sender: NSApplication) -> Bool {
        guard alreadyFinishedLaunching else {return false}
        openFile(url: URL(fileURLWithPath: "/tmp/\(UUID().uuidString)"))
        return true
    }
    
    @IBAction func newPythonScript(_ sender: NSMenuItem) {
        openFile(url: URL(fileURLWithPath: "/tmp/\(UUID().uuidString).py"))
    }
    
    func application(_ sender: Any, openFileWithoutUI filename: String) -> Bool {
        openFile(url: URL(fileURLWithPath: filename))
        return true
    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        urls.forEach(openFile(url:))
    }
    
    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        filenames
            .compactMap(URL.init(fileURLWithPath:))
            .forEach(openFile(url:))
    }
    
    func openFile(url: URL) {
        let fullPath = url.path
        let directoryPath = (fullPath as NSString).deletingLastPathComponent
        let fileName = (fullPath as NSString).lastPathComponent
        
        print(directoryPath)
        print(fileName)
        
        
        let getPathScript = """
        -- set dirPath to quoted form of POSIX path of \(directoryPath)
        -- set fileName to quoted form of POSIX path of \(fileName)
        
        -- set theCmd to " cd " & dirPath & ";clear; pwd"
        set theCmd to " cd '\(directoryPath)' ;clear; pwd; nvim '\(fileName)'; exit"

           tell application "iTerm"
               create window with default profile
               tell front window
                   tell current session
                       write text (theCmd)
                   end tell
               end tell
           end tell
        """
        
        print(getPathScript)

        var error: NSDictionary?
        guard let scriptObject = NSAppleScript(source: getPathScript) else {return}
        let output = scriptObject.executeAndReturnError(&error)
        guard error == nil else {
            print(error!)
            return
        }
        guard let returnValue = output.stringValue else {return}
        print(returnValue)
    }
}

/*
let getPathScript = """
(*

    Open Terminal Here

    A toolbar script for Mac OS X 10.3/10.4

    Written by Brian Schlining
 *)


property debug : false

-- when the toolbar script icon is clicked
--
on run
 tell application "Finder"
  try
   set this_folder to (the target of the front window) as alias
  on error
   set this_folder to startup disk
  end try

  my process_item(this_folder)

 end tell
end run


-- This handler processes folders dropped onto the toolbar script icon
--
on open these_items
 repeat with i from 1 to the count of these_items
  set this_item to item i of these_items
  my process_item(this_item)
 end repeat
end open


-- this subroutine processes does the actual work
-- this version can handle this weirdo case: a folder named "te'st"ö te%s`t"

on process_item(this_item)

 set thePath to quoted form of POSIX path of this_item
 set theCmd to " cd " & thePath & ";clear; pwd"

    tell application "iTerm"
        create window with default profile
        tell front window
            tell current session
                write text (theCmd)
            end tell
        end tell
    end tell


end process_item

"""
*/
