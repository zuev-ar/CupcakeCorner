//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Arkasha Zuev on 01.06.2021.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    
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
                        
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Check out", displayMode: .inline)
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
