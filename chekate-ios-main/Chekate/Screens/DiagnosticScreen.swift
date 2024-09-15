import SwiftUI
import Foundation

struct DiagnosticScreen: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State var isAnalyzingPrompt = false
    @EnvironmentObject var router: AppRouter
    
    @State var isAnalyzing: Bool = false
    @State var result: String = ""

    var body: some View {
        ScrollView {
            if isAnalyzing {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 64) {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            VStack(alignment: .center, spacing: 24) {
                                Image("StetoscopeImage").asResizableIcon(size: CGSize(width: 96, height: 96))
                                Text("Procesando Síntomas").fontStyle(withStyle: .subtitle, fontColor: .black)
                            }
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    .withDefaultAppPadding()
                    .padding(.top, -16)

                    Spacer()
                }
            } else {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 64) {
                        SectionHeader(title: "Describe Tus Síntomas", subtitle: "Cuéntanos como te sientes")
                        
                        VStack(spacing: 12) {
                            HStack {
                                Spacer()
                                
                                Button(
                                    action: {
                                        if speechRecognizer.isRecording {
                                            speechRecognizer.stopRecording()
                                        } else {
                                            speechRecognizer.startRecording()
                                        }
                                    }
                                ) {
                                    Image("MicListenerImage").asResizableIcon(size: CGSize(width: 128, height: 128))
                                }
                                
                                Spacer()
                            }
                            
                            Text(speechRecognizer.isRecording ? "Grabando Voz" : "Presiona el micrófono para grabar tu diagnostico")
                            
                            if !speechRecognizer.recognizedText.isEmpty, !speechRecognizer.isRecording {
                                Text("Verifica que hayas descrito tus sintomas correctamente")
                                    .fontStyle(withStyle: .body, fontColor: .gray)
                                    .padding(.top, 12)
                            }
                        }
                        
                        AppSection {
                            VStack(alignment: .leading) {
                                Text(speechRecognizer.recognizedText.isEmpty ? "Comienza a hablar..." : speechRecognizer.recognizedText)
                                    .fontStyle(withStyle: .body, fontColor: speechRecognizer.recognizedText.isEmpty ? .gray : .black)
                            }
                            .withDefaultSectionPadding()
                        }
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                speechRecognizer.stopRecording()

                                Task.detached(priority: .userInitiated) {
                                    let error = await analyzePrompt()

                                    DispatchQueue.main.async {
                                        if error == nil {
                                            router.append(toScreen: .result(prompt: speechRecognizer.recognizedText, result: result))
                                        }
                                    }
                                }
                            }) {
                                Text("Obten tu diagnóstico")
                                    .withDefaultSectionPadding()
                                    .fontStyle(withStyle: .body, fontColor: .white)
                                    .background(speechRecognizer.recognizedText.isEmpty ? .gray : .blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                            .disabled(speechRecognizer.recognizedText.isEmpty)
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                }
                .withDefaultAppPadding()
                .padding(.top, -16)
            }
        }
    }

    private func analyzePrompt() async -> NetworkError? {
        let networkClient = NetworkClient()
        
        isAnalyzing = true
        
        var result = await networkClient.executeV3(call: DiagnosePromptCall(body: DiagnoseInput(prompt: speechRecognizer.recognizedText)))
        
        switch result {
            case .success(let response):
                self.result = response?.prompt ?? ""
            case .failure(let error):
                debugPrint(error)
        }

        isAnalyzing = false

        return nil
    }
}
