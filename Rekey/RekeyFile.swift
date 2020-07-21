//
//  RekeyFile.swift
//  Rekey
//
//  Created by 邵磊 on 2020/6/4.
//  Copyright © 2020 邵磊. All rights reserved.
// 

//务必注意解压文件的乱码问题，需要调整        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_2312_80);


import Cocoa
import SSZipArchive

class RekeyFile {
    var tmpDir: String = ""
    var fileURL: URL?
    var fileName: String = "" //文件名，不包含扩展
    var newFile: String = "" //新的拟定文件
    var tmpProjectDir: String = ""
    
    required init?() {
        let homeDirectory = NSTemporaryDirectory()
        self.tmpDir = homeDirectory + "Rekey"
        //print(tmpDir)
    }
    
    public func reduceFile(_ fileURL:URL){
        self.fileURL = fileURL
        self.fileName = RekeyFile.getName(fileStr: fileURL.lastPathComponent)
        self.newFile = self.newName()
        self.tmpProjectDir = tmpDir + "/" + fileName
        
        //文件解压
        SSZipArchive.unzipFile(atPath: fileURL.path, toDestination: tmpProjectDir)
        
        compess()

        //生成新文件
        SSZipArchive.createZipFile(atPath: self.newFile, withContentsOfDirectory: tmpProjectDir)

        //垃圾清理
        let manager = FileManager.default
        if (manager.fileExists(atPath: tmpProjectDir)) {
           try! manager.removeItem(atPath: tmpProjectDir)
        }
        //return true
    }
    
    //获取文件名
    static func getName(fileStr:String) -> String {
        //这里以后要想办法解决不是.key的问题
        let last = fileStr.index(fileStr.endIndex, offsetBy: -4)
        return String(fileStr[..<last])
    }
    
    //生成最终文件名
    public func newName() ->String {
        let baseNewName = self.fileName + "（压缩）"
        let fullPath = (self.fileURL?.deletingLastPathComponent().path ??  "") + "/" + baseNewName
        let manager = FileManager.default
        if !manager.fileExists(atPath: fullPath + ".key") {
            return (fullPath + ".key")
        }
        var fix = 1
        while manager.fileExists(atPath: fullPath + "-" + String(fix) + ".key") {
            fix += 1
        }
        return (fullPath + "-" + String(fix) + ".key")
    }
    
    //TIFF文件转换
    public func compess() {
        let optipngFile = Bundle.main.path(forResource: "optipng", ofType: "")! as String
        let manager = FileManager.default
        let directoryContents = try? manager.contentsOfDirectory(at: URL.init(fileURLWithPath: self.tmpProjectDir + "/Data", isDirectory: false), includingPropertiesForKeys: nil, options: [])

        let tiffFiles: [URL] = (directoryContents?.filter{ $0.pathExtension == "tiff" })!
        
        tiffFiles.forEach({(img) in
            let path = img.path
            let compressProcess = Process()
            compressProcess.launchPath = optipngFile
            let argument = "--out " + path
            compressProcess.arguments = [path, argument, "--quiet"]
            //print(compressProcess.arguments)
            compressProcess.launch()
            compressProcess.waitUntilExit()
//            try! manager.removeItem(atPath: path)
//            try! manager.moveItem(atPath: path + ".out", toPath: path)
        })
        
    }
    
    //打包生成新的文件
    
}
