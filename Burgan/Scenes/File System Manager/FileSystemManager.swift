//
//  FileSystemManager.swift
//  Burgan
//
//  Created by Pratik on 22/07/21.
//  Copyright © 2021 1st iMac. All rights reserved.
//

import Foundation

enum AppDirectories : String
{
    case Documents = "Documents"
    case Inbox = "Inbox"
    case Library = "Library"
    case Temp = "tmp"
}

protocol AppDirectoryNames
{
    func documentsDirectoryURL() -> URL
    
    func inboxDirectoryURL() -> URL
    
    func libraryDirectoryURL() -> URL
    
    func tempDirectoryURL() -> URL
    
    func getURL(for directory: AppDirectories) -> URL
    
    func buildFullPath(forFileName name: String, inDirectory directory: AppDirectories) -> URL
} // end protocol AppDirectoryNames
extension AppDirectoryNames
{
    func documentsDirectoryURL() -> URL
    {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func inboxDirectoryURL() -> URL
    {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(AppDirectories.Inbox.rawValue) // "Inbox")
    }
    
    func libraryDirectoryURL() -> URL
    {
        return FileManager.default.urls(for: FileManager.SearchPathDirectory.libraryDirectory, in: .userDomainMask).first!
    }
    
    func tempDirectoryURL() -> URL
    {
        return FileManager.default.temporaryDirectory
        //urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(AppDirectories.Temp.rawValue) //"tmp")
    }
    
    func getURL(for directory: AppDirectories) -> URL
    {
        switch directory
        {
        case .Documents:
            return documentsDirectoryURL()
        case .Inbox:
            return inboxDirectoryURL()
        case .Library:
            return libraryDirectoryURL()
        case .Temp:
            return tempDirectoryURL()
        }
    }
    
    func buildFullPath(forFileName name: String, inDirectory directory: AppDirectories) -> URL
    {
        return getURL(for: directory).appendingPathComponent(name)
    }
} // end extension AppDirectoryNames
protocol AppFileStatusChecking
{
    func isWritable(file at: URL) -> Bool
    
    func isReadable(file at: URL) -> Bool
    
    func exists(file at: URL) -> Bool
}

extension AppFileStatusChecking
{
    func isWritable(file at: URL) -> Bool
    {
        if FileManager.default.isWritableFile(atPath: at.path)
        {
            print(at.path)
            return true
        }
        else
        {
            print(at.path)
            return false
        }
    }
    
    func isReadable(file at: URL) -> Bool
    {
        if FileManager.default.isReadableFile(atPath: at.path)
        {
            print(at.path)
            return true
        }
        else
        {
            print(at.path)
            return false
        }
    }
    
    func exists(file at: URL) -> Bool
    {
        if FileManager.default.fileExists(atPath: at.path)
        {
            return true
        }
        else
        {
            return false
        }
    }
} // end extension AppFileStatusChecking
protocol AppFileSystemMetaData
{
    func list(directory at: URL) -> Bool
    
    func attributes(ofFile atFullPath: URL) -> [FileAttributeKey : Any]
}

extension AppFileSystemMetaData
{
    func list(directory at: URL) -> Bool
    {
        let listing = try! FileManager.default.contentsOfDirectory(atPath: at.path)
        
        if listing.count > 0
        {
            print("\n----------------------------")
            print("LISTING: \(at.path)")
            print("")
            for file in listing
            {
                print("File: \(file.debugDescription)")
            }
            print("")
            print("----------------------------\n")
            
            return true
        }
        else
        {
            return false
        }
    }
    
    func attributes(ofFile atFullPath: URL) -> [FileAttributeKey : Any]
    {
        return try! FileManager.default.attributesOfItem(atPath: atFullPath.path)
    }
} // end extension AppFileSystemMetaData
protocol AppFileManipulation : AppDirectoryNames
{
    func writeFile(containing: String, to path: AppDirectories, withName name: String) -> Bool
    
    func writeFile(containing: Data, to path: AppDirectories, withName name: String) -> Bool
    
    func readFile(at path: AppDirectories, withName name: String) -> String
    
    func deleteFile(at path: AppDirectories, withName name: String) -> Bool
    
    func renameFile(at path: AppDirectories, with oldName: String, to newName: String) -> Bool
    
    func moveFile(withName name: String, inDirectory: AppDirectories, toDirectory directory: AppDirectories) -> Bool
    
    func copyFile(withName name: String, inDirectory: AppDirectories, toDirectory directory: AppDirectories) -> Bool
    
    func changeFileExtension(withName name: String, inDirectory: AppDirectories, toNewExtension newExtension: String) -> Bool
}


extension AppFileManipulation
{
    func writeFile(containing: String, to path: AppDirectories, withName name: String) -> Bool
    {
        let filePath = getURL(for: path).path + "/" + name
        let rawData: Data? = containing.data(using: .utf8)
        return FileManager.default.createFile(atPath: filePath, contents: rawData, attributes: nil)
    }
    
    func writeFile(containing: Data, to path: AppDirectories, withName name: String) -> Bool
    {
        let filePath = getURL(for: path).path + "/" + name
        let rawData: Data? = containing
        return FileManager.default.createFile(atPath: filePath, contents: rawData, attributes: nil)
    }
    
    func readFile(at path: AppDirectories, withName name: String) -> String
    {
        let filePath = getURL(for: path).path + "/" + name
        let fileContents = FileManager.default.contents(atPath: filePath)
        let fileContentsAsString = String(bytes: fileContents!, encoding: .utf8)
        print(fileContentsAsString!)
        return fileContentsAsString!
    }
    
    func deleteFile(at path: AppDirectories, withName name: String) -> Bool
    {
        let filePath = buildFullPath(forFileName: name, inDirectory: path)
        try! FileManager.default.removeItem(at: filePath)
        return true
    }
    
    func renameFile(at path: AppDirectories, with oldName: String, to newName: String) -> Bool
    {
        let oldPath = getURL(for: path).appendingPathComponent(oldName)
        let newPath = getURL(for: path).appendingPathComponent(newName)
        try! FileManager.default.moveItem(at: oldPath, to: newPath)
        
        // highlights the limitations of using return values
        return true
    }
    
    func moveFile(withName name: String, inDirectory: AppDirectories, toDirectory directory: AppDirectories) -> Bool
    {
        let originURL = buildFullPath(forFileName: name, inDirectory: inDirectory)
        let destinationURL = buildFullPath(forFileName: name, inDirectory: directory)
        // warning: constant 'success' inferred to have type '()', which may be unexpected
        // let success =
        try! FileManager.default.moveItem(at: originURL, to: destinationURL)
        return true
    }
    
    func copyFile(withName name: String, inDirectory: AppDirectories, toDirectory directory: AppDirectories) -> Bool
    {
        let originURL = buildFullPath(forFileName: name, inDirectory: inDirectory)
        let destinationURL = buildFullPath(forFileName: name+"1", inDirectory: directory)
        try! FileManager.default.copyItem(at: originURL, to: destinationURL)
        return true
    }
    
    func changeFileExtension(withName name: String, inDirectory: AppDirectories, toNewExtension newExtension: String) -> Bool
    {
        var newFileName = NSString(string:name)
        newFileName = newFileName.deletingPathExtension as NSString
        newFileName = (newFileName.appendingPathExtension(newExtension) as NSString?)!
        let finalFileName:String =  String(newFileName)
        
        let originURL = buildFullPath(forFileName: name, inDirectory: inDirectory)
        let destinationURL = buildFullPath(forFileName: finalFileName, inDirectory: inDirectory)
        
        try! FileManager.default.moveItem(at: originURL, to: destinationURL)
        
        return true
    }
}
 // end extension AppFileManipulation
struct AppFile : AppFileManipulation, AppFileStatusChecking, AppFileSystemMetaData
{
    
    
    let fileName: String
    
    let fileData: Data

    
    init(fileName: String, fileData: Data)
    {
        self.fileName = fileName
        self.fileData = fileData
    }
    
    
    

  
    //
    func readFile(at path: AppDirectories, withName name: String) -> String {
        return fileName//readFile(at: filePath, withName: fileName)
    }
    
    func deleteFile(at path: AppDirectories, withName name: String) -> Bool {
        return true//deleteFile(at: filePath, withName: fileName)
    }
    
    func renameFile(at path: AppDirectories, with oldName: String, to newName: String) -> Bool {
        return true//renameFile(at: filePath, with: fileOldName, to: fileNewName)
    }
    
    func moveFile(withName name: String, inDirectory: AppDirectories, toDirectory directory: AppDirectories) -> Bool {
        
        return true//moveFile(withName: fileName, inDirectory: fileInDirectory, toDirectory: fileToDirectory)
    }
    
    func copyFile(withName name: String, inDirectory: AppDirectories, toDirectory directory: AppDirectories) -> Bool {
        return true//copyFile(withName: fileName, inDirectory: fileInDirectory, toDirectory: fileToDirectory)
    }
    
    func changeFileExtension(withName name: String, inDirectory: AppDirectories, toNewExtension newExtension: String) -> Bool {
        return true//changeFileExtension(withName: fileName, inDirectory: fileInDirectory, toNewExtension: fileToNewExtension)
    }
    
        func write() -> Bool
        {
            _ = writeFile(containing: fileData, to: .Documents, withName: fileName)
            

            return true
        }

    //
    
    
//    func moveToDocuments()
//    {
//        _ = moveFile(withName: fileName, inDirectory: .Inbox, toDirectory: .Documents)
//    }
//
//    func deleteTempFile()
//    {
//        _ = deleteFile(at: .Temp, withName: fileName)
//    }
//    
//    func write() -> Bool
//    {
//        _ = writeFile(containing: "This file was written on 5/23/18.\n\nThis file should show up in the Files app.", to: .Documents, withName: "myFileApp.txt")
//        //writeFile(containing: "We were talking\nAbout the space\nBetween us all", to: .Documents, withName: "karma.txt")
//        // writeFile(containing: "And the people\nWho hide themselves\nBehind a wall", to: .Documents, withName: "dharma.txt")
//        return true
//    }
//    
//    func list() -> Bool
//    {
//        return list(directory: getURL(for: .Documents))
//    }
//    
//    func getAttribs()
//    {
//        let attribs = attributes(ofFile: buildFullPath(forFileName: "karma.txt", inDirectory: .Documents))
//        for (key, value) in attribs
//        {
//            print("\(key) value is \(value)")
//        }
//    }
}
