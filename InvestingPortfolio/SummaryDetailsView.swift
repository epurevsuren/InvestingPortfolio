//
//  SummaryDetailsView.swift
//  InvestingPortfolio
//
//  Created by Purevsuren Erdene on 13/5/2024.
//

import SwiftUI
import SwiftYFinance

struct SummaryDetailsView: View {
    var identifier: String
    @State private var identifierSummary: IdentifierSummary?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let summary = identifierSummary {
                    Text("Overview")
                        .font(.title)

                    if let profile = summary.summaryProfile {
                        VStack(alignment: .leading) {
                            Text("Company Name: \(profile.name)")
                            Text("Sector: \(profile.sector)")
                            Text("Industry: \(profile.industry)")
                            Text("Full Address: \(profile.address)")
                        }
                    }

                    if let price = summary.price {
                        VStack(alignment: .leading) {
                            Text("Current Price: \(price.regularMarketPrice)")
                            Text("Previous Close: \(price.previousClose)")
                        }
                    }

                    if let details = summary.summaryDetail {
                        VStack(alignment: .leading) {
                            Text("Market Cap: \(details.marketCap)")
                            Text("PE Ratio: \(details.peRatio)")
                        }
                    }

                    if let recommendation = summary.recommendationTrend {
                        VStack(alignment: .leading) {
                            Text("Recommendation: \(recommendation.trend)")
                        }
                    }

                    if let events = summary.calendarEvents {
                        VStack(alignment: .leading) {
                            Text("Upcoming Events: \(events.earningsDate)")
                        }
                    }
                } else {
                    Text("Loading or no data available.")
                }
            }
            .padding()
        }
        .onAppear {
            fetchSummaryData()
        }
        .navigationTitle("Details for \(identifier)")
        .navigationBarTitleDisplayMode(.inline)
    }

    //SwiftYFinance could not implement Summary Data fully, resulting in errors during my attempt...

    private func fetchSummaryData() {
        SwiftYFinance.summaryDataBy(identifier: identifier, selection: .supported) { data, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching data: \(error.localizedDescription)")
                    self.identifierSummary = nil // Properly handle the error by setting state to nil
                } else if let data = data {
                    //self.identifierSummary = data // Direct assignment without casting
                    print(data)
                } else {
                    self.identifierSummary = nil // Handle nil data properly
                }
            }
        }
    }



}

// Dummy structs representing the data model for demonstration purposes.
// Implement your actual data model according to the API responses.

struct IdentifierSummary {
    var recommendationTrend: RecommendationTrend?
    var summaryProfile: SummaryProfile?
    var quoteType: QuoteType?
    var price: Price?
    var indexTrend: IndexTrend?
    var calendarEvents: CalendarEvents?
    var summaryDetail: SummaryDetail?
    var dataStorage: JSON?
}

struct RecommendationTrend {
    var trend: String
}

struct SummaryProfile {
    var name: String
    var sector: String
    var industry: String
    var address: String
}

struct Price {
    var regularMarketPrice: Double
    var previousClose: Double
}

struct SummaryDetail {
    var marketCap: Double
    var peRatio: Double
}

struct CalendarEvents {
    var earningsDate: String
}

struct QuoteType {
    var type: String
}

struct IndexTrend {
    var trend: String
}

struct JSON: Codable {}

// Dummy JSON conforming
