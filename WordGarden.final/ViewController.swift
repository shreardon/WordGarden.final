//
//  ViewController.swift
//  WordGarden.final
//
//  Created by Shannon Reardon on 6/12/19.
//  Copyright © 2019 Shannon Reardon. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var wordsGuessedLabel: UILabel!
    @IBOutlet weak var wordsMissedLabel: UILabel!
    @IBOutlet weak var wordsRemainingLabel: UILabel!
    @IBOutlet weak var totalWordsLabel: UILabel!
    @IBOutlet weak var userGuessLabel: UILabel!
    @IBOutlet weak var guessedLetterField: UITextField!
    @IBOutlet weak var guessLetterButton: UIButton!
    @IBOutlet weak var guessCountLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var flowerImageView: UIImageView!
    var wordsToGuess = ["SWIFT",
                        "DOG",
                        "CAT"]
    //                        "INTERPRETER",
    //                        "MUTABLE",
    //                        "PROGRAMMER",
    //                        "SUPERHERO"]
    var wordToGuess = ""
    var wordToGuessIndex = 0
    var lettersGuessed = ""
    let maxNumberOfWrongGuesses = 8
    var wrongGuessesRemaining = 8
    var guessCount = 0
    var wordsGuessedCount = 0
    var wordsMissedCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordToGuess = wordsToGuess[wordToGuessIndex]
        totalWordsLabel.text = "Words in Game: \(wordsToGuess.count)"
        formatUserGuessLabel()
        guessLetterButton.isEnabled = false
        playAgainButton.isHidden = true
    }
    
    //MARK:- Formatting Methods
    
    func updateWordCountLabels(){
        wordsMissedLabel.text = "Words Missed: \(wordsMissedCount)"
        wordsGuessedLabel.text = "Words Guessed: \(wordsGuessedCount)"
        wordsRemainingLabel.text = "Words Remaining: \(wordsToGuess.count - (wordsGuessedCount + wordsMissedCount))"
    }
    
    func updateUIAfterGuess(){
        guessedLetterField.resignFirstResponder()
        guessedLetterField.text = ""
    }
    
    func formatUserGuessLabel() {
        var revealedWord = ""
        lettersGuessed += guessedLetterField.text!
        
        for letter in wordToGuess {
            if lettersGuessed.contains(letter) {
                revealedWord = revealedWord + " \(letter)"
            } else {
                revealedWord += " _"
            }
        }
        revealedWord.removeFirst()
        userGuessLabel.text = revealedWord
    }
    
    //MARK:- Game Play Methods
    
    func guessALetter() {
        formatUserGuessLabel()
        guessCount += 1
        
        // decrements the wrongGuessesRemaining and shows the next flower image with one less
        // pedal
        let currentLetterGuessed = guessedLetterField.text!
        if !wordToGuess.contains(currentLetterGuessed) {
            wrongGuessesRemaining = wrongGuessesRemaining - 1
            flowerImageView.image = UIImage(named: "flower\(wrongGuessesRemaining)")
        }
        
        let revealedWord = userGuessLabel.text!
        // Stop game if wrongGuessesRemaining = 0
        if wrongGuessesRemaining == 0 {
            playAgainButton.isHidden = false
            guessedLetterField.isEnabled = false
            guessLetterButton.isEnabled = false
            guessCountLabel.text = "So sorry, you're all out of guesses. Try again?"
            wordsMissedCount += 1
            updateWordCountLabels()
        } else if !revealedWord.contains("_") {
            // You've won a game!
            playAgainButton.isHidden = false
            guessedLetterField.isEnabled = false
            guessLetterButton.isEnabled = false
            guessCountLabel.text = "You've got it! It took you \(guessCount) guesses to guess the word!"
            wordsGuessedCount += 1
            updateWordCountLabels()
        } else {
            // Update our guess count
            let guess = ( guessCount == 1 ? "Guess" : "Guesses")
            guessCountLabel.text = "You've Made \(guessCount) \(guess)"
        }
        
        if (wordsGuessedCount + wordsMissedCount) == wordsToGuess.count {
            guessCountLabel.text = "You've tried all of the words! Restart from the beginning?"
        }
    }
    
    //MARK:- @IBActions
    
    @IBAction func guessedLetterFieldChanged(_ sender: UITextField) {
        if let letterGuessed = guessedLetterField.text?.last {
            guessedLetterField.text = "\(letterGuessed)"
            guessLetterButton.isEnabled = true
        } else {
            // disable the button if I don't have a single character in the guessedLetterField
            guessLetterButton.isEnabled = false
        }
    }
    
    @IBAction func doneKeyPressed(_ sender: UITextField) {
        guessALetter()
        updateUIAfterGuess()
    }
    
    @IBAction func guessLetterButtonPressed(_ sender: UIButton) {
        guessALetter()
        updateUIAfterGuess()
    }
    
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
        // incriment to new word in the array
        wordToGuessIndex += 1
        if wordToGuessIndex == wordsToGuess.count {
            wordToGuessIndex = 0
            wordsGuessedCount = 0
            wordsMissedCount = 0
            updateWordCountLabels()
        }
        wordToGuess = wordsToGuess[wordToGuessIndex]
        
        playAgainButton.isHidden = true
        guessedLetterField.isEnabled = true
        guessLetterButton.isEnabled = false
        flowerImageView.image = UIImage(named: "flower8")
        wrongGuessesRemaining = maxNumberOfWrongGuesses
        lettersGuessed = ""
        formatUserGuessLabel()
        guessCountLabel.text = "You've Made 0 Guesses"
        guessCount = 0
    }
    
}
