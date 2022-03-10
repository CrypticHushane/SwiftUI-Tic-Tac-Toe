//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by Oshane Williams on 16/12/2021.
//

import SwiftUI

final class GameViewModel: ObservableObject {
 
    let columns: [GridItem] = [ GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible()),]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled: Bool = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position:Int){
        if isCircleOccupied(in: moves, forIndex: position){return}
        moves[position] = Move(boardIndex: position, player: .human)
        
        
        //check if human wins
        if checkWinCondition(for: .human, in: moves){
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkForDraw(in: moves){
            alertItem = AlertContext.draw
            return
        }
        
        isGameBoardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){ [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            
            if isCircleOccupied(in: moves, forIndex: computerPosition){return}
            moves[computerPosition] = Move(boardIndex: computerPosition, player: .computer)
            
            
            if checkWinCondition(for: .computer, in: moves){
                alertItem = AlertContext.computerWin
                return
            }
            
            if checkForDraw(in: moves){
                alertItem = AlertContext.draw
                return
            }
            
            isGameBoardDisabled = false
        }
    }
    
    func isCircleOccupied(in moves: [Move?], forIndex index: Int) -> Bool{
        //moves[index]?.boardIndex == nil ? false : true
        
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        //If AI can win, then win
        let computerMoves = moves.compactMap{$0}.filter{$0.player == .computer}
        let computerPositions = Set(computerMoves.map{$0.boardIndex})
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isCircleOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first!  }
                
            }
        }
        
        //If AI cant win, then block
        let humanMoves = moves.compactMap{$0}.filter{$0.player == .human}
        let humanPositions = Set(humanMoves.map{$0.boardIndex})
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isCircleOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first!  }
                
            }
        }
        
        //If AI cant block, take middle circle
        let centerCircle = 4
        if !isCircleOccupied(in: moves, forIndex: centerCircle){ return centerCircle}
        
        //if AI cant take middle circle, take random available circle
        var randomIndex = Int.random(in: 0..<9)
        
        while isCircleOccupied(in: moves, forIndex: randomIndex){
            randomIndex = Int.random(in: 0..<9)
        }
        
        return randomIndex
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool{
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let playerMoves = moves.compactMap{$0}.filter{$0.player == player}
        let playerPositions = Set(playerMoves.map{$0.boardIndex})
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions){return true}
        
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool{
        return moves.compactMap{ $0 }.count == 9
    }
    
    func resetGame(){
    moves = Array(repeating: nil, count: 9)
    }
    
}
