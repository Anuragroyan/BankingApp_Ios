//
//  BankingApp.swift
//  Banking
//
//  Created by Dungeon_master on 11/08/25.
//

import SwiftUI

@main
struct BankingApp: App {
    @StateObject private var store = BankStore()

    var body: some Scene {
        WindowGroup {
            AccountListView()
                .environmentObject(store)
        }
    }
}
