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
    @Environment(\.dismiss) private var dismiss
    
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

