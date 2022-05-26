//
//  GameViewController.swift
//  Find Num
//
//  Created by Mark Zegelman on 12.05.2022.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet var Buttons: [UIButton]!
    @IBOutlet weak var nextDigit: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    lazy var game = Game(countItems: Buttons.count, timeforGame: 30) { [weak self] (status, seconds) in
        guard let self = self else {return}
        self.timerLabel.text = "\(seconds)"
        self.updateInfoGame(with: status)
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()

    }
    
    @IBAction func pressButton(_ sender: UIButton) {
        guard let buttonIndex = Buttons.firstIndex(of: sender) else {return}
        game.check(index: buttonIndex)
        
        updateUI()
    }
    
    
    private func setupScreen() {
        for index in game.items.indices {
            Buttons[index].setTitle(game.items[index].title, for: .normal)
            Buttons[index].isHidden = false
        }
        nextDigit.text = game.nextItem?.title
    }
    
    private func updateUI() {
        for index in game.items.indices {
            Buttons[index].isHidden = game.items[index].isFound
        }
        nextDigit.text = game.nextItem?.title
        updateInfoGame(with: game.statusGame)
    }
    
    private func updateInfoGame(with status: StatusGame){
        switch status {
        case .start:
            statusLabel.text = "Game has started"
            statusLabel.textColor = .black
        case .win:
            statusLabel.text = "You won"
            statusLabel.textColor = .green
        case .loose:
            statusLabel.text = "You lost"
            statusLabel.textColor = .red
        }
    }
}

