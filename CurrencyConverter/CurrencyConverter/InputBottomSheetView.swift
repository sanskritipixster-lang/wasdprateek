//
//  CurrencyInputView.swift
//  CurrencyConverter
//
//  Created by Prateek Kumar Rai on 09/02/26.
//

import SwiftUI

struct InputBottomSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: ViewModel = ViewModel()
    @State private var amount: String = ""
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedCurrency: String = "USD"
    let currencies: [String] = [
        "USD",
        "AED",
        "JPY",
        "CNY",
        "GBP",
        "CAD",
        "AUD",
        "IQD",
        "INR",
        "KRW"
    ]


    var body: some View {
        VStack(spacing: 16) {

            // MARK: - Top Bar
            HStack(spacing: 12) {
                // currency selector
                Menu {
                    ForEach(currencies, id: \.self) { currency in
                        Button {
                            selectedCurrency = currency
                        } label: {
                            HStack {
                                Text(currency)
                                Spacer()
                                if selectedCurrency == currency {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text(selectedCurrency)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        Image(systemName: "chevron.up.chevron.down")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .frame(minHeight: 52)
                    .padding(.horizontal, 14)
                    .background(Color(red: 2/255, green: 121/255, blue: 255/255))
                    .cornerRadius(12)
                }

                // Amount display
                Text(amount.isEmpty ? "0" : amount)
                    .font(.system(size: 28, weight: .bold))
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(Color.white)
                    .cornerRadius(12)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(amount.isEmpty ? Color.gray : Color.black)
            }
            .padding(.horizontal)

            // MARK: - Keypad
            KeyPadView(
                enteredValue: $amount,
                onConfirm: {
                    // For now: just close the sheet
                    viewModel.saveDeposite(currency: selectedCurrency, amount: Double(amount) ?? 0, context: modelContext)
                    dismiss()
                }
            )

            Spacer(minLength: 0)
        }
        .padding(.top)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(red: 0/255, green: 16/255, blue: 47/255))
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

struct KeyPadView: View {
    @Binding var enteredValue: String
    var onConfirm: () -> Void

    let spacing: CGFloat = 12
    let buttonHeight: CGFloat = 65

    var body: some View {
        HStack(alignment: .top, spacing: spacing) {

            VStack(spacing: spacing) {
                createRow(["7", "8", "9"])
                createRow(["4", "5", "6"])
                createRow(["1", "2", "3"])
                createRow(["0", "00", "."])
            }
            .frame(maxWidth: .infinity)

            VStack(spacing: spacing) {
                actionButton(label: "AC", color: Color(red: 38/255, green: 62/255, blue: 85/255), height: (buttonHeight * 2) + spacing) {
                    enteredValue = ""
                }

                actionButton(systemImage: "delete.left.fill", color: .red.opacity(0.8), height: buttonHeight) {
                    if !enteredValue.isEmpty { enteredValue.removeLast() }
                }

                actionButton(systemImage: "checkmark", color: .green, height: buttonHeight) {
                    onConfirm()
                }
            }
            .frame(width: 80)
        }
        .padding()
    }

    private func createRow(_ keys: [String]) -> some View {
        HStack(spacing: spacing) {
            ForEach(keys, id: \.self) { key in
                Button(action: { append(key) }) {
                    Text(key)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: buttonHeight)
                        .background(Color(red: 38/255, green: 62/255, blue: 85/255))
                        .cornerRadius(15)
                }
            }
        }
    }

    private func actionButton(label: String? = nil, systemImage: String? = nil, color: Color, height: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Group {
                if let label = label {
                    Text(label).font(.headline)
                } else if let systemImage = systemImage {
                    Image(systemName: systemImage).font(.title2)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(color)
            .cornerRadius( systemImage == "checkmark" ? height/2 : 15)
        }
    }

    private func append(_ val: String) {
        // 1. Prevent multiple decimals
        if val == "." && enteredValue.contains(".") { return }

        // 2. Handle initial state
        if enteredValue.isEmpty || enteredValue == "0" || enteredValue == "00" {
            if val == "." {
                enteredValue = "0."
            } else if val == "00" || val == "0" {
                enteredValue = "0"
            } else {
                enteredValue = val
            }
            return
        }

        // 3. Prevent typing more than 2 decimal places (standard for currency)
        if let dotIndex = enteredValue.firstIndex(of: ".") {
            let decimalPart = enteredValue.distance(from: dotIndex, to: enteredValue.endIndex)
            if decimalPart > 2 { return }
        }

        enteredValue += val
    }
}

#Preview{
    KeyPadView(enteredValue: .constant("10.0"), onConfirm: {
    })
}
