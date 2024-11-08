# Currency Exchange Rates App

## Overview

The Currency Exchange Rates app allows users to view real-time exchange rates for different currencies. It offers the functionality to mark specific rates as favorites, view those favorites, and access previously fetched rates in offline mode when the internet connection is unavailable. The app leverages a third-party API (Coinlayer) to fetch the latest currency exchange rates.

## Features

- **Real-time Currency Rates**: Fetches and displays a list of exchange rates for various currencies.
- **Favorites**: Users can mark specific rates as favorites and easily view them from a dedicated "Favorites" section.
- **Offline Mode**: When no network connection is available, users can still access previously fetched data.
- **Network Monitoring**: Monitors network status and shows saved data when offline.

## Technical Description

### App Architecture and Design Choices

The app follows the **MVVM (Model-View-ViewModel)** architecture:

- **Model**: The model consists of `CurrencyRate` and `CoinlayerResponse`, which represent the data structure used to fetch and store exchange rate information.
- **ViewModel**: The `CurrencyListViewModel` manages the business logic, such as fetching exchange rates from the API, managing favorites, and handling offline mode.
- **View**: The `CurrencyListView` is the main SwiftUI view that displays the list of exchange rates and the favorites. It also includes a tab bar navigation to switch between the currency rates and favorites sections.

### Description of App Structure and Major Components

- **NetworkManager**: Handles all network-related tasks, such as checking for network availability using the `NWPathMonitor` class and fetching exchange rates from the Coinlayer API. It also manages offline support by saving the fetched data locally.
  
- **CurrencyRate**: A simple struct that represents the currency rate with properties such as `symbol` (currency code) and `rate` (exchange rate value).
  
- **CoinlayerResponse**: A struct that decodes the response from the Coinlayer API into a list of currency rates.

- **CurrencyListViewModel**: The ViewModel that fetches currency rates from the network (or local storage if offline), manages the list of favorite rates, and provides the necessary data to the view.

- **CurrencyListView**: A SwiftUI view that displays the list of currency exchange rates and allows users to toggle favorite rates. It also includes error messages when the network is unavailable and uses a tab bar for navigation between different sections of the app.

### How Offline Mode Was Implemented

Offline support is implemented using **UserDefaults** to persist previously fetched rates and favorite selections. When the app detects no network connection, it loads the saved data from `UserDefaults` to display it to the user.

1. **Saving Data**: When the data is fetched successfully, it is saved to `UserDefaults` under a specific key.
2. **Loading Data**: When the app starts, or when the network is unavailable, the app checks for saved data in `UserDefaults` and displays it.
3. **Network Monitoring**: The app monitors the network connection using `NWPathMonitor`. When the network is down, it displays saved data and notifies the user.

### Additional Features and Libraries Used

- **SwiftUI**: For the user interface, making the app declarative and reactive.
- **Combine**: Used for reactive programming to handle asynchronous network requests and update the UI automatically when data is fetched.
- **Network Framework (NWPathMonitor)**: Used for network reachability and monitoring the current network status to determine if the app should attempt to fetch data from the network or use cached data.
- **UserDefaults**: Used for storing the favorite currency rates and the last fetched rates, allowing offline access.

### How to Run the Project

1. Clone this repository to your local machine:

    ```bash
    git clone <repository-url>
    ```

2. Open the project in Xcode:

    ```bash
    open CurrencyExchangeRatesApp.xcodeproj
    ```

3. Make sure the `API_KEY` and `BASE_URL` are set correctly in the `Config.xcconfig` file or in the app’s configuration settings.
4. Run the app on a simulator or device.

### Configuration

- **API Key**: You need to replace the `API_KEY` in `Config.xcconfig` with your own Coinlayer API key.
- **Base URL**: The API’s base URL (`BASE_URL`) is provided by Coinlayer (e.g., `https://api.coinlayer.com/api/live`).

### Example `.xcconfig` file:

```ini
API_KEY = "your_coinlayer_api_key_here"
BASE_URL = "https://api.coinlayer.com/api/live"
