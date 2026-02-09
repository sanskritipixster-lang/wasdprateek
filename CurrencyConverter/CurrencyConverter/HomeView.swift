//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by Prateek Kumar Rai on 09/02/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var isExpanded = false
    @State private var showDepositSheet = false
    
    @Query(sort: \Transaction.date, order: .reverse)
    var transactions: [Transaction]
    
    @StateObject var viewModel: ViewModel = ViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            
            Color.blue
                .ignoresSafeArea()
            
            // MARK: - Top Blue Section
            VStack(spacing: 24) {
                
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: 44, height: 44)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Good Morning 👋")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text("Alex Walker")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 16) {
                            Circle()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: "bell")
                                        .foregroundColor(.white)
                                )
                            
                            Circle()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: "gearshape")
                                        .foregroundColor(.white)
                                )
                        }
                    }
                    .padding(.top, 16)
                    
                    // Balance
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Available Balance")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("₹ \(viewModel.balance, specifier: "%.2f")")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Buttons
                    HStack(spacing: 16) {
                        
                        Button(action: {}) {
                            Text("WITHDRAW")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(14)
                        }
                        
                        
                        Button(action: {showDepositSheet = true}) {
                            Text("DEPOSIT")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black.opacity(0.85))
                                .foregroundColor(.white)
                                .cornerRadius(14)
                        }
                        .sheet(isPresented: $showDepositSheet) {
                            InputBottomSheetView()
                                .presentationDetents([.medium])
                        }
                    }
                }
                .padding(.horizontal)
                
                //                Spacer()
            }
            
            // MARK: - Bottom History Sheet
            VStack(spacing: 16) {
                if isExpanded{
                    Spacer()
                        .frame(height: 44)
                }
                HStack {
                    Text("History")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(isExpanded ? "Collapse" : "Expand")
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                        .onTapGesture {
                            withAnimation(
                                .spring(
                                    response: 0.35,
                                    dampingFraction: 0.65,
                                    blendDuration: 0.2
                                )
                            ) {
                                isExpanded.toggle()
                            }
                        }
                }
                
                Spacer(minLength: 40)
                
                if transactions.isEmpty{
                    VStack(spacing: 12) {
                        Image(systemName: "doc.text")
                            .resizable()
                            .frame(width: 50, height: 60)
                            .foregroundColor(.blue.opacity(0.6))
                        
                        Text("NO DATA")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }else{
                    ScrollView {
                        VStack(spacing: 12) {
                            // Show 5 transactions by default, 10 when expanded
                            ForEach(transactions.prefix(isExpanded ? 10 : 5)) { transaction in
                                TransactionRow(transaction: transaction)
                            }
                        }
                        .padding(.horizontal)
                    }

                }
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(24)
            .padding(.top, isExpanded ? 0 : 300)
            .ignoresSafeArea(edges: isExpanded ? .all : .bottom)
        }
    }
    
}

struct TransactionRow: View {
    let transaction: Transaction
    @State private var calculatedINR: Double?

    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(transaction.type == .deposit ? Color.green : Color.red)
                    .opacity(0.1)
                Image(transaction.type == .deposit ? "deposit" : "withdraw")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(transaction.type == .deposit ? .green : .red)
            }
            .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.system(size: 16, weight: .bold))
                Text(formatDate(transaction.date))
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                if transaction.currency == "INR" {
                    Text("INR \(String(format: "%.0f", transaction.amount))")
                        .font(.system(size: 18, weight: .bold))
                } else {
                    Text("\(transaction.currency) \(String(format: "%.0f", transaction.amount))")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.left.arrow.right")
                            .font(.system(size: 10))
                            .foregroundColor(.gray.opacity(0.6))
                        
                        Text("₹ \(String(format: "%.2f", transaction.inrAmount))")
                            .font(.system(size: 18, weight: .bold))
                    }
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    HomeView()
}
