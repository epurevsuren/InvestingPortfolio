//
//  InvestingPortfolioApp.swift
//  InvestingPortfolio
//
//  Created by Purevsuren Erdene on 9/5/2024.
//

import SwiftUI

@main
struct InvestingPortfolioApp: App {
    // Create a ViewModel instance
    @StateObject var viewModel = PortfolioViewModel()

    var body: some Scene {
        WindowGroup {
            // Inject the ViewModel instance into the PortfolioView
            PortfolioView(viewModel: viewModel)
        }
    }
}
