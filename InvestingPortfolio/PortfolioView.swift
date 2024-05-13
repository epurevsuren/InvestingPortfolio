//
//  PortfolioView.swift
//  InvestingPortfolio
//
//  Created by Purevsuren Erdene on 9/5/2024.
//
import Combine
import SwiftUI

struct PortfolioView: View {
    @State private var newTicker: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @ObservedObject var viewModel = PortfolioViewModel()
    @State private var selectedTicker: String?  // To track the selected ticker for navigation
    @State private var isNavigationActive: Bool = false  // Boolean state to control navigation

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.investments, id: \.ticker) { investment in
                    Button(action: {
                        // Set the selected ticker and trigger navigation
                        self.selectedTicker = investment.ticker
                        self.isNavigationActive = true  // Activate navigation
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(investment.ticker).font(.headline)
                                    .foregroundStyle(.black)
                                Text(investment.companyName).font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                if investment.ticker.hasSuffix("=X") {
                                    Text("\(investment.price, specifier: "%.4f")").bold()  // Four decimal places for forex
                                } else {
                                    Text("\(investment.price, specifier: "%.2f")").bold()  // Two decimal places for others
                                        .foregroundColor(.black)
                                }
                                Text("\(investment.change >= 0 ? "+" : "")\(investment.change, specifier: "%.2f")%")
                                    .foregroundColor(investment.change >= 0 ? .green : .red)
                            }
                            Image(systemName: "chevron.right")  // System image for disclosure indicator
                                .foregroundColor(.gray)  // Optional: set the color to match your UI
                        }
                    }
                }
                .onDelete(perform: viewModel.removeInvestment)

                HStack {
                    TextField("Enter ticker symbol", text: $newTicker)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($isTextFieldFocused)
                        .autocapitalization(.allCharacters)
                        .disableAutocorrection(true)
                        .onReceive(Just(isTextFieldFocused), perform: { focused in
                            if focused {
                                viewModel.stopTimer()
                            }
                        })
                    Button("Add") {
                        viewModel.addInvestment(ticker: newTicker.uppercased())
                        newTicker = ""
                        isTextFieldFocused = false  // Explicitly defocus the text field
                    }
                }
            }
            .navigationTitle("Investment Portfolio")
            .background(
                NavigationLink(destination: LineChartView(identifier: selectedTicker ?? "Select a ticker"), isActive: $isNavigationActive) {
                    EmptyView()
                }
            )
            .onAppear {
                viewModel.startTimer()
            }
            .onDisappear {
                viewModel.stopTimer()
            }
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
