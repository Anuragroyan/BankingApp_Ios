//
//  AddAccountView.swift
//  Banking
//
//  Created by Dungeon_master on 11/08/25.
//

import SwiftUI

struct AddAccountView: View {
    @EnvironmentObject var store: BankStore
    @Binding var isPresented: Bool

    @State private var name = ""
    @State private var accountNumber = ""
    @State private var showError = false
    @State private var errorText = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account Info")) {
                    TextField("Name", text: $name)
                    TextField("Account Number", text: $accountNumber)
                        .keyboardType(.numbersAndPunctuation)
                }

                Section {
                    Button(action: addAccount) {
                        Text("Create Account")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("New Account")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorText), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func addAccount() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAcc = accountNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { errorText = "Name cannot be empty"; showError = true; return }
        guard !trimmedAcc.isEmpty else { errorText = "Account number cannot be empty"; showError = true; return }

        store.addAccount(name: trimmedName, accountNumber: trimmedAcc)
        isPresented = false
    }
}
