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

    let answers = [
        "later", "bloke", "there", "ultra", "words"
    ]

    var answer = ""
    private var guesses: [[Character?]] = Array(
        repeating: Array(repeating: nil, count: 5),
        count: 6
    )

    let keyboardVC = KeyboardViewController()
    let boardVC = BoardViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        answer = answers.randomElement() ?? "after"
        view.backgroundColor = .black
        addChildren()
    }

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
    }
}

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

        if indexedAnswer[indexPath.row] == letter {
            return .systemGreen
        }
        
        print(answer)

        return .systemOrange
        
    }
}

