//
//  Keycell.swift
//  StarterProjectMultipleViews
//
//  Created by Ethan Lau on 17/9/2023.
//

//The KeyCell code defines a custom UICollectionViewCell class called KeyCell, which is used to display keyboard keys in a collection view.
//Encapsulates the user interface and logic for displaying a single-letter cell.
//Reuse: The cells can be populated by calling the configure method with letter data.
//By creating a subclass, it separates the cell presentation from the view controller code. After that, call the configure function with letter data to populate the cells.
//KeyCell defines a static identifier property, initialises a UILabel property, and overrides init(frame:) to set up the cell. Adds the label as a subview and adds auto-layout constraints for formatting.
//Overrides prepareForReuse() to reset the label text when the cell is reused. This allows cells to be used efficiently within a UICollectionView to display the keys of an onscreen keyboard interface multiple times.

import UIKit

class KeyCell: UICollectionViewCell {
    static let identifier = "Keycell"

    public let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }

    func configure(with letter: Character) {
        label.text = String(letter).uppercased()
    }
}
