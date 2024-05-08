//
//  PortfolioViewModel.swift
//  InvestingPortfolio
//
//  Created by Purevsuren Erdene on 9/5/2024.
//

import Foundation
import Combine
import SwiftUI

class PortfolioViewModel: ObservableObject {
    @Published var investments: [Investment] = []
    private var cancellables: Set<AnyCancellable> = []

    init() {
        loadInvestments()
    }

    func loadInvestments() {
        // Load from UserDefaults or CoreData
        // Simulated data here
        investments = [
            Investment(ticker: "AAPL", companyName: "Apple Inc.", price: 170.68, change: 2.15),
            Investment(ticker: "GOOGL", companyName: "Alphabet Inc.", price: 120.34, change: 1.20),
            Investment(ticker: "EURUSD", companyName: "Euro to USD", price: 1.0850, change: 0.0002)
        ]
    }

    func addInvestment(ticker: String, companyName: String) {
        // Implement API call to fetch real-time data and add to the portfolio
        let newInvestment = Investment(ticker: ticker, companyName: companyName, price: 100, change: 0) // Placeholder for API data
        investments.append(newInvestment)
        saveInvestments()
    }

    func removeInvestment(at offsets: IndexSet) {
        investments.remove(atOffsets: offsets)
        saveInvestments()
    }

    func saveInvestments() {
        // Save to UserDefaults or CoreData
    }

    func fetchRealTimeData() {
        // Use Combine to fetch data from Yahoo Finance API
        // This is a placeholder for the actual API call logic
    }
}
