//
//  DetailViewController.swift
//  PokedexClass
//
//  Created by John Gallaugher on 11/7/17.
//  Copyright © 2017 Gallaugher. All rights reserved.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonImageTwo: UIImageView!
    @IBOutlet weak var moveButtonOne: UIButton!
    @IBOutlet weak var moveButtonTwo: UIButton!
    @IBOutlet weak var moveButtonThree: UIButton!
    @IBOutlet weak var moveButtonFour: UIButton!
    @IBOutlet weak var battleFeed: UILabel!
    @IBOutlet weak var pokemonOneHealth: UIImageView!
    @IBOutlet weak var pokemonTwoHealth: UIImageView!
    @IBOutlet weak var victoryLabel: UILabel!
    @IBOutlet weak var enemyPokemonName: UILabel!
    
    
    
    var pokeDetail = PokeDetail()
    var randPokemon = randomPokemon()
    var activityIndicator = UIActivityIndicatorView()
    var timer = Timer()
    var timerTwo = Timer()
    var timerThree = Timer()
    var timerFour = Timer()
    var moveEffectiveNess = ""
    var healthBarDamage: CGFloat = 150
    var healthBarTwoDamage: CGFloat = 150
    var musicPlayer = AVAudioPlayer()
    let moveOneDamage = CGFloat(arc4random_uniform(UInt32(80)))
    let moveTwoDamage = CGFloat(arc4random_uniform(UInt32(80)))
    let moveThreeDamage = CGFloat(arc4random_uniform(UInt32(80)))
    let moveFourDamage = CGFloat(arc4random_uniform(UInt32(80)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.victoryLabel.isHidden = true
        self.battleFeed.isHidden = true
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "110311fsun")!)
        generateBorders()
        nameLabel.text = pokeDetail.name.uppercased()
        playSound(soundName: "BattleMusic", audioPlayer: &musicPlayer)
        setUpActivityIndicator()
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        pokeDetail.getPokeDetail {
            self.updateFriendlyInterface()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        randPokemon.getRandomPokemon {
            self.updateEnemyInterface()
            self.activityIndicator.stopAnimating()
        }
    }
    
    func updateFriendlyInterface() {
        moveButtonOne.setTitle("\(pokeDetail.moveOne)", for: .normal)
        moveButtonTwo.setTitle("\(pokeDetail.moveTwo)", for: .normal)
        moveButtonThree.setTitle("\(pokeDetail.moveThree)", for: .normal)
        moveButtonFour.setTitle("\(pokeDetail.moveFour)", for: .normal)
        
        
        guard let url = URL(string: pokeDetail.imageURL) else { return }
        do {
            let data = try Data(contentsOf: url)
            pokemonImage.image = UIImage(data: data)
        } catch {
            print("ERROR: error thrown trying to get data from URL \(url)")
        }
      
    }
    
    func updateEnemyInterface() {
        enemyPokemonName.text = randPokemon.randPokeName.uppercased()
        
        guard let urlTwo = URL(string: randPokemon.randPokeImage) else { return }
        do {
            let dataTwo = try Data(contentsOf: urlTwo)
            pokemonImageTwo.image = UIImage(data: dataTwo)
        } catch {
            print("ERROR: error thrown trying to get data from URL \(urlTwo)")
        }
    }
    
    
    func setUpActivityIndicator(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = UIColor.red
        view.addSubview(activityIndicator)
    }
    
    func playSound(soundName: String, audioPlayer: inout AVAudioPlayer) {
        if let sound = NSDataAsset (name: soundName){
            do{
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            } catch {
                print("error \(soundName) could not be played")
            }
        }else {
            print("error \(soundName) did not load")
        }
    }
    
    
    func generateBorders(){
        moveButtonOne.layer.borderWidth = 5
        moveButtonOne.layer.borderColor = UIColor.red.cgColor
        moveButtonTwo.layer.borderWidth = 5
        moveButtonTwo.layer.borderColor = UIColor.red.cgColor
        moveButtonThree.layer.borderWidth = 5
        moveButtonThree.layer.borderColor = UIColor.red.cgColor
        moveButtonFour.layer.borderWidth = 5
        moveButtonFour.layer.borderColor = UIColor.red.cgColor
        battleFeed.layer.borderWidth = 5
        battleFeed.layer.borderColor = UIColor.red.cgColor
    }
    
    func pokemonOneAttackAnimate(move: Int) {
     
        UIView.animate(withDuration: 0.1, delay: 1.0, animations: {
            self.pokemonImage.frame.origin.y -= 30
            self.pokemonImage.frame.origin.x += 30})
        
        UIView.animate(withDuration: 0.1, delay: 1.1, animations: {
            self.pokemonImage.frame.origin.y += 30
            self.pokemonImage.frame.origin.x -= 30})
        
        UIView.animate(withDuration: 0.25, delay: 1.2, animations: {
            self.pokemonImageTwo.bounds.size.width -= 20
            self.pokemonImageTwo.bounds.size.height -= 20
        })
        
        UIView.animate(withDuration: 0.25, delay: 1.75, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {
            self.pokemonImageTwo.bounds.size.width += 20
            self.pokemonImageTwo.bounds.size.height += 20}, completion: nil)
        
        UIView.animate(withDuration: 0.4, delay: 2.0, animations: {
            switch move {
            case 1:
                self.pokemonTwoHealth.frame.size.width -= self.moveOneDamage
            case 2:
                self.pokemonTwoHealth.frame.size.width -= self.moveTwoDamage
            case 3:
                self.pokemonTwoHealth.frame.size.width -= self.moveThreeDamage
            case 4:
                self.pokemonTwoHealth.frame.size.width -= self.moveFourDamage
            default:
                self.pokemonTwoHealth.frame.size.width = 0
            }}, completion: {
                finished in self.showCompletionVictoryMessage() }
        )

    }

    
    

    func showCompletionVictoryMessage(){
        if pokemonTwoHealth.frame.size.width == 0 {
            victoryLabel.isHidden = false
            victoryLabel.text = "Congrats! You won! Hit Back to play again"
            musicPlayer.stop()
            
        }
    }
    
    
    func showCompletionDefeatMessage() {
        if pokemonOneHealth.frame.size.width == 0 && pokemonTwoHealth.frame.size.width > 0 {
            victoryLabel.isHidden = false
            victoryLabel.text = "Your Pokemon Fainted! To go get it healed, hit the back button"
            musicPlayer.stop()
        }
    }
    
    
    func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: (#selector(DetailViewController.moveEffectivness)), userInfo: nil, repeats: false)
        
        timerTwo = Timer.scheduledTimer(timeInterval: 4, target: self, selector: (#selector(DetailViewController.enemyAttack)), userInfo: nil, repeats: false)
        
        timerThree = Timer.scheduledTimer(timeInterval: 7, target: self, selector: (#selector(DetailViewController.showMoveButtons)), userInfo: nil, repeats: false)
        
        }
        
    
    
    @objc func clearBattleFeed(){
        battleFeed.text = ""
    }
    
    @objc func moveEffectivness() {
        battleFeed.text = moveEffectiveNess
    }
    
    @objc func enemyAttack() {
        var attackStrength: CGFloat = 0.0
        let enemyDamage = CGFloat(arc4random_uniform(UInt32(80)))
        healthBarTwoDamage = healthBarTwoDamage - enemyDamage
        
       
        battleFeed.text = "The Wild \(pokeDetail.name.uppercased()) Attacked"
        
        UIView.animate(withDuration: 0.1, delay: 1.0, animations: {
            self.pokemonImageTwo.frame.origin.y -= 30
            self.pokemonImageTwo.frame.origin.x += 30})
        
        UIView.animate(withDuration: 0.1, delay: 1.1, animations: {
            self.pokemonImageTwo.frame.origin.y += 30
            self.pokemonImageTwo.frame.origin.x -= 30})
        
        UIView.animate(withDuration: 0.25, delay: 1.2, animations: {
            self.pokemonImage.bounds.size.width -= 20
            self.pokemonImage.bounds.size.height -= 20
        })
        
        UIView.animate(withDuration: 0.25, delay: 1.75, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {
            self.pokemonImage.bounds.size.width += 20
            self.pokemonImage.bounds.size.height += 20}, completion: nil)
        
        
        UIView.animate(withDuration: 0.4, delay: 2.0, animations: {
            if self.healthBarTwoDamage > enemyDamage {
            attackStrength = enemyDamage
                self.pokemonOneHealth.frame.size.width -= attackStrength
        } else {
                self.pokemonOneHealth.frame.size.width = 0
            }
            
        }, completion: {
            finished in self.showCompletionDefeatMessage()
        })
        
        
        }
    
    
    func hideMoveButtons(){
        moveButtonOne.isHidden = true
        moveButtonTwo.isHidden = true
        moveButtonThree.isHidden = true
        moveButtonFour.isHidden = true
        battleFeed.isHidden = false
    }
    
    @objc func showMoveButtons(){
        moveButtonOne.isHidden = false
        moveButtonTwo.isHidden = false
        moveButtonThree.isHidden = false
        moveButtonFour.isHidden = false
        battleFeed.isHidden = true
        battleFeed.text = ""
    }
    
    func updateBattleFeed(moveUsed: String, moveNumber: CGFloat){
        battleFeed.text = "\(pokeDetail.name.uppercased()) used \(moveUsed)"
        runTimer()
        switch Int(moveNumber) {
        case 0:
            moveEffectiveNess = "It had no effect"
        case 1...10:
            moveEffectiveNess = "It's not very effective"
        case 55...65:
            moveEffectiveNess = "It's super effective"
        default:
            moveEffectiveNess = ""
        }
        
    }
    
    @IBAction func moveOnePressed(_ sender: Any) {
        healthBarDamage = healthBarDamage - moveThreeDamage
        if healthBarDamage > moveThreeDamage {
            pokemonOneAttackAnimate(move: 3)
        } else {
            pokemonOneAttackAnimate(move: 5)
        }
        updateBattleFeed(moveUsed: "\(pokeDetail.moveOne.uppercased())", moveNumber: moveOneDamage)
        
        hideMoveButtons()
        
    }
    
    
    @IBAction func moveTwoPressed(_ sender: Any) {
        healthBarDamage = healthBarDamage - moveTwoDamage
        if healthBarDamage > moveTwoDamage {
            pokemonOneAttackAnimate(move: 2)
        } else {
            pokemonOneAttackAnimate(move: 5)
        }
        updateBattleFeed(moveUsed: "\(pokeDetail.moveTwo.uppercased())", moveNumber: moveTwoDamage)
        hideMoveButtons()
    }
    
    
    
    
    @IBAction func moveThreePressed(_ sender: Any) {
        healthBarDamage = healthBarDamage - moveThreeDamage
        if healthBarDamage > moveThreeDamage {
            pokemonOneAttackAnimate(move: 3)
        } else {
            pokemonOneAttackAnimate(move: 5)
        }
        updateBattleFeed(moveUsed: "\(pokeDetail.moveThree.uppercased())", moveNumber: moveThreeDamage)
        hideMoveButtons()
    }
    
    @IBAction func moveFourPressed(_ sender: Any) {
        healthBarDamage = healthBarDamage - moveFourDamage
        if healthBarDamage > moveFourDamage {
            pokemonOneAttackAnimate(move: 4)
        } else {
            pokemonOneAttackAnimate(move: 5)
        }
        updateBattleFeed(moveUsed: "\(pokeDetail.moveFour.uppercased())", moveNumber: moveFourDamage)
        hideMoveButtons()
    }
    
    
    
    
}
