//
//  SingUpView.swift
//  SwiftUIForm
//
//  Created by Marco on 25/4/24.
//

import SwiftUI
struct SingUpView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var showingSheet:Bool = false
   
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Email", text: $emailAddress)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $password)
                }
                Section {
                    Button(action: {
            
                        authModel.signUp(emailAddress: emailAddress,
                             password: password)
                    }) {
                        Text("Sign Up").bold()
                    }
        }
                Section(header: Text("If you already have an account:")) {
                    Button(action: {
                        authModel.signIn(emailAddress: emailAddress,
                                         password: password)
                    }) {
                        Text("Sign In")
                    }
            }
                
                    Button(action: {
                        authModel.signInWithGoogle()
                    }) {
                        HStack{
                            Image("logo")
                                .scaleEffect(0.5)
                            Text("Utiza Google").bold()
                    }
            }
                
        }   .navigationTitle("Welcome")
                .toolbar {
                    ToolbarItemGroup(placement:
                            .cancellationAction) {

                                Button {
                                    showingSheet.toggle()
                                } label: {
                                    Text("Forgot password?")
                                }
                                .sheet(isPresented: $showingSheet) {
                                    ForgotPasswordView()
                                }
                            }
                }
        }
    }
}
struct SignUpView_Previews: PreviewProvider{
    static var previews: some View {
        SingUpView()
    }
}
