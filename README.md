**Investing Portfolio App**

Introduction
The Investing Portfolio App is designed for individuals interested in the financial markets, particularly those above 18, keen on making informed investment decisions. This application helps users track financial earnings, reports, news, and economic events to enhance their investing strategies.

Target Audience
The primary audience for this app includes new and experienced investors looking for a streamlined and intuitive tool to manage their investment portfolios and make data-driven decisions.

Problem Solved
Investors often need help accessing consolidated and real-time financial data to make quick investment decisions. This app addresses this issue by providing a user-friendly platform that integrates real-time financial data, analytics, and news to help users make informed decisions without switching between multiple tools.

Comparison with Other Solutions
Unlike other investment tools that may require navigating complex interfaces or dealing with delayed data, our app simplifies the user experience by offering:
- Real-time financial data and market signals from Yahoo Finance.
- Integrated views of financial reports, news, and economic events.
- Custom API integrations that provide tailored financial insights.

How the App Works
To use the app:
1. Add a Ticker: Users start by adding a stock or forex ticker symbol to their portfolio.
2. View Data: The app displays real-time data and potential investment outcomes.
3. Make Decisions: Users can make investment decisions directly within the app based on the provided data and signals.

Technologies Used
- Yahoo Finance API: This is used to fetch real-time stock prices and market data.
- **Package dependency**:
1. File → Add Package Dependency.
2. URL: `https://github.com/alexdremov/SwiftYFinance`
3. Select Target, then Resolve.
4. Use `import SwiftYFinance` in your Swift files.

- Custom APIs: Developed to handle specific financial calculations and provide personalized alerts.

Challenges and Solutions
Data Management: The most significant challenge was designing efficient data structures and algorithms to manage and process financial data effectively. This was addressed by:
- Implementing optimized data models that reflect real-world financial elements.
- Using advanced programming techniques to ensure data integrity and responsiveness.

Achieving MVP with Iterative Design
Our development process followed the Software Development Life Cycle (SDLC) with iterative planning and feedback loops, allowing us to refine features continuously and ensure the app meets user needs effectively.

Code Quality (Project GitHub URL: `https://github.com/epurevsuren/InvestingPortfolio`)

Data Modeling
- Our data models are designed to reflect the financial market's structures accurately, enabling intuitive interaction with financial data.

Immutable Data and Idempotent Methods
- We use the type system rigorously to prevent incorrect code from being written, ensuring our methods are idempotent.

Functional Separation
- The app's architecture breaks down the problem into distinct parts, allowing for focused development and maintenance.

Loose Coupling
- Components are developed to operate independently, facilitating more accessible updates and modifications.

Extensibility
- The design allows for quickly adding or modifying features, where new functionalities can often be added by updating data structures rather than extensive coding.

Error Handling
- Comprehensive error detection and user input validation are implemented to guide users and prevent execution errors.

