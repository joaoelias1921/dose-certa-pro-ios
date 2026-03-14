//
//  ContentView.swift
//  dosecertapro
//
//  Created by João Elias Cândido Reis on 14/03/26.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var isLogged = false

    var body: some View {
        Group {
            if isLogged {
                MyPrescriptionsView()
            } else {
                WelcomeView()
            }
        }
        .onAppear {
            Auth.auth().addStateDidChangeListener { _, user in
                withAnimation(.easeInOut) {
                    self.isLogged = (user != nil)
                }
            }
        }
    }
}

