//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by Oshane Williams on 16/12/2021.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title:Text
    var message:Text
    var buttonTitle:Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"), message: Text("Lets gooo"), buttonTitle: Text("gg"))
    static let computerWin = AlertItem(title: Text("You Lost!"), message: Text("Thats Tuff"), buttonTitle: Text("gg"))
    static let draw = AlertItem(title: Text("Draw!"), message: Text("Challenge"), buttonTitle: Text("gg again?"))
}
