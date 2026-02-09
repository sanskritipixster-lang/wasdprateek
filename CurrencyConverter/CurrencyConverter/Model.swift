//
//  Model.swift
//  CurrencyConverter
//
//  Created by Prateek Kumar Rai on 09/02/26.
//

import Foundation
import SwiftData

@Model
final class Transaction {
    var title: String
    var date: Date
    var amount: Double
    var typeString: String
    var currency: String
    var inrAmount: Double

    init(amount: Double, type: TransactionType, currency: String, inrAmount: Double) {
        self.title = "ID\(UUID().uuidString.prefix(7).uppercased())"
        self.date = Date()
        self.amount = amount
        self.typeString = type.rawValue
        self.currency = currency
        self.inrAmount = inrAmount
    }

    var type: TransactionType {
        TransactionType(rawValue: typeString) ?? .deposit
    }
}

struct ExchangeRateResponse: Decodable {
    let conversion_rate: Double
}

enum TransactionType: String, Codable {
    case deposit
    case withdraw
}


