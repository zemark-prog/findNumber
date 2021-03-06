//
//  Game.swift
//  Find Num
//
//  Created by Mark Zegelman on 12.05.2022.
//

import Foundation

enum StatusGame{
    case start
    case win
    case loose
}

class Game {
    struct Item {
        var title: String
        var isFound: Bool = false
        var isError = false
    }
    
    
    private var timer: Timer?
    private let data = Array(1...99)
    var items: [Item] = []
    
    private var countItems: Int
    
    private var timeForGame: Int
    
    private var updateTimer: (StatusGame, Int) -> Void
    
    var statusGame: StatusGame = .start {
        didSet {
            if statusGame != .start {
                stopGame()
            }
        }
    }
    var nextItem: Item?
    
    
    
    private var secondsGame: Int {
        didSet {
            if secondsGame == 0 {
                statusGame = .loose
            }
            updateTimer(statusGame, secondsGame)
        }
    }

    
    init(countItems: Int, timeforGame: Int, updateTimer: @escaping (_ status: StatusGame, _ seconds: Int) -> Void){
        self.countItems = countItems
        self.secondsGame = timeforGame
        self.timeForGame = timeforGame
        self.updateTimer = updateTimer
        setupGame()
    }
    
    private func setupGame(){
        var digits = data.shuffled()
        items.removeAll()
        while items.count < countItems {
            let item = Item(title: String(digits.removeFirst()))
            items.append(item)
        }
        nextItem = items.shuffled().first
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
            self?.secondsGame -= 1
        })
        updateTimer(statusGame, secondsGame)
    }
    
    func check(index: Int){
        guard statusGame == .start else {return}
        if items[index].title == nextItem?.title{
            items[index].isFound = true
            nextItem = items.shuffled().first(where: {(item) -> Bool in
                item.isFound == false
            })
        } else {
            items[index].isError = true
        }
        if nextItem == nil {
            statusGame = .win
        }
    }
        
    private func stopGame (){
        timer?.invalidate()
    }
    
    func newGame () {
        statusGame = .start
        self.secondsGame = self.timeForGame
        setupGame()
        
    }
}


extension Int{
    func secondsToString () -> String {
        let minutes = self / 60
        let seconds = self % 60
        
        return String(format: "%d:%02d", minutes, seconds)
    }
}
