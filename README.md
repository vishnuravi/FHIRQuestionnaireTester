# FHIR Questionnaire Tester

A native iOS app for testing FHIR Questionnaire JSON files built using the Phoenix Survey Builder](https://stanfordbdhg.github.io/phoenix/) and [ResearchKitOnFHIR](https://github.com/StanfordBDHG/ResearchKitOnFHIR). Using these tools, the app automatically handles the conversion between FHIR Questionnaire format and [ResearchKit](https://github.com/ResearchKit/ResearchKit)'s native survey format.

## What it does

This app allows you to:
- Load [FHIR Questionnaire](https://hl7.org/fhir/questionnaire.html) JSON files from your device
- Present them as interactive surveys using ResearchKit
- Generate and view [FHIR QuestionnaireResponse](https://hl7.org/fhir/questionnaireresponse.html) JSON output

## Requirements

- An iOS simulator or iOS device for running the app
- A Mac computer with Xcode 16+ installed for development
- One or more FHIR R4 Questionnaire JSON files that you wish to test

## Building the App

1. Clone the repository from GitHub
2. Open the `FHIRQuestionnaireTester.xcodeproj` project file in Xcode
3. Build and run on iOS Simulator or your iOS device

## How to use

1. **Create a questionnaire**: You can create a FHIR Questionnaire using the [Phoenix Survey Builder](https://stanfordbdhg.github.io/phoenix/) tool. Download the questionnaire as a JSON file and copy it to your iOS device or simulator.
1. **Load a questionnaire**: Tap "Select JSON File" and choose a FHIR Questionnaire JSON file from your device or simulator.
2. **Complete the survey**: The app will present the questionnaire as an interactive survey using ResearchKit.
3. **View results**: After completion, the app will show the generated FHIR QuestionnaireResponse JSON.
