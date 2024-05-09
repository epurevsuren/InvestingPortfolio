//
//  Investment.swift
//  InvestingPortfolio
//
//  Created by Purevsuren Erdene on 9/5/2024.
//

import Foundation
struct Investment: Identifiable, Codable {
    var id: UUID = UUID()
    var ticker: String
    var companyName: String
    var price: Float
    var previousClose: Float
    var change: Double // Today's change in price
}
