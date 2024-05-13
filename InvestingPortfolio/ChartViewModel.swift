//
//  ChartViewModel.swift
//  InvestingPortfolio
//
//  Created by Purevsuren Erdene on 13/5/2024.
//

import Foundation
import Combine
import SwiftUI
import SwiftYFinance

class StockChartViewModel: ObservableObject {
    @Published var lineChartData: [LineData] = []
    @Published var isLoading = false

    func loadChartData(for identifier: String) {
        isLoading = true
        let startDate = Calendar.current.date(byAdding: .month, value: -6, to: Date())!
        let endDate = Date()

        SwiftYFinance.chartDataBy(
            identifier: identifier,
            start: startDate,
            end: endDate,
            interval: .oneday) { [weak self] data, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let error = error {
                        print("Error fetching chart data: \(error.localizedDescription)")
                    } else if let data = data, !data.isEmpty {
                        self?.lineChartData = data.compactMap { stockData in
                            guard let close = stockData.close, let date = stockData.date else { return nil }
                            return LineData(date: date, value: close)
                        }
                        print("Chart data loaded successfully.")
                    } else {
                        print("No data received or data is empty")
                    }
                }
        }
    }
}


struct StockChartData {
    var date: Date?
    var volume: Int?
    var open: Float?
    var close: Float?
    var adjclose: Float?
    var low: Float?
    var high: Float?
}
