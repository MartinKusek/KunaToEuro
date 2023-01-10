//
//  ContentView.swift
//  KunaToEuro
//
//  Created by Martin Kusek on 08.01.2023.. €
//

import SwiftUI

struct ContentView: View {
    @State var currency: String = "HRK"
    var oppositeCurrency: String {
        if currency == "HRK" {
            return "EUR"
        } else {
            return "HRK"
        }
    }
    @State var value: String = ""
    @State var convertedValue: String = "0.00"
    
    let currencyArray = ["HRK", "EUR"]
    let exRate: Double = 7.53450
    
    private func calculate() {
        var decimalConvertedValue = 0.0
        if currency == "HRK" {
            decimalConvertedValue = (Double(value) ?? 0) / exRate
        } else {
            decimalConvertedValue = (Double(value) ?? 0) * exRate
        }
        
        convertedValue = String(format: "%.2f", decimalConvertedValue)
    }

    var body: some View {
        
        VStack {
            Text("KunaToEuro")
                .font(.largeTitle)
                .bold()
            
            Picker("", selection: $currency) {
                ForEach(currencyArray, id: \.self)
                {
                    Text($0)
                }
            }.onChange(of: currency){_ in
                calculate()
            }
            .pickerStyle(.segmented)
            .padding()
            
            Text("Fiksni tečaj konverzije: 1EUR = 7.53450HRK")
                .font(.caption)
                .padding(.top, -10)
            
            TextField("0.00 \(currency)", text: $value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .onChange(of: value) { newValue in
                    print(newValue)
                    value = newValue.filter { "0123456789.".contains($0) }
                    
                    //If the first diget is 0 next is .
                    if value.first == "0" {
                        if value.count > 1 && value[value.index(value.startIndex, offsetBy: 1)] != "." {
                            value = "0."
                        }
                    }
                    //Can't start with .
                    if value.starts(with: ".") {
                        value.removeFirst()
                    }
                    //Only one .
                    let count = value.filter { $0 == "." }.count
                    if count > 1 {
                        value.removeLast()
                    }
                    
                    calculate()
                }
            
            Text("\(convertedValue) \(oppositeCurrency)")
                .font(.title)
                .bold()
                .padding()
        }
        .padding()        
    }
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
