//
//  PortfolioViewModel.swift
//  InvestingPortfolio
//
//  Created by Purevsuren Erdene on 9/5/2024.
//

import Foundation
import Combine
import SwiftUI
import SwiftYFinance

class PortfolioViewModel: ObservableObject {
    @Published var investments: [Investment] = []
    @Published var companyNames: [String: String] = [:] // Dictionary to store asset names
    @Published var tickers: [String] = [] // List to store tickers

    private var dataRefreshTimer: AnyCancellable?

    init() {
        loadInitialTickers()
        startTimer()
    }

    deinit {
        stopTimer()
    }

    func loadInitialTickers() {
        // Load tickers from UserDefaults or use a default list
        tickers = UserDefaults.standard.array(forKey: "Watchlist") as? [String] ?? ["AAPL", "AUDUSD=X", "BTC-USD"]
        tickers.forEach { ticker in
            fetchSearchData(ticker: ticker) // Fetch ticker names for each ticker
        }
    }

    func addInvestment(ticker: String) {
        if !tickers.contains(ticker) {
            tickers.append(ticker)
            fetchSearchData(ticker: ticker) // Fetch ticker name and create investment
            saveTickers()
        }
    }

    private func fetchSearchData(ticker: String) {
        SwiftYFinance.fetchSearchDataBy(searchTerm: ticker, quotesCount: 1) { [weak self] data, error in
            DispatchQueue.main.async {
                if let results = data, let firstResult = results.first {
                    self?.companyNames[ticker] = firstResult.longname ?? "Unknown"
                    self?.fetchRecentData(ticker: ticker) // Proceed to fetch recent data
                } else {
                    print("Error fetching search data: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }

    private func fetchRecentData(ticker: String) {
        SwiftYFinance.recentDataBy(identifier: ticker) { [weak self] data, error in
            DispatchQueue.main.async {
                if let self = self, let data = data {
                    let newInvestmentData = Investment(
                        ticker: ticker,
                        companyName: self.companyNames[ticker] ?? "Unknown",
                        price: Float(data.regularMarketPrice ?? 0),
                        previousClose: Float(data.previousClose ?? 0),
                        change: Float(data.previousClose ?? 0) != 0 ? Double((Float(data.regularMarketPrice ?? 0) - Float(data.previousClose ?? 0)) / Float(data.previousClose ?? 0) * 100) : 0.0
                    )
                    self.createOrUpdateInvestment(newInvestmentData)
                } else {
                    print("Error fetching recent market data: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }

    private func createOrUpdateInvestment(_ newInvestment: Investment) {
        if let index = investments.firstIndex(where: { $0.ticker == newInvestment.ticker }) {
            // Update existing investment
            investments[index] = newInvestment
        } else {
            // Create new investment
            investments.append(newInvestment)
        }
    }

    func setupDataRefreshTimer() {
            dataRefreshTimer = Timer.publish(every: 15, on: .main, in: .common).autoconnect() // Refresh interval 15 seconds
                .sink(receiveValue: { [weak self] _ in
                    self?.refreshInvestments()
                })
    }

    func stopTimer() {
        dataRefreshTimer?.cancel()
        dataRefreshTimer = nil  // Clear the existing timer reference
        print("Timer Stopped!")
    }

    func startTimer() {
        if dataRefreshTimer == nil {  // Only start a new timer if there isn't one already
            setupDataRefreshTimer()
            print("Timer Started!")
        }
    }

    func refreshInvestments() {
        tickers.forEach { ticker in
            fetchRecentData(ticker: ticker)
        }
    }

    func removeInvestment(at offsets: IndexSet) {
        offsets.map { investments[$0].ticker }.forEach { ticker in
            tickers.removeAll(where: { $0 == ticker })
            companyNames.removeValue(forKey: ticker)
        }
        investments.remove(atOffsets: offsets)
        saveTickers()
    }

    func saveTickers() {
        UserDefaults.standard.set(tickers, forKey: "Watchlist")
    }
}
