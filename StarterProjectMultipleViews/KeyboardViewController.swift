//
//  KeyboardViewController.swift
//  StarterProjectMultipleViews
//
//  Created by Ethan Lau on 17/9/2023.
//

///In the original Wordle game, there is a makeshift keyboard in the bottom section. I won't be using Swift's system keyboard, as I will be creating my own in the view controller.
///The KeyboardViewController communicates the tap events on its keys (on the interface) to a different class serving as its delegate by using the protocol function. The delegate implements logic within the code using the "didTapKey" method or code.
///The KeyboardViewController is a reusable class whose function is that it displays letter keys in a collection view and communicates with another class using the KeyboardViewControllerDelegate protocol. In viewDidLoad(), it configures a UICollectionView to display keys and letters. Splitting letters into rows, storing them in a keys array, and using the array to populate collection view data. The UICollectionViewDelegate in the code handles the touch events on keys (when pressed on the app interface) and notifies the delegate. This separates keyboard logic from the main game/app logic.
///UICollectionViewDelegateFlowLayout -  Handles collection view layouts
///UICollectionViewDelegate -  Handles collection view events
///UICollectionViewDataSource -  Provides data to the collection view
///The KeyboardViewController class provides the data source and delegate methods required to be used by UICollectionView. The KeyboardViewController configures the letter key collection view using the UICollectionViewDataSource and UICollectionViewDelegate methods. The class handles all collection view setup, while the delegate protocol allows the touched keys to be sent and transmitted to the other class. This separates the keyboard view controller from the main app's keyboard use. The interface's logic is held in the KeyboardViewController. Functionality:
///numberOfSections - The number of letter rows
///numberOfItemsInSection - Number of letters in a row
///cellForItemAt - Configures the KeyCell with the letter for that index path
///sizeForItemAt - Calculates the cell size based on the screen's width.
///insetForSectionAt - Calculates the amount of space between each cell.
///didSelectItemAt - handles the cell's or letter(s) tapped and notifies the delegate of the specific key tap.


import UIKit
import SnapKit

protocol KeyboardViewControllerDelegate: AnyObject {
    func keyboardViewController(
        _ vc: KeyboardViewController,
        didTapKey letter: Character
    )
    func deleteIndexBoardViewController()
}

class KeyboardViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    weak var delegate: KeyboardViewControllerDelegate?

    let letters = ["qwertyuiop", "asdfghjkl", "zxcvbnm"]
    private var keys: [[Character]] = []
    

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        let collectionVIew = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionVIew.translatesAutoresizingMaskIntoConstraints = false
        collectionVIew.backgroundColor = .clear
        collectionVIew.register(KeyCell.self, forCellWithReuseIdentifier: KeyCell.identifier)
        return collectionVIew
    }()

    ///delete button
    var deleteButton: UIButton = UIButton.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.setupUI()

        for row in letters {
            let chars = Array(row)
            keys.append(chars)
        }
    }
    
    ///The `setupUI()` function is responsible for setting up the user interface (UI) elements for a Wordle delete button in a view controller. Within this function, several steps are taken to configure the UI components. First, a collection view is added as a subview to the main view, followed by setting up constraints using the SnapKit library. Next, a delete button is added as a subview, and its constraints are defined using SnapKit as well, specifying its width, position, and alignment relative to other UI elements. The delete button is given a corner radius of 5, a purple background color, and the title "DELETE" for the normal state. Additionally, a target-action is set up so that when the delete button is tapped, it triggers the `deleButtonOnClick()` method. This method prints a message to the console and calls the `deleteIndexBoardViewController()` method on the delegate.

    ///This code ensures that the Wordle delete button is properly set up and functional within the view controller's UI.

    func setupUI() {
        self.view .addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.width)
            make.top.equalTo(self.view.snp.top)
            make.bottom.equalTo(self.view.snp.bottom).offset(-60);
        }
        self.view.addSubview(self.deleteButton)
        self.deleteButton.snp.makeConstraints({ make in
            make.width.equalTo(self.view.frame.width)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(self.collectionView.snp.bottom).offset(2)
            make.bottom.equalTo(self.view.snp.bottom).offset(-1)
        })
        self.deleteButton.layer.cornerRadius = 5
        self.deleteButton.backgroundColor = UIColor.purple
        self.deleteButton.setTitle("DELETE", for: .normal)
        self.deleteButton.addTarget(self, action: #selector(deleButtonOnClick), for: .touchUpInside)
    }
    
    @objc private func deleButtonOnClick() {
        print("deleButtonOnClick")
        delegate?.deleteIndexBoardViewController()
    }
}

extension KeyboardViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return keys.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCell.identifier, for: indexPath) as? KeyCell else {
            fatalError()
        }
        let letter = keys[indexPath.section][indexPath.row]
        cell.configure(with: letter)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let margin: CGFloat = 20
        let size: CGFloat = (collectionView.frame.size.width-margin)/10

        return CGSize(width: size, height: size*1.5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        var left: CGFloat = 1
        var right: CGFloat = 1

        let margin: CGFloat = 20
        let size: CGFloat = (collectionView.frame.size.width-margin)/10
        let count: CGFloat = CGFloat(collectionView.numberOfItems(inSection: section))

        let inset: CGFloat = (collectionView.frame.size.width - (size * count) - (2 * count))/2

        left = inset
        right = inset

        return UIEdgeInsets(
            top: 2,
            left: left,
            bottom: 2,
            right: right
        )
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let letter = keys[indexPath.section][indexPath.row]
        delegate?.keyboardViewController(self,
                                         didTapKey: letter)
    }
}

