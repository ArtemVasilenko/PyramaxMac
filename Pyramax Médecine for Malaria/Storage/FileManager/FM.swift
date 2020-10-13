//  FM.swift
//  MedicalApp
//
//  Created by Alex Kholodoff on 9/16/19.
//  Copyright © 2019 iOS Team. All rights reserved.

import Foundation

// TODO: - need to make through Protocol
struct FM {
    
    private static var db = DB()
    
    public static var temporaryDirectoryURL: URL {
        return FileManager.default.temporaryDirectory
    }
    
    public static func fileURLInDocumentDirectory(_ fileName: String) -> URL {
        
        let url = self.temporaryDirectoryURL.appendingPathComponent(fileName)
        print("fileName = ", fileName, ", url = " ,url)
        return url
    }
    
    // func get data and name file, create jpg file in folder Documenters
    public static func storeImageToDocumentDirectory(data: Data, fileName: String) -> URL? {
        
        let fileURL = self.fileURLInDocumentDirectory(fileName)
        do {
            try data.write(to: fileURL)
            print("fileURL = ", fileURL)
            return fileURL
        } catch {
            return nil
        }
    }
    
    public static func getUrlForSlide(_ id: Int) -> URL{
        let url = FM.temporaryDirectoryURL.appendingPathComponent("\(id)")
        return url
    }
    
    // MARK: - create dir for storage pic and video from of the slide in Document Directory if dir not exist
    public static func createDir(_ id: Int) {
        
        // check if the file already exist at the destination folder if you don't want to download it twice
        if !FileManager.default.fileExists(atPath: FM.temporaryDirectoryURL.appendingPathComponent("\(id)").path) {
            
            print("Dir \(id) no exist, create it dir!")
            
            let url = FM.temporaryDirectoryURL.appendingPathComponent("\(id)")
            
            do {
                try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("error create dir: ", id)
            }
        } else {
            // Rice directory exists
            print("/\(id) directory exists!")
        }
        
        printListItemsFromDir(temporaryDirectoryURL.path)
    }
    
    // TODO: - move in init for Model DocSlide
    // MARK: - check info adout doc for slide in folder Documents
    public static func checkDocSlide(_ info: [DocSlide]) {
        
        if info.count < 1 {
            print("not exists doc for it slide")
            return
        }
                
        let idSilde = info[0].idSlide
        
        // first, check exist dir for slide
        FM.createDir(idSilde)
        
        // second, check in loop exist docs for slide
        info.forEach{
            
            // check exist doc on name
            let idDoc = $0.idDoc
            let nameDoc = $0.nameDoc
            
            if !FileManager.default.fileExists(atPath: FM.temporaryDirectoryURL.appendingPathComponent("\(idSilde)/\(nameDoc)").path) {
                
                print("File \(idSilde)/\(nameDoc) no exist, create it file!")
                
                let url = FM.temporaryDirectoryURL.appendingPathComponent("\(idSilde)/\(nameDoc)")
                
                print("url for file save = ",url)
                                
                // save doc in folder from BD - getDataFromBlob
                let data = FM.db.getDataFromBlob(idDoc)
                
                do {
                    try data.write(to: url)
                    print("file \(nameDoc) successfully create and save in folder \(idSilde)/")
                } catch {
                    print("file \(nameDoc) NOT save in folder \(idSilde)/")
                }
                
            } else {
                print("File \(idSilde)/\(nameDoc) exist!")
            }
        }
    }
    
    // MARK: - print list items from dir
    static func printListItemsFromDir(_ path: String) {
        
        do {
            let items = try FileManager.default.contentsOfDirectory(atPath: path)

            for item in items {
                print("Found \(item)")
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
    }
    
    // MARK: - get url of the HTML file
    static func getUrlHTMLFile(id: Int, nameFile: String) -> URL {
        
        let url = FM.temporaryDirectoryURL.appendingPathComponent("\(id)/\(nameFile).html")
        
        print("for name \(nameFile) create url: ", url)
        return url
    }
    
    // MARK: - create and save HTML file
    static func saveHTMLFile(html: String, url: URL) {
                
        do {
            try html.write(to: url, atomically: true, encoding: .utf8)
            print("file \(url.path) successfully create and save")
        } catch {
            print("file \(url.path) NOT save")
        }
    }
}
