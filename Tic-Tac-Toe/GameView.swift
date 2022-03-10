//
//  GameView.swift
//  Tic-Tac-Toe
//
//  Created by Oshane Williams on 15/12/2021.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var gameViewModel = GameViewModel()
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                Spacer()
                
                LazyVGrid(columns: gameViewModel.columns, spacing: 10){
                    ForEach(0..<9, id: \.self){i in
                        ZStack{
                            GameCircleView(proxy: geometry)
                            PlayerMakerView(playerMarker: gameViewModel.moves[i]?.indicator)
                        }
                        .onTapGesture {
                            gameViewModel.processPlayerMove(for: i)
                        }
                    }
                    
                }
                
                Spacer()
                
            }
            .padding()
            .disabled(gameViewModel.isGameBoardDisabled)
            .alert(item: $gameViewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action:{gameViewModel.resetGame()}))
            })
              
            
        }
           
    }
    
    
}
 
enum Player {
    case human, computer
}

struct Move{
    let boardIndex: Int
    let player: Player
    
    var indicator: String{
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
.previewInterfaceOrientation(.portrait)
    }
}

struct GameCircleView: View {
    
    var proxy: GeometryProxy
    
    var body: some View {
        Circle()
            .foregroundColor(.purple)
            .opacity(0.9)
            .frame(width: proxy.size.width/3 - 25,
                   height: proxy.size.width/3 - 25)
    }
}

struct PlayerMakerView: View {
    var playerMarker: String?
    
    var body: some View {
        Image(systemName: playerMarker ?? "")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}
