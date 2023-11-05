/*
 
 SecondViewController.swift
 
 This file will contain the code for the second viewcontroller.
 Please ensure that your code is organised and is easy to read.
 This means that you will need to both structure your code correctly,
 in addition to using the correct syntax for Swift.
 
 Unless you are told otherwise, ensure that you are using the
 camelCase syntax. For example, outputLabel and firstName are good
 examples of using the camelCase syntax.
 
 Within each class, you can see clearly identified sections denoted by
 MARK statements. These MARK statements allow you to structure and organise
 your code.
 
 - @IBOutlets should be listed under the MARK section on IBOutlets
 - Variables and constants listed under the MARK section Variables and Constants
 - Functions (including @IBActions) listed under the section on IBActions and Functions.
 
 As you develop each view controller class with Swift code, please include
 detailed comments to both demonstrate understanding, and which serve you as
 a reminder as to what your code actually does.
 
 */

import UIKit

//UI
//Keyboard
//Game Board
//Orange/Green/Grey


class SecondViewController: UIViewController {

    // I created a list that contains the answers and words. I will call on this function when the code runs, picking a word out of the list to use as the answer. In the future, I will expand the list, creating different categories and using multiple lists (true or false).
    
    let gameAns = ["darts", "bingo", "chess", "jacks", "fives", "poker", "rugby", "rules"]
    let movieAns = ["alien", "rocky", "avatar", "ghost", "fargo", "drive", "moana", "brave"]
    let musicAns = ["happy", "hello", "sorry", "cream", "crazy", "alone", "enemy", "toxic"]

    var answer = ""
    var randomNumber = Int.random(in: 0...7)
    var rightCount:Int = 0
    
    func submitButtonClickHandle() {
        
    }
    
    func assignAnswer(){
        if gameData.gameMode == "game"{
            answer = gameAns[randomNumber]
            //answerLabel.text = String(answer)
        }
        else if gameData.gameMode == "movie"{
            answer = movieAns[randomNumber]
            //answerLabel.text = String(answer)
        }
        else {
            answer = musicAns[randomNumber]
            //answerLabel.text = String(answer)
        }
    }
    
    private var guesses: [[Character?]] = Array(
        repeating: Array(repeating: nil, count: 5),
        count: 6
    )
    
    let keyboardVC = KeyboardViewController()
    let boardVC = BoardViewController()
    var enterDate = Date()

    override func viewDidLoad() {
        assignAnswer()
        print(answer)
        
        super.viewDidLoad()
        view.backgroundColor = .black
        addChildren()
        print(answer)
        self.enterDate = Date()
        
        }

    // The addChildren() function in Swift is responsible for adding two child view controllers (keyboardVC and boardVC) to the current view controller. It configures their views, sets the delegate and data source, and adds their views as subviews to the current "Second View Controller's" view. The function also calls addConstraints() to add any required layout constraints.

    private func addChildren() {
        addChild(keyboardVC)
        keyboardVC.didMove(toParent: self)
        keyboardVC.delegate = self
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardVC.view)

        addChild(boardVC)
        boardVC.didMove(toParent: self)
        boardVC.view.translatesAutoresizingMaskIntoConstraints = false
        boardVC.datasource = self
        view.addSubview(boardVC.view)

        addConstraints()
    }

    //* Using constraints (Auto Layout) allows me to create views that can adjust to different size classes, positions, angles, and more. Without having to manually update frames or positions, constraints ensure that the views adapt to any size changes. The KeyboardViewControllerDelegate extension handles the input of keyboard letters. It updates the current guess grid with the tapped letter.

    func addConstraints() {
        NSLayoutConstraint.activate([
            boardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            boardVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            boardVC.view.bottomAnchor.constraint(equalTo: keyboardVC.view.topAnchor),
            boardVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),

            keyboardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension SecondViewController: KeyboardViewControllerDelegate {
    func keyboardViewController(_ vc: KeyboardViewController, didTapKey letter: Character) {

        // Update guesses
        var stop = false
        for i in 0..<guesses.count {
            for j in 0..<guesses[i].count {
                if guesses[i][j] == nil {
                    guesses[i][j] = letter
                    stop = true
                    break
                }
            }

            if stop {
                break
            }
        }
        boardVC.reloadData()
        
        ///The given code is a part of a larger implementation related to a game's completion and the creation of a pop-up view. It initializes a boolean variable called "stop" as false and iterates over a two-dimensional array called "guesses." If a specific element in the "guesses" array is nil, it assigns a value to that element, sets "stop" to true, and breaks out of the loop. It then reloads the data of a view controller called "boardVC." If the element at the last index of the "guesses" array is not nil, it creates and presents a pop-up view using a UIAlertController. The code also defines a function called "deleteIndexBoardViewController()" that updates the "guesses" array by removing elements. If the element at the last index of the "guesses" array is not nil, it sets that element to nil and reloads the "boardVC" to reflect the change. If the element at the last index is nil, it removes the first nil element in the "guesses" array by setting it to nil. Finally, the "boardVC" is reloaded once again.
        if (guesses[guesses.count-1][guesses[guesses.count-1].count-1] != nil) {
            
            let tempDate = Date().timeIntervalSince1970 - self.enterDate.timeIntervalSince1970
            let temp:Int = Int(tempDate)
            let alertController = UIAlertController(title: "Lose", message: "TIME:\(temp)  COUNT: \(guesses.count)  ANSWER: \(answer)", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                
            }
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func deleteIndexBoardViewController() {
        // Update guesses
        if (guesses[guesses.count-1][guesses[guesses.count-1].count-1] != nil) {
            guesses[guesses.count-1][guesses[guesses.count-1].count-1] = nil
            boardVC.reloadData()
            return;
        }
        var stop = false
        for i in 0..<guesses.count {
            for j in 0..<guesses[i].count {
                if guesses[i][j] == nil {
                    if (j == 0) {
                        guesses[i-1][guesses[i].count - 1] = nil
                    } else {
                        guesses[i][j-1] = nil
                    }
                    stop = true
                    break
                }
            }

            if stop {
                break
            }
        }
        boardVC.reloadData()
    }
}

//* The BoardViewControllerDataSource extension provides data and formatting layout for the guess-grid view. It gives back a list of guess arrays, which determines whether a row of guesses is full, and assigns colours (grey, orange, and green) to cells based on letters in the answer.
extension SecondViewController: BoardViewControllerDatasource {
    var currentGuesses: [[Character?]] {
        return guesses
    }

    func boxColor(at indexPath: IndexPath) -> UIColor? {
        let rowIndex = indexPath.section

        let count = guesses[rowIndex].compactMap({ $0 }).count
        guard count == 5 else {
            return nil
        }

        let indexedAnswer = Array(answer)

        guard let letter = guesses[indexPath.section][indexPath.row],
              indexedAnswer.contains(letter) else {
            return nil
        }

        ///The same code line 144-184, but for when the user wins/gets the answer before the 6 trials
        if indexedAnswer[indexPath.row] == letter {
            self.rightCount += 1
            if (self.rightCount == 5) {
                let tempDate = Date().timeIntervalSince1970 - self.enterDate.timeIntervalSince1970
                let temp:Int = Int(tempDate)
                let alertController = UIAlertController(title: "Victory", message: "TIME:\(temp)  COUNT: \(indexPath.section + 1)  ANSWER: \(answer)", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                }
                alertController.addAction(action)
                present(alertController, animated: true, completion: nil)
            }
            return .systemGreen
        }
        
        self.rightCount = 0
        return .systemOrange
        
    }
}

