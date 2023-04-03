//
//  ContentView.swift
//  hello_swift
//
//  Created by ljh on 4/1/23.
//

import SwiftUI

/*
 project navigator / Targets / Signing & Capabilities / App Sandbox:
    User Selected File: Read/Write;
    Downloads Folder: Read/Write;
 */

struct ContentView: View {
    @State private var fileDialogShown: Bool = false
    var body: some View {
        HStack {
            Button("Button1") { fileDialogShown = true }
                .fileImporter(isPresented: $fileDialogShown,
                              allowedContentTypes: [.plainText])
                { result in
                    guard let file = try? result.get() else { return }
                    //Sandbox: User Selected File
                    hello(file: file.absoluteString)
                }
            Button("Button2") { hello2() }
        }.frame(minWidth: 300, minHeight: 300)
    }
    
    func hello2(){
        //Sandbox: Downloads Folder, ~/Downloads
        let dir = FileManager.default.urls(for: .downloadsDirectory,
                                           in: .userDomainMask).first!
        let file = dir.appendingPathComponent("hello.txt")
        hello(file: file.absoluteString)
    }
    
    func hello(file: String){
        var file = file
        file.removeSubrange(file.startIndex..<file.range(
            of: "file://")!.upperBound)
        while file.range(of: "%20") != nil {
            file.replaceSubrange(file.range(
                of: "%20")!.lowerBound..<file.range(of:
                                        "%20")!.upperBound, with: " ")
        }

        var fp = fopen(file, "a")
        if fp == nil {
            perror("fopen")
            return;
        }
        fputs("hello1\n", fp)
        fputs("hello2\n", fp)
        fclose(fp)

        fp = fopen(file, "r")
        var buffer = [CChar](repeating: 0, count: 128)
        while fgets(&buffer, Int32(buffer.count), fp) != nil {
            print(String(cString: buffer), terminator: "")
        }
        fclose(fp);
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}