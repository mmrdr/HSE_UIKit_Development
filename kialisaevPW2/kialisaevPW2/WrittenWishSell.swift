//
//  WrittenWIshSell.swift
//  kialisaevPW2
//
//  Created by Кирилл Исаев on 05.11.2024.
//

import UIKit
final class WrittenWishCell: UITableViewCell {
    
    static let reuseId: String = "WrittenWishCell"
    
    private enum Constants {
        static let wrapColor: UIColor = .white
        static let wrapRadius: CGFloat = 16
        static let wrapOffsetV: CGFloat = 10
        static let wrapOffsetH: CGFloat = 10
        static let wishLabelOffset: CGFloat = 20
        static let ofSize: CGFloat = 16
    }
        
    private let wishLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: Constants.ofSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let wrap: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.wrapColor
        view.layer.cornerRadius = Constants.wrapRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with wish: String) {
        wishLabel.text = wish
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(wrap)
        wrap.addSubview(wishLabel)
        wrap.pinTop(contentView.topAnchor, Constants.wrapOffsetV)
        wrap.pinBottom(contentView.bottomAnchor, Constants.wrapOffsetV)
        wrap.pinLeft(contentView.leadingAnchor, Constants.wrapOffsetH)
        wrap.pinRight(contentView.trailingAnchor, Constants.wrapOffsetH)
        
        wishLabel.pinTop(contentView.topAnchor, Constants.wishLabelOffset)
        wishLabel.pinBottom(contentView.bottomAnchor, Constants.wishLabelOffset)
        wishLabel.pinLeft(contentView.leadingAnchor, Constants.wishLabelOffset)
        wishLabel.pinRight(contentView.trailingAnchor, Constants.wishLabelOffset)
    }
}
