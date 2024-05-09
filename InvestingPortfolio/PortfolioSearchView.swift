//
//  PortfolioSearchView.swift
//  InvestingPortfolio
//
//  Created by Purevsuren Erdene on 9/5/2024.
//
import SwiftUI

struct PortfolioSearchView: View {
    @ObservedObject var viewModel: PortfolioViewModel
    @State private var searchTerm: String = ""

    var body: some View {
        VStack {
            TextField("Search ticker symbols or names", text: $searchTerm)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Search") {
                viewModel.addInvestment(ticker: searchTerm.uppercased())
                searchTerm = ""  // Clear the search term after adding
            }

            List {
                ForEach(viewModel.investments) { investment in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(investment.companyName)
                            Text(investment.ticker).font(.caption)
                        }
                        Spacer()
                        Text("\(investment.price, specifier: "%.2f")").bold()
                    }
                }
            }
        }
        .navigationTitle("Search and Add Stocks")
    }
}
