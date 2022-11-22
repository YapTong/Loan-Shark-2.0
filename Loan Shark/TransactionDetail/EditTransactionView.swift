//
//  EditTransactionView.swift
//  Loan Shark
//
//  Created by Yuhan Du on 21/11/22.
//

import SwiftUI

struct EditTransactionView: View {
    
    @Binding var transaction: Transaction
    var transactionTypes = ["Select", "Loan", "Bill Split"]
    
    var body: some View {
        NavigationView{
            VStack {
                Form {
                    Section(header: Text("Transaction details")) {
                        HStack {
                            Text("Title")
                            TextField("Title", text: $transaction.name)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.trailing)
                        }
                        Picker("Transaction type", selection: $transaction.transactionType) {
                            ForEach(transactionTypes, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    if transaction.transactionType == .loan {
                        Section {
                            HStack {
                                Text("Who")
                                Spacer()
                                Text(transaction.people[0].name!)
                                    .foregroundColor(.secondary)
                            }
                            HStack {
                                Text("Amount")
                                TextField("Amount", value: $transaction.people[0].money, formatter: decimalNumberFormat)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.decimalPad)
                            }
                            
                            let bindingDate = Binding {
                                transaction.people[0].dueDate ?? .now
                            } set: { newValue in
                                transaction.people[0].dueDate = newValue
                            }
                            
                            DatePicker("Due by", selection: bindingDate, in: transaction.people[0].dueDate!..., displayedComponents: .date)
                        }
                    } else if transaction.transactionType == .billSplitSync || transaction.transactionType == .billSplitNoSync {
//                        Section {
//                            Toggle(isOn: $isDetailSynchronised) {
//                                Text("Synchronise details")
//                            }
//                        } footer: {
//                            Text("Toggle this to distribute the total amount of the transaction equally between all selected contacts, and for the same due date to apply for all. ")
//                        }
                        
                    } else if transaction.transactionType == .billSplitNoSync {
                        ForEach($transaction.people, id: \.name) { $person in
                            Section(header: Text(person.name ?? "No Contact Selected")) {
                                HStack {
                                    Text("Who")
                                    Spacer()
                                    Text(person.name ?? "No Contact Selected")
                                        .foregroundStyle(.secondary)
                                }
                                
                                HStack {
                                    Text("Amount")
                                    TextField("Amount", value: $person.money, formatter: decimalNumberFormat)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing)
                                        .keyboardType(.decimalPad)
                                }
                                
                                let dueDateBinding = Binding {
                                    person.dueDate!
                                } set: { newValue in
                                    person.dueDate = newValue
                                }
                                
                                DatePicker("Due by", selection: dueDateBinding, in: person.dueDate!..., displayedComponents: .date)
                            }
                        }
                    } else if transaction.transactionType == . billSplitSync {
                        HStack {
                            Text("Who")
                            Spacer()
                            Text(transaction.people.map { $0.name! }.joined(separator: ", "))
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Amount each")
                            TextField("Amount", value: $transaction.people[0].money, formatter: decimalNumberFormat)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                        }
                        
                        let bindingDate = Binding {
                            transaction.people[0].dueDate ?? .now
                        } set: { newValue in
                            transaction.people[0].dueDate = newValue
                        }
                        
                        DatePicker("Due by", selection: bindingDate, in: transaction.dueDate..., displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("Edit Transaction")
        }
    }
}

