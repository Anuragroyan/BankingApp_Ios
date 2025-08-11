//
//  AccountDetailView.swift
//  Banking
//
//  Created by Dungeon_master on 11/08/25.
//

import SwiftUI

struct AccountDetailView: View {
    @EnvironmentObject var store: BankStore
    var account: AccountModel

    @State private var showDepositWithdraw = false
    @State private var isDeposit = true

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(account.name).font(.title2).bold()
                    Text("A/C: \(account.accountNumber)").font(.caption).foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(String(format: "₹ %.2f", store.accounts.first(where: { $0.id == account.id })?.balance ?? account.balance))
                        .font(.title2)
                        .bold()
                    Text("Balance").font(.caption).foregroundColor(.secondary)
                }
            }
            .padding()

            HStack(spacing: 16) {
                Button(action: { isDeposit = true; showDepositWithdraw = true }) {
                    HStack { Image(systemName: "arrow.down.circle"); Text("Deposit") }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke())
                }

                Button(action: { isDeposit = false; showDepositWithdraw = true }) {
                    HStack { Image(systemName: "arrow.up.circle"); Text("Withdraw") }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke())
                }
            }
            .padding(.horizontal)

            List {
                Section(header: Text("Transactions")) {
                    let txns = store.transactionsForAccount(account.id)
                    if txns.isEmpty {
                        Text("No transactions yet.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(txns) { txn in
                            TransactionRow(txn: txn)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showDepositWithdraw) {
            DepositWithdrawView(account: account, isDeposit: isDeposit)
                .environmentObject(store)
        }
    }
}
