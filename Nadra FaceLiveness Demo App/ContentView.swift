//
//  ContentView.swift
//  Nadra FaceLiveness Demo App
//
//  Created by truID on 16/11/2024.
//

import SwiftUI
import TruID

struct ContentView: View {
    @State var isSDKRunning = false
    @State var response: TruID.ResponseModel?
    
    @State var isReportScreenEnabled = true
    @State var isHelpScreenEnabled = true
    
    var body: some View {
        if isSDKRunning {
            TruidMain(face_liveness: true, enableHelpScreens: isReportScreenEnabled, enableReportScreen: isHelpScreenEnabled, themeColor: Color.orange) { responseModel in
                response = responseModel
                isSDKRunning = false
            } failure: { failure in
                print(failure)
                isSDKRunning = false
            }

        } else {
            VStack {
                Text("Face Liveness Demo App")
                    .font(.title)
                    .padding(.bottom, 16)

                if let response {
                    if let result = response.result {
                        HStack {
                            Text("Liveness Passed:")
                            Spacer()
                            Image(systemName: result.status != "error" ? "checkmark.circle.fill" : "multiply.circle.fill")
                        }
                    }
                    
                    if let icao = response.icaoStatus {
                        HStack {
                            Text("ICAO Passed:")
                            Spacer()
                            Image(systemName: icao != "error" ? "checkmark.circle.fill" : "multiply.circle.fill")
                        }
                    }
                    
                    if response.status != 200 {
                        Text("Something is wrong at the server.")
                    }
                }
                
                Spacer()
                
                Button {
                    isSDKRunning = true
                } label: {
                    Label("Verify Liveness", systemImage: "shield.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
    }
}
