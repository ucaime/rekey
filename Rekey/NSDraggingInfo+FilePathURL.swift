//
//  NSDraggingInfo+FilePathURL.swift
//  Rekey
//
//  Created by 邵磊 on 2020/6/3.
//  Copyright © 2020 邵磊. All rights reserved.
//

import AppKit

extension NSDraggingInfo {
    var filePathURLs: [URL] {
        var filenames : [String]?
        var urls: [URL] = []
        
        if #available(OSX 10.13, *) {
            filenames = draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType("NSFilenamesPboardType")) as? [String]
        } else {
            // Fallback on earlier versions
            filenames = draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType("NSFilenamesPboardType")) as? [String]
        }
        
        if let filenames = filenames {
            for filename in filenames {
                urls.append(URL(fileURLWithPath: filename))
            }
            return urls
        }
        
        return []
    }
}

