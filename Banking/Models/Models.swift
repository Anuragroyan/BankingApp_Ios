//
//  Models.swift
//  Banking
//
//  Created by Dungeon_master on 11/08/25.
//

import Foundation

enum TransactionType: String, Codable {
    case deposit = "Deposit"
    case withdraw = "Withdraw"
}

struct TransactionModel: Identifiable, Codable {
    let id: UUID
    let accountId: UUID
    let type: TransactionType
    let amount: Double
    let date: Date
    var note: String?

    init(id: UUID = UUID(), accountId: UUID, type: TransactionType, amount: Double, date: Date = Date(), note: String? = nil) {
        self.id = id
        self.accountId = accountId
        self.type = type
        self.amount = amount
        self.date = date
        self.note = note
    }
}

struct AccountModel: Identifiable, Codable {
    let id: UUID
    var name: String
    var accountNumber: String
    var balance: Double
    var createdAt: Date

    init(id: UUID = UUID(), name: String, accountNumber: String, balance: Double = 0.0, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.accountNumber = accountNumber
        self.balance = balance
        self.createdAt = createdAt
    }
}
