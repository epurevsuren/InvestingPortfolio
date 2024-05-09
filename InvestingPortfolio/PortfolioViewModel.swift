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
    @Published var searchResults: [YFQuoteSearchResult] = []
    private var cancellables: Set<AnyCancellable> = []

    init() {
        loadInvestments()
    }

    func loadInvestments() {
        let initialTickers = ["AMC", "ACHR", "SPCE", "QS", "QSI", "AUDUSD=X"]  // Define your initial list of tickers
                for ticker in initialTickers {
                    addInvestment(ticker: ticker)
                }
    }

    func searchStocks(searchTerm: String) {
            SwiftYFinance.fetchSearchDataBy(searchTerm: searchTerm, quotesCount: 20) { [weak self] data, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error fetching search data: \(error.localizedDescription)")
                    } else if let results = data {
                        self?.searchResults = results
                        print("Fetched \(results.count) results.")
                    }
                }
            }
        }

    // Function to add an investment from the ticker symbol
        func addInvestment(ticker: String) {
            fetchSearchData(ticker: ticker)
        }

        // Fetch initial stock data including company name
        private func fetchSearchData(ticker: String) {
            SwiftYFinance.fetchSearchDataBy(searchTerm: ticker, quotesCount: 1) { [weak self] data, error in
                DispatchQueue.main.async {
                    if let results = data, let firstResult = results.first {
                        self?.fetchRecentData(ticker: ticker, companyName: firstResult.longname ?? "Unknown")
                    } else if let error = error {
                        print("Error fetching search data: \(error.localizedDescription)")
                    }
                }
            }
        }

        // Fetch recent market data to get price and previous close
        private func fetchRecentData(ticker: String, companyName: String) {
            SwiftYFinance.recentDataBy(identifier: ticker) { [weak self] data, error in
                DispatchQueue.main.async {
                    if let data = data {
                        let marketPrice = Float(data.regularMarketPrice ?? 0)
                        let previousClose = Float(data.previousClose ?? 0)
                        let change = previousClose != 0 ? Double((marketPrice - previousClose) / previousClose * 100) : 0.0

                        let newInvestment = Investment(
                            ticker: ticker,
                            companyName: companyName,
                            price: marketPrice,
                            previousClose: previousClose,
                            change: change
                        )
                        self?.investments.append(newInvestment)
                    } else if let error = error {
                        print("Error fetching recent market data: \(error.localizedDescription)")
                    }
                }
            }
        }

    // Fetch stock data and calculate change
        private func fetchStockData(ticker: String, companyName: String) {
            SwiftYFinance.recentDataBy(identifier: ticker) { [weak self] data, error in
                DispatchQueue.main.async {
                    if let data = data {
                        let marketPrice = data.regularMarketPrice ?? 0.0
                        let previousClose = data.previousClose ?? 0.0
                        let change = ((marketPrice - previousClose) / previousClose) * 100  // Calculate percentage change

                        let newInvestment = Investment(
                            ticker: ticker,
                            companyName: companyName,
                            price: marketPrice,
                            previousClose: previousClose,
                            change: Double(change)
                        )
                        self?.investments.append(newInvestment)
                    } else if let error = error {
                        print("Error fetching stock data: \(error.localizedDescription)")
                    }
                }
            }
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
