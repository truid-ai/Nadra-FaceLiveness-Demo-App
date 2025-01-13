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
    @State var response: TruID.TruIDResult?
    @State var error: String? = nil
    
    @State private var isReportScreenEnabled = true
    @State private var isHelpScreenEnabled = true
    
    var body: some View {
        if isSDKRunning {
            TruidMain(
                face_liveness: true,
                enableHelpScreens: isHelpScreenEnabled,
                enableReportScreen: isReportScreenEnabled,
                themeColor: Color.blue
            ) { responseModel in
                self.response = responseModel
                isSDKRunning = false
                self.error = nil
            } failure: { failure in
                print(failure)
                isSDKRunning = false
                self.error = failure.message
            }

        } else {
            VStack {
                Text("Face Liveness Demo App")
                    .font(.title)
                    .padding(.bottom, 16)
                
                Spacer()

                if let response {
                    VStack {
                        if let response = self.response {
                            Image(uiImage: response.image)
                                .resizable()
                                .scaledToFit()
                                .padding(4)
                        }
                        
                        if let error {
                            Text("Error Occurred:")
                            Text(error)
                        }
                    }
                }
                
                Spacer()
                
                CustomToggle(text: "Enable Help Screen", isOn: $isHelpScreenEnabled)
                CustomToggle(text: "Enable Report Screen", isOn: $isReportScreenEnabled)
                
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

struct CustomToggle: View {
    let text: String
    @Binding var isOn: Bool
    
    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            HStack {
                Text(text)
                    .font(.callout)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 8)
            .background(isOn ? Color(UIColor.systemBlue) : Color(UIColor.systemBackground))
            .background(in: RoundedRectangle(cornerRadius: 25))
            .foregroundStyle(isOn ? .white : Color(UIColor.label))
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(.gray, lineWidth: isOn ? 0 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}
