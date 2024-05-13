//
//  LineChartView.swift
//  InvestingPortfolio
//
//  Created by Purevsuren Erdene on 13/5/2024.
//

import SwiftUI
import Charts

struct LineChartView: View {
    @ObservedObject var viewModel: StockChartViewModel
    var identifier: String

    init(identifier: String) {
        self.identifier = identifier
        self.viewModel = StockChartViewModel()
        self.viewModel.loadChartData(for: identifier)
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.lineChartData.isEmpty {
                Text("No chart data available.")
            } else {
                Chart(viewModel.lineChartData, id: \.id) {
                    LineMark(
                        x: .value("Date", $0.date),
                        y: .value("Closing Price", $0.value)
                    )
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: Calendar.Component.month)) {
                        AxisValueLabel(format: .dateTime.month())
                    }
                }
                .chartYAxis {
                    AxisMarks()
                }
            }
        }
        .frame(height: 480)
        .padding()
        .navigationTitle("Chart: \(identifier)")
    }
}
