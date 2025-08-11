//
//  BankStore.swift
//  Banking
//
//  Created by Dungeon_master on 11/08/25.
//

import Foundation
import Combine

final class BankStore: ObservableObject {
    @Published private(set) var accounts: [AccountModel] = []
    @Published private(set) var transactions: [TransactionModel] = []

    private let fileName = "bankdata.json"
    private var fileURL: URL {
        getDocumentsDirectory().appendingPathComponent(fileName)
    }

    private let queue = DispatchQueue(label: "bankstore.save")

    init() {
        loadFromDisk()
    }

    // MARK: - Public methods

    func addAccount(name: String, accountNumber: String) {
        let acct = AccountModel(name: name.trimmingCharacters(in: .whitespacesAndNewlines), accountNumber: accountNumber.trimmingCharacters(in: .whitespacesAndNewlines))
        accounts.append(acct)
        saveToDisk()
    }

    func removeAccount(id: UUID) {
        accounts.removeAll { $0.id == id }
        // also remove transactions
        transactions.removeAll { $0.accountId == id }
        saveToDisk()
    }

    func deposit(accountId: UUID, amount: Double, note: String? = nil) -> Bool {
        guard amount > 0 else { return false }
        guard let idx = accounts.firstIndex(where: { $0.id == accountId }) else { return false }
        accounts[idx].balance += amount
        let txn = TransactionModel(accountId: accountId, type: .deposit, amount: amount, note: note)
        transactions.append(txn)
        saveToDisk()
        return true
    }

    func withdraw(accountId: UUID, amount: Double, note: String? = nil) -> Bool {
        guard amount > 0 else { return false }
        guard let idx = accounts.firstIndex(where: { $0.id == accountId }) else { return false }
        if accounts[idx].balance < amount { return false } // insufficient funds
        accounts[idx].balance -= amount
        let txn = TransactionModel(accountId: accountId, type: .withdraw, amount: amount, note: note)
        transactions.append(txn)
        saveToDisk()
        return true
    }

    func transactionsForAccount(_ id: UUID) -> [TransactionModel] {
        transactions.filter { $0.accountId == id }.sorted { $0.date > $1.date }
    }

    // MARK: - Persistence
    private struct SavePayload: Codable {
        var accounts: [AccountModel]
        var transactions: [TransactionModel]
    }

    func saveToDisk() {
        let payload = SavePayload(accounts: accounts, transactions: transactions)
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                let data = try encoder.encode(payload)
                try data.write(to: self.fileURL, options: [.atomic])
                DispatchQueue.main.async {
                    // optional: keep UI in sync
                }
                print("Saved to \(self.fileURL.path)")
            } catch {
                print("Failed to save bank data: \(error)")
            }
        }
    }

    func loadFromDisk() {
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                let data = try Data(contentsOf: self.fileURL)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let payload = try decoder.decode(SavePayload.self, from: data)
                DispatchQueue.main.async {
                    self.accounts = payload.accounts
                    self.transactions = payload.transactions
                }
                print("Loaded from \(self.fileURL.path)")
            } catch {
                DispatchQueue.main.async {
                    self.accounts = []
                    self.transactions = []
                }
                print("No saved data or failed load: \(error)")
            }
        }
    }

    /// Delete the JSON file from disk, clear in-memory data, and recreate an empty JSON file.
    func deleteSavedData() {
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
                print("Deleted file at \(fileURL.path)")
            } catch {
                print("Failed to delete file: \(error)")
            }
        } else {
            print("No file to delete at \(fileURL.path).")
        }

        // Clear in-memory data
        DispatchQueue.main.async {
            self.accounts.removeAll()
            self.transactions.removeAll()
        }

        // Recreate an empty JSON file so the app has a consistent file to work with
        saveToDisk()
    }

    // MARK: - Helpers
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
