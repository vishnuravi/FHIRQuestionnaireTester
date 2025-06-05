//
//  QuestionnaireView.swift
//  FHIRQuestionnaireTester
//
//  Created by Vishnu Ravi on 6/4/25.
//

import ResearchKit
import ResearchKitSwiftUI
import SwiftUI


struct QuestionnaireView: UIViewControllerRepresentable {
    let task: ORKNavigableOrderedTask
    let onCompletion: (ORKTaskResult) -> Void
    
    func makeUIViewController(context: Context) -> ORKTaskViewController {
        let taskViewController = ORKTaskViewController(task: task, taskRun: nil)
        taskViewController.delegate = context.coordinator
        return taskViewController
    }
    
    func updateUIViewController(_ uiViewController: ORKTaskViewController, context: Context) {
        // No updates needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onCompletion: onCompletion)
    }
    
    class Coordinator: NSObject, ORKTaskViewControllerDelegate {
        let onCompletion: (ORKTaskResult) -> Void
        
        init(onCompletion: @escaping (ORKTaskResult) -> Void) {
            self.onCompletion = onCompletion
        }
        
        func taskViewController(
            _ taskViewController: ORKTaskViewController,
            didFinishWith reason: ORKTaskFinishReason,
            error: Error?
        ) {
            switch reason {
            case .completed:
                onCompletion(taskViewController.result)
            case .discarded, .failed, .saved, .earlyTermination:
                taskViewController.dismiss(animated: true)
                break
            @unknown default:
                break
            }
        }
    }
}
