//
//  PortfolioView.swift
//  InvestingPortfolio
//
//  Created by Purevsuren Erdene on 9/5/2024.
//

import SwiftUI

struct PortfolioView: View {
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
                            Text("\(investment.price, specifier: "%.2f")").bold()
                            Text("\(investment.change >= 0 ? "+" : "")\(investment.change, specifier: "%.2f")").foregroundColor(investment.change >= 0 ? .green : .red)
                        }
                    }
                }
                .onDelete(perform: viewModel.removeInvestment)
            }
            .navigationTitle("Investment Portfolio")
            .toolbar {
                Button("Add Investment") {
                    // Add logic to present add view or fetch from API
                }
            }
        }
    }
}


#Preview {
    PortfolioView()
}
