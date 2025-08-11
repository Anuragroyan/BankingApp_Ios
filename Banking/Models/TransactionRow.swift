//
//  TransactionRow.swift
//  Banking
//
//  Created by Dungeon_master on 11/08/25.
//

import SwiftUI

struct TransactionRow: View {
    var txn: TransactionModel

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(txn.type.rawValue)
                    .font(.headline)
                if let note = txn.note, !note.isEmpty {
                    Text(note).font(.caption).foregroundColor(.secondary)
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text((txn.type == .deposit ? "+" : "-") + String(format: "₹ %.2f", txn.amount))
                    .bold()
                Text(txn.date, formatter: shortDateFormatter)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}

private let shortDateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateStyle = .short
    f.timeStyle = .short
    return f
}()
