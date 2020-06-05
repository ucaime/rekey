//
//  ViewController.swift
//  Rekey
//
//  Created by 邵磊 on 2020/6/3.
//  Copyright © 2020 邵磊. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var dragDropView: DragDropView!
    @IBOutlet weak var ProgressIndicator: NSProgressIndicator!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //初始化拖拽逻辑
        dragDropView.acceptedFileExtensions = ["key"]
        dragDropView.usedArrowImage = true
        
        var allFiles:[URL] = []
        dragDropView.setup({ (file) in
            allFiles.append(file)
            self.doRekeys(allFiles)
        }) { (files) in
            allFiles = files
            self.doRekeys(allFiles)
        }

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    public func doRekey(_ file:URL) {
        RekeyFile()?.reduceFile(file)
        self.notifine(file)
    }
    
    public func doRekeys(_ files:[URL]) {
        self.ProgressIndicator.isHidden = false
        self.ProgressIndicator.startAnimation(nil)
        self.dragDropView.isHidden = false
        
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            files.forEach({(file) in
                self.doRekey(file)
            })
            group.leave()
        }
        group.notify(queue: .main, execute: {
            self.ProgressIndicator.isHidden = true
            self.ProgressIndicator.stopAnimation(nil)
            
            self.dragDropView.isHidden = false
        })
    }
    
    public func notifine(_ file:URL) {
        let notification = NSUserNotification()
        notification.title = "演示文稿优化压缩"
        notification.informativeText = file.lastPathComponent + " 处理完成"
        //notification.responsePlaceholder = "Placeholder"

        NSUserNotificationCenter.default.deliver(notification)
    }
    
    func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        return true
    }
    @IBAction func openLink(_ sender: Any) {
        let url = URL(string: "https://www.yuque.com/layne.app/rekey/intro")!
        if NSWorkspace.shared.open(url) {
            print("default browser was successfully opened")
        }
    }
}
