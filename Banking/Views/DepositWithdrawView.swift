//
//  DepositWithdrawView.swift
//  Banking
//
//  Created by Dungeon_master on 11/08/25.
//

import SwiftUI

struct DepositWithdrawView: View {
    @EnvironmentObject var store: BankStore
    @Environment(\.presentationMode) var presentationMode

    var account: AccountModel
    var isDeposit: Bool

    @State private var amountText = ""
    @State private var note = ""
    @State private var showError = false
    @State private var errorText = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(isDeposit ? "Deposit Amount" : "Withdraw Amount")) {
                    TextField("Amount", text: $amountText)
                        .keyboardType(.decimalPad)
                    TextField("Note (optional)", text: $note)
                }

                Section {
                    Button(action: perform) {
                        Text(isDeposit ? "Deposit" : "Withdraw")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle(isDeposit ? "Deposit" : "Withdraw")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorText), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func perform() {
        guard let amount = Double(amountText.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            errorText = "Enter a valid numeric amount"
            showError = true
            return
        }
        if amount <= 0 {
            errorText = "Amount must be greater than zero"
            showError = true
            return
        }

        let success: Bool
        if isDeposit {
            success = store.deposit(accountId: account.id, amount: amount, note: note)
        } else {
            success = store.withdraw(accountId: account.id, amount: amount, note: note)
        }

        if success {
            presentationMode.wrappedValue.dismiss()
        } else {
            errorText = isDeposit ? "Deposit failed" : "Insufficient funds or error"
            showError = true
        }
    }
}
