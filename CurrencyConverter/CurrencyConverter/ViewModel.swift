//
//  ViewModel.swift
//  CurrencyConverter
//
//  Created by Prateek Kumar Rai on 09/02/26.
//

import SwiftUI
import Foundation
import Combine
import SwiftData

class ViewModel: ObservableObject {
    let baseURL = "https://v6.exchangerate-api.com/v6"
    let APIKey = "8cea16c76b5c2669eae114d1"
    
    @AppStorage("user_balance") var balance: Double = 0.0
    
    private var cancellables = Set<AnyCancellable>()
    
    func saveDeposite(currency: String, amount: Double, context: ModelContext){
        getConversionRate(from: currency)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error:", error.localizedDescription)
                }
            } receiveValue: { rate in
                print("Conversion rate:", rate)
                self.saveTransaction(context: context, amount: amount, type: .deposit, currency: currency, inrAmount: amount*rate)
                self.balance = self.balance + amount*rate
            }
            .store(in: &cancellables)
    }
    
    func getConversionRate(
        from base: String,
        to target: String = "INR"
    ) -> AnyPublisher<Double, Error> {
        
        let urlString = "\(baseURL)/\(APIKey)/pair/\(base)/\(target)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        let request = URLRequest(url: url)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: ExchangeRateResponse.self, decoder: JSONDecoder())
            .map { $0.conversion_rate }
            .eraseToAnyPublisher()
    }
    
    func saveTransaction(
        context: ModelContext,
        amount: Double,
        type: TransactionType,
        currency: String,
        inrAmount: Double
    ) {

        let transaction = Transaction(
            amount: amount,
            type: type,
            currency: currency,
            inrAmount: inrAmount
        )

        context.insert(transaction)

        do {
            try context.save()
        } catch {
            print("Failed to save transaction:", error)
        }
    }
    
    
}
