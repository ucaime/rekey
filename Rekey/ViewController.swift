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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //初始化拖拽逻辑
        dragDropView.acceptedFileExtensions = ["key"]
        dragDropView.usedArrowImage = true
        dragDropView.setup({ (file) in
            //print(file.lastPathComponent)
            self.doRekey(file)
            
        }) { (files) in
            files.forEach({(file) in
                self.doRekey(file)
            })
        }
    }
    
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    public func doRekey(_ file:URL) {
        Thread.detachNewThread {
            RekeyFile()?.reduceFile(file)
            self.notifine(file)
        }
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



}

//
