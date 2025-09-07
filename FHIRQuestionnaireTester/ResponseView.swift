//
//  ResponseView.swift
//  FHIRQuestionnaireTester
//
//  Created by Vishnu Ravi on 6/4/25.
//

import SwiftUI
import ModelsR4

struct ResponseView: View {
    let questionnaireResponse: String
    let originalFileName: String?
    @Environment(\.dismiss) private var dismiss
    @State private var showingShareSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(questionnaireResponse)
                        .font(.system(.body, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            }
            .navigationTitle("Questionnaire Response")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingShareSheet = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                ActivityViewController(activityItems: [createJSONFile()])
            }
        }
    }
    
    private func createJSONFile() -> URL {
        let baseFileName: String
        if let originalFileName = originalFileName {
            let nameWithoutExtension = (originalFileName as NSString).deletingPathExtension
            baseFileName = "\(nameWithoutExtension)-response"
        } else {
            baseFileName = "questionnaire-response"
        }
        
        let fileName = "\(baseFileName)-\(Date().timeIntervalSince1970).json"
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(fileName)
        
        do {
            try questionnaireResponse.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error creating file: \(error)")
        }
        
        return fileURL
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}

