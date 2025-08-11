//
//  AccountListView.swift
//  Banking
//
//  Created by Dungeon_master on 11/08/25.
//

import SwiftUI

struct AccountListView: View {
    @EnvironmentObject var store: BankStore
    @State private var showAdd = false
    @State private var accountToDelete: AccountModel?
    @State private var showDeleteAllAlert = false

    var body: some View {
        NavigationView {
            List {
                if store.accounts.isEmpty {
                    Section {
                        Text("No accounts yet. Tap + to add an account.")
                            .foregroundColor(.secondary)
                    }
                }

                ForEach(store.accounts) { account in
                    NavigationLink(destination: AccountDetailView(account: account).environmentObject(store)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(account.name)
                                    .font(.headline)
                                Text("A/C: \(account.accountNumber)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(String(format: "₹ %.2f", account.balance))
                                    .font(.headline)
                                Text("Created: \(account.createdAt, formatter: shortDateFormatter)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .onDelete(perform: confirmDelete)
            }
            .navigationTitle("Accounts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAdd = true }) {
                        Image(systemName: "plus")
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button(role: .destructive) {
                            showDeleteAllAlert = true
                        } label: {
                            Label("Reset All Data", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddAccountView(isPresented: $showAdd)
                    .environmentObject(store)
            }
            .alert(item: $accountToDelete) { acct in
                Alert(
                    title: Text("Delete Account"),
                    message: Text("Are you sure you want to delete account \"\(acct.name)\"? This will remove its transactions too."),
                    primaryButton: .destructive(Text("Delete")) {
                        store.removeAccount(id: acct.id)
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert("Delete All Data?", isPresented: $showDeleteAllAlert, actions: {
                Button("Delete", role: .destructive) {
                    store.deleteSavedData()
                }
                Button("Cancel", role: .cancel) {}
            }, message: {
                Text("This will permanently remove all accounts and transactions. A fresh empty file will be created.")
            })
        }
    }

    private func confirmDelete(at offsets: IndexSet) {
        guard let idx = offsets.first else { return }
        accountToDelete = store.accounts[idx]
    }
}

private let shortDateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateStyle = .short
    f.timeStyle = .short
    return f
}()
