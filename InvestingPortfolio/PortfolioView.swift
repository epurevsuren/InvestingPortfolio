//
//  PortfolioView.swift
//  InvestingPortfolio
//
//  Created by Purevsuren Erdene on 9/5/2024.
//

import SwiftUI

struct PortfolioView: View {
    @State private var newTicker: String = ""
    @ObservedObject var viewModel = PortfolioViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.investments) { investment in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(investment.companyName).font(.headline)
                            Text(investment.ticker).font(.subheadline)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                                                // Conditional formatting based on ticker suffix
                                                if investment.ticker.hasSuffix("=X") {
                                                    Text("\(investment.price, specifier: "%.4f")").bold()  // Four decimal places for forex
                                                } else {
                                                    Text("\(investment.price, specifier: "%.2f")").bold()  // Two decimal places for stocks
                                                }
                                                Text("\(investment.change >= 0 ? "+" : "")\(investment.change, specifier: "%.2f")%")
                                                    .foregroundColor(investment.change >= 0 ? .green : .red)
                                            }
                    }
                }
                .onDelete(perform: viewModel.removeInvestment)

                HStack {
                    TextField("Enter ticker symbol", text: $newTicker)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Add") {
                        viewModel.addInvestment(ticker: newTicker.uppercased())
                        newTicker = ""
                    }
                }
            }
            .navigationTitle("Investment Portfolio")


        }
    }
}

struct InvestmentRow: View {
    var investment: Investment

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(investment.companyName).font(.headline)
                Text(investment.ticker).font(.subheadline)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(investment.price, specifier: "%.2f")").bold()
                Text("\(investment.change >= 0 ? "+" : "")\(investment.change, specifier: "%.2f")").foregroundColor(investment.change >= 0 ? .green : .red)
            }
        }
    }
}

