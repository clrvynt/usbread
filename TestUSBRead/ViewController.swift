//
//  ViewController.swift
//  TestUSBRead
//
//  Created by kalyankrishnamurthi on 3/4/20.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit
import MobileCoreServices


class ViewController: UIViewController, UIDocumentPickerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeFolder as String], in: .open)
        documentPicker.delegate = self
        documentPicker.shouldShowFileExtensions = true
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Cancelled")
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("didPickDocuments at \(urls)")
        let pickedFolderURL = urls[0]
        // Reading the Content of a Picked Folder
        let shouldStopAccessing = pickedFolderURL.startAccessingSecurityScopedResource()
        defer {
            if shouldStopAccessing {
                pickedFolderURL.stopAccessingSecurityScopedResource()
            }
        }
        var coordinatedError:NSError?
        NSFileCoordinator().coordinate(readingItemAt: pickedFolderURL, error: &coordinatedError) { (folderURL) in
            let keys : [URLResourceKey] = [.nameKey, .isDirectoryKey, .isReadableKey, .fileSecurityKey, .fileProtectionKey]
            let fileList = FileManager.default.enumerator(at: pickedFolderURL, includingPropertiesForKeys: keys)!
            for case let file as URL in fileList {
                print(file)
                do { try print(file.resourceValues(forKeys: Set(keys))) } catch { print(error) }
                if !file.hasDirectoryPath {
                    print(file)
                    guard file.startAccessingSecurityScopedResource() else {
                        // Handle the failure here.
                        print("THIS ALWAYS FAILS!")
                        continue
                    }
                    // Make sure you release the security-scoped resource when you are done.
                    defer { file.stopAccessingSecurityScopedResource() }
                    
                    // I can read the file
                    
                }
            }
        }
    }

}

