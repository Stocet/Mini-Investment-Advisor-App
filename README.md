# Mini Investment Advisor

[![Flutter Version](https://img.shields.io/badge/Flutter-3.7.0-blue?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.0.0-blue?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A Flutter application designed to help users create a simple one-year investment plan. The app provides a recommended asset allocation strategy based on the user's initial capital, financial goal, and investor type (active or passive).

## Features

- **Investment Plan Generation:** Users can input their initial capital and a financial goal.
- **Investor Profile Selection:** Choose between "Active" and "Passive" investor profiles, each with a different risk tolerance and asset allocation.
- **Projected Returns:** The app calculates and displays the projected returns for each asset and the total projected return after one year.
- **Goal Status:** See at a glance whether the investment goal was met or if there is a shortfall.
- **Visualizations:** A simple pie chart provides a visual breakdown of the asset allocation.

## Architecture

This application is built with a clean, layered architecture to ensure separation of concerns and maintainability:

- **Presentation Layer:** The user interface, widgets, and state management logic using the `flutter_bloc` package.
- **Domain Layer:** Core business logic, including the `InvestmentPlan` entity and the `CreateInvestmentPlanUseCase`.
- **Data Layer:** Handles data fetching from a simulated data source (`AssetDataSource`) and abstracts it away with the `InvestmentRepository`.

## How to Run

To get started with the app, follow these steps:

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/mini-investment-advisor.git
   ```

2. Navigate to the project directory:

   ```bash
   cd mini-investment-advisor
   ```

3. Install dependencies: This project uses `flutter_bloc`. Ensure it's listed in your `pubspec.yaml` and run:

   ```bash
   flutter pub get
   ```

4. Run the app:

   ```bash
   flutter run
   ```

The app will launch on your connected device or emulator.

## Screenshot

![Home Page](/assets/screenshot/home_page.png)
![Investment Advisory](/assets/screenshot/investement_advisory.png)
![Result](/assets/screenshot/result.png)

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a Pull Request.

Please make sure your code follows the existing style and passes all tests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
