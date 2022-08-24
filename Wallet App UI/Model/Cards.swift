//
//  Cards.swift
//  Wallet App UI
//
//  Created by Justin on 8/23/22.
//

import SwiftUI

//MARK: Sample Card Data

struct Card: Identifiable{
    var id: String = UUID().uuidString
    var cardImage: String
    var rotation: CGFloat = 0
}
