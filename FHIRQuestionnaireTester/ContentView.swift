//
//  ContentView.swift
//  FHIRQuestionnaireTester
//
//  Created by Vishnu Ravi on 6/4/25.
//

import ResearchKitOnFHIR
import SwiftUI
import ResearchKit
import UniformTypeIdentifiers
import ModelsR4

struct ContentView: View {
    @State private var showingFilePicker = false
    @State private var showingQuestionnaire = false
    @State private var selectedFile: URL?
    @State private var questionnaire: ModelsR4.Questionnaire?
    @State private var task: ORKNavigableOrderedTask?
    @State private var errorMessage: String?
    @State private var showingError = false
    @State private var questionnaireResponse = ""
    @State private var showingResponse = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
    
                Spacer()
                
                Image(systemName: "doc.text.fill")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .font(.system(size: 60))
                
                Text("FHIR Questionnaire Tester")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Select a FHIR Questionnaire JSON file to begin")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Button("Select JSON File") {
                    showingFilePicker = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
        .fileImporter(
            isPresented: $showingFilePicker,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let files):
                if let file = files.first {
                    selectedFile = file
                    loadQuestionnaire(from: file)
                    showingQuestionnaire = true
                }
            case .failure(let error):
                errorMessage = "Failed to select file: \(error.localizedDescription)"
                showingError = true
            }
        }
        .fullScreenCover(isPresented: $showingQuestionnaire) {
            if let task = task {
                QuestionnaireView(task: task) { result in
                    handleQuestionnaireCompletion(result: result)
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            if let errorMessage = errorMessage {
                Text(errorMessage)
            }
        }
        .sheet(isPresented: Binding(
            get: { showingResponse && !questionnaireResponse.isEmpty },
            set: { showingResponse = $0 }
        )) {
            ResponseView(questionnaireResponse: questionnaireResponse)
        }
    }
    
    private func loadQuestionnaire(from url: URL) {
        do {
            // Access the security-scoped resource
            let accessing = url.startAccessingSecurityScopedResource()
            defer {
                if accessing {
                    url.stopAccessingSecurityScopedResource()
                }
            }
            
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let loadedQuestionnaire = try decoder.decode(ModelsR4.Questionnaire.self, from: data)
            
            // Create ResearchKit task from FHIR Questionnaire
            let orkTask = try ORKNavigableOrderedTask(questionnaire: loadedQuestionnaire)
            
            // Update state on main thread
            DispatchQueue.main.async {
                self.questionnaire = loadedQuestionnaire
                self.task = orkTask
                self.errorMessage = nil
            }
            
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to load questionnaire: \(error.localizedDescription)"
                self.showingError = true
            }
        }
    }
    
    @MainActor
    private func handleQuestionnaireCompletion(result: ORKTaskResult) {
        showingQuestionnaire = false

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(result.fhirResponse)
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
                questionnaireResponse = jsonString
                showingResponse = true
            }
        } catch {
            print("Can't extract response JSON.")
        }
        
        selectedFile = nil
        questionnaire = nil
        task = nil
    }
}

#Preview {
    ContentView()
}
