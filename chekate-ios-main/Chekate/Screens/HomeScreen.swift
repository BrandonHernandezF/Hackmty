import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var router: AppRouter

    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 32) {
                    SectionHeader(title: "Has Una Consulta", subtitle: "Dinos tus síntomas")
                    
                    HStack {
                        Spacer()
                        
                        Image("StetoscopeImage").asResizableIcon(size: CGSize(width: 96, height: 96))
                        
                        Spacer()
                    }
                    
                    HStack(alignment: .top, spacing: 24) {
                        AppSection(title: "Como hacer una consulta") {
                            VStack(alignment: .leading, spacing: 12) {
                                
                                HStack(alignment: .center, spacing: 8) {
                                    Image("HandIcon").asResizableIcon(foregroundColor: .gray)

                                    Text("Presiona el botón 'Hacer una Consulta'")
                                        .fontStyle(withStyle: .body, fontColor: .gray)
                                }
                                
                                Rectangle().frame(width: 1, height: 24).padding(.leading, 6).foregroundColor(.gray)

                                HStack(alignment: .center, spacing: 8) {
                                    Image("MicIcon").asResizableIcon(foregroundColor: .gray)

                                    Text("Dicta tus síntomas")
                                        .fontStyle(withStyle: .body, fontColor: .gray)
                                }
                                
                                Rectangle().frame(width: 1, height: 24).padding(.leading, 6).foregroundColor(.gray)
                                
                                HStack(alignment: .center, spacing: 8) {
                                    Image("DocumentIcon").asResizableIcon(foregroundColor: .gray)

                                    Text("Obtén tus resultados y recomendaciones")
                                        .fontStyle(withStyle: .body, fontColor: .gray)
                                }
                                
                                Rectangle().frame(width: 1, height: 24).padding(.leading, 6).foregroundColor(.gray)
                                
                                HStack(alignment: .center, spacing: 8) {
                                    Image("MailIcon").asResizableIcon(foregroundColor: .gray)

                                    Text("Enviaselo a tu doctor")
                                        .fontStyle(withStyle: .body, fontColor: .gray)
                                }
                            }
                            .frame(height: 250)
                            .withDefaultSectionPadding()
                        }

                        AppSection(title: "Detalles de la sucursal") {
                            VStack(alignment: .leading, spacing: 12) {
                                VStack(alignment: .leading) {
                                    Text("Consultorio").fontStyle(withStyle: .subtitle, fontColor: .black)
                                    Text("Farmacias Similares")
                                }

                                VStack(alignment: .leading) {
                                    Text("Dirección").fontStyle(withStyle: .subtitle, fontColor: .black)
                                    Text("Av. Garza Sada")
                                }

                                VStack(alignment: .leading) {
                                    Text("Doctor").fontStyle(withStyle: .subtitle, fontColor: .black)
                                    Text("Sergio Reynosa")
                                }

                                Spacer()
                            }
                            .frame(height: 250)
                            .withDefaultSectionPadding()
                        }
                    }

                    HStack {
                        Spacer()
                        
                        Button(action: { router.append(toScreen: .diagnostic) }) {
                            Text("Hacer Una Consulta")
                                .withDefaultSectionPadding()
                                .fontStyle(withStyle: .body, fontColor: .white)
                                .background(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        
                        Spacer()
                    }
                }
                .withDefaultAppPadding()

                Spacer()
            }
        }
    }
}
