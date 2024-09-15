import SwiftUI
import Speech

struct ResultsScreen: View {
    let prompt: String
    let result: String
    @State private var speechSynthesizer: AVSpeechSynthesizer?

    @State var emailText: String = ""
    @State var phoneText: String = ""
    @State var sendToMedics: Bool = false
    
    @EnvironmentObject var router: AppRouter

    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 32) {
                    SectionHeader(title: "Describe Tus Síntomas", subtitle: "Cuéntanos como te sientes")
                    
                    AppSection(title: "Tus síntomas") {
                        Text(prompt).fontStyle(withStyle: .body)
                            .withDefaultSectionPadding()
                    }
                    
                    AppSection(title: "Nuestro análisis preeliminar") {
                        Text(result).fontStyle(withStyle: .body)
                            .withDefaultSectionPadding()
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        AppSection(icon: Image("DocumentIcon"), title: "Envia tus resultados", subtitle: "Te enviaremos una copia del pronostico a tu contacto") {
                            VStack(alignment: .leading) {
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Correo Electrónico").fontStyle(withStyle: .subtitle, fontColor: .black)
                                        
                                        TextField("", text: $emailText)
                                            .withDefaultSectionPadding()
                                            .background(Color("FormTextColor"))
                                            .fontStyle(withStyle: .body)
                                            .lineLimit(1)
                                            .textInputAutocapitalization(.words)
                                            .disableAutocorrection(true)
                                            .keyboardType(.emailAddress)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                            .frame(width: 300)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Teléfono").fontStyle(withStyle: .subtitle, fontColor: .black)
                                        
                                        TextField("", text: $phoneText)
                                            .withDefaultSectionPadding()
                                            .background(Color("FormTextColor"))
                                            .fontStyle(withStyle: .body)
                                            .lineLimit(1)
                                            .textInputAutocapitalization(.words)
                                            .disableAutocorrection(true)
                                            .keyboardType(.numberPad)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                            .frame(width: 300)
                                    }
                                }
                                
                                Divider()
                                
                                Toggle("Enviar diagnóstico al doctor en turno", isOn: $sendToMedics)
                            }
                            .withDefaultSectionPadding()
                        }
                        
                        HStack(alignment: .center, spacing: 24) {
                            Spacer()
                            
                            Button(action: {
                                router.exit()
                            }) {
                                Text("Enviar")
                                    .withDefaultSectionPadding()
                                    .fontStyle(withStyle: .body, fontColor: .white)
                                    .background(.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                            
                            Button(action: {
                                router.exit()
                            }) {
                                Text("Imprimir Resultados")
                                    .withDefaultSectionPadding()
                                    .fontStyle(withStyle: .body, fontColor: .white)
                                    .background(.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                            
                            Spacer()
                        }
                    }
                }
            }
            .withDefaultAppPadding()

            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                speak(text: result)
            }
        }
    }
    
    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        utterance.rate = 0.5

        speechSynthesizer = AVSpeechSynthesizer()
        speechSynthesizer?.speak(utterance)
    }
}
