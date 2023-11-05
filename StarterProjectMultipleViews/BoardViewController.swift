//
//  BoardViewController.swift
//  StarterProjectMultipleViews
//
//  Created by Ethan Lau on 17/9/2023.
//

///The "BoardViewControllerDatasource" protocol provides the interface that the data source classes need to follow to supply appropriate data and behaviours to the BoardViewController.
///The purpose of the "BoardViewController: UIViewController" class is to present data from an external data source through a collection view. Its purpose as the collection view's controller and connects the view to the data source protocol described elsewhere. This allows data to be separated from the display logic.
///Defines a BoardViewController that will manage UICollectionView
///Sets itself (the class) as the collection view's delegate and data source.
///Contains an initialised and configured collection view property.
///Reference to an external BoardViewControllerDatasource
///Lays out the collection view in "viewDidLoad."
///Exposes a method to reload the collection view data.
///The extension block of code implements the collection view data source and delegate methods required to display and use the data supplied by the external BoardViewControllerDatasource protocol. Connects the view controller's collection and view functionality to a separate data source.


import UIKit

protocol BoardViewControllerDatasource: AnyObject {
    var currentGuesses: [[Character?]] { get }
    func boxColor(at indexPath: IndexPath) -> UIColor?
}

class BoardViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    weak var datasource: BoardViewControllerDatasource?

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        let collectionVIew = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionVIew.translatesAutoresizingMaskIntoConstraints = false
        collectionVIew.backgroundColor = .clear
        collectionVIew.register(KeyCell.self, forCellWithReuseIdentifier: KeyCell.identifier)
        return collectionVIew
    }()
    
    //var alertView : UIAlertView = UIAlertView()
    var submitButton: UIButton = UIButton.init()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.setupUI()
    }
    
    func setupUI() {
        self.view .addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.width)
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
            make.top.equalTo(self.view.snp.top).offset(80)
            make.bottom.equalTo(self.view.snp.bottom).offset(30)
        }
    }

    public func reloadData() {
        collectionView.reloadData()
    }
}

extension BoardViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource?.currentGuesses.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let guesses = datasource?.currentGuesses ?? []
        return guesses[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCell.identifier, for: indexPath) as? KeyCell else {
            fatalError()
        }

        cell.backgroundColor = datasource?.boxColor(at: indexPath)
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.systemGray3.cgColor
        cell.label.textColor = .white

        let guesses = datasource?.currentGuesses ?? []
        if let letter = guesses[indexPath.section][indexPath.row] {
            cell.configure(with: letter)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let margin: CGFloat = 20
        let size: CGFloat = (collectionView.frame.size.width-margin)/5

        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(
            top: 2,
            left: 2,
            bottom: 2,
            right: 2
        )
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
}
