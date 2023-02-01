//
//  Home.swift
//  Crypto App
//
//  Created by Steve Pha on 1/28/23.
//

import SwiftUI

struct Home: View {
    @State var currentTap: String = "Crypto"
    @Namespace var animation
    @StateObject var appViewModel : AppViewModel = .init()
    var body: some View {
        VStack{
            CustomSegmentedControl()
                .padding()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10){
                    if let coins = appViewModel.coins {
                        ForEach(coins) { coin in
                            CardView(coin: coin )
                            Divider()
                        }
                    }
                }//end vstack
            }
            
            HStack{
                Button{
                    
                }label: {
                    Image(systemName: "gearshape.fill")
                }
                
                Spacer()
                
                Button{
                    
                }label: {
                    Image(systemName: "power")
                }
            }//end hstack
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.black)
            
        }//end vstack
        .frame(width: 320, height: 450)
        .background{Color("BG")}
        .preferredColorScheme(.dark)
        .buttonStyle(.plain)
    }
    
    //MARK: Custom Segmented control
    @ViewBuilder
    func CustomSegmentedControl() -> some View {
        HStack(spacing: 0){
            ForEach(["Crypto", "Stocks"], id: \.self) { tab in
                Text("\(tab)")
                    .fontWeight(currentTap == tab ? .semibold : .regular)
                    .foregroundColor(currentTap == tab ? .white : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background{
                        if currentTap == tab {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color("Tab"))
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            currentTap = tab
                        }
                    }
            }
        }//end hstack
        .padding(2)
        .background{
            Color.black
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        
    }
    
    //MARK: Making custom card view
    @ViewBuilder
    func  CardView(coin: CryptoModel) -> some View {
        HStack{
            VStack(alignment: .leading, spacing: 6){
                Text(coin.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(coin.symbol.uppercased())
                    .font(.caption)
                    .foregroundColor(.gray)
                
            }//end vstack
            .frame(width: 80, alignment: .leading)
            
            //Line Graph View
            LineGraph(data: coin.last_7days_price.price, profit: coin.price_change > 0)
                .padding(.horizontal, 10)
            
            VStack(alignment: .trailing, spacing: 6){
                Text(coin.current_price.convertToCurrency())
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("\(coin.price_change > 0 ? "+" : "")\(String(format: "%.2f", coin.price_change))")
                    .font(.caption)
                    .foregroundColor(coin.price_change > 0 ? Color("LightGreen") : .red)
                
            }//end vstack
            //        .frame(width: 80, alignment: .leading)
        }//end hstack
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

//MARK: Converting double to currency
extension Double {
    func convertToCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: .init(value: self)) ?? ""
    }
}

//source : https://www.youtube.com/watch?v=Vz4hRxUR2iI
