//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Arkasha Zuev on 01.06.2021.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    
    @State private var titleConfirmationMessage = ""
    @State private var confirmationMessage = ""
    @State private var showingConfiguration = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text("Your total is $\(order.cost, specifier: "%.2f")")
                    
                    Button("Place Order") {
                        placeOrder()
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Check out", displayMode: .inline)
        }
        .alert(isPresented: $showingConfiguration) {
            Alert(
                title: Text(self.titleConfirmationMessage),
                message: Text(confirmationMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(order) else {
            setConfirmationMessage(title: "Error", message: "Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                setConfirmationMessage(title: "Error", message: "No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let decoderOrder = try? JSONDecoder().decode(Order.self, from: data) {
                setConfirmationMessage(title: "Thank you!", message: "Your order for \(decoderOrder.quantity)x \(Order.types[decoderOrder.type].lowercased()) cupcakes is on its way!")
            } else {
                setConfirmationMessage(title: "Error", message: "Invalid responce from server")
            }
        }.resume()
    }
    
    func setConfirmationMessage(title: String, message: String) {
        self.titleConfirmationMessage = title
        self.confirmationMessage = message
        self.showingConfiguration = true
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
