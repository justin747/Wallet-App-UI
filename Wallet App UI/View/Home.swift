//
//  Home.swift
//  Wallet App UI
//
//  Created by Justin on 8/23/22.
//

import SwiftUI

struct Home: View {
    
    @State var cards: [Card] = [
        .init(cardImage: "Card1"),
        .init(cardImage: "Card2")]
    
    //MARK: Animation Properties
    
    @State var selectedCard: Card?
    @State var showDetail: Bool = false
    @State var showDetailContent: Bool = false
    @State var showExpenses: Bool = false
    @Namespace var animation
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Welcome Back, ")
                    .font(.title.bold())
                
                Text("CM Punk")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .trailing, content: {
                //MARK: Profile Button
                
                Button {
                    
                } label: {
                    Image("cmpunk")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                }
                
            })
            .padding(15)
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text("Total Balance: ")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                Text("$1,000,821")
                    .font(.title.bold())
            }
            .padding(15)
            .padding(.top, 15)
            .frame(maxWidth: .infinity, alignment: . leading)
            
            CardsScrollView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .opacity(showDetail ? 0 : 1)
        .background{
            Color("BG")
                .ignoresSafeArea()
        }
        .overlay {
            if let selectedCard, showDetail {
                DetailView(card: selectedCard)
                
                //MARK: Transition Fluidity
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: 1)))
            }
        }
    }
    
    //MARK: Cards ScrollView
    @ViewBuilder
    func CardsScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(cards) { card in
                    GeometryReader { proxy in
                        let size = proxy.size
                        
                        if selectedCard?.id == card.id && showDetail {
                            //MARK: Fill Empty Space
                            Rectangle()
                                .fill(.clear)
                                .frame(width: size.width, height: size.height)
                            
                        } else {
                            
                            Image(card.cardImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .matchedGeometryEffect(id: card.id, in: animation)
                            //MARK: Vertical Card
                                .rotationEffect(.init(degrees: -90))
                                .frame(width: size.height, height: size.width)
                            //MARK: Card Centered
                                .frame(width: size.width, height: size.height)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8)) {
                                        selectedCard = card
                                        showDetail   = true
                                    }
                                }
                        }
                    }
                    .frame(width: 300)
                }
            }
            .padding(15)
            .padding(.leading, 20)
        }
    }
    
    //MARK: Detail View
    @ViewBuilder
    func DetailView(card: Card) -> some View {
        VStack {
            HStack {
                Button {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        showDetailContent = false
                        showExpenses = false
                    }
                    withAnimation(.easeInOut(duration: 0.5).delay(0.05)) {
                        showDetail = false
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                Text("Back")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 15)
            .opacity(showDetailContent ? 1 : 0)
            
            Image(card.cardImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .matchedGeometryEffect(id: card.id, in: animation)
                .rotationEffect(.init(degrees: showDetailContent ? 0 : -90))
                .frame(height: 220)
            
            ExpensesView()
            
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                showDetailContent = true
            }
            withAnimation(.easeOut.delay(0.1)) {
                showExpenses = true
            }
        }
    }
    
    //MARK: Expenses View
    @ViewBuilder
    func ExpensesView() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(expenses) { expense in
                        //MARK: Expense Card View
                        ExpenseCardView(expense: expense)
                    }
                }
                .padding()
            }
            .frame(width: size.width, height: size.height)
            .background {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.white)
            }
            
            //MARK: Opening Expense view from bottom of Card
            .offset(y: showExpenses ? 0 : size.height + 50)
        }
        .padding(.top)
        .padding(.horizontal, 10)
    }
}

struct ExpenseCardView: View {
    
    @State var showView: Bool = false
    var expense: Expense
    
    var body: some View {
        HStack(spacing: 14) {
            Image(expense.productIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 45, height: 45)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(expense.product)
                    .fontWeight(.bold)
                Text(expense.spendType)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(expense.amountSpent)
                    .fontWeight(.bold)
                Text(Date().formatted(date: .numeric, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        //MARK: Animation
        .foregroundColor(.black)
        .opacity(showView ? 1 : 0)
        .offset(y: showView ? 0 : 20)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.3).delay(Double(getIndex()) * 0.1)) {
                    showView = true
                }
            }
        }
    }
        func getIndex() -> Int {
            let index = expenses.firstIndex { C1 in
                return C1.id == expense.id
        } ?? 0
            
            //If index exceeds 20 then animation will not play
            return index < 20 ? index : 20
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
