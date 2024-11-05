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
    }
        
    private let wishLabel: UILabel = UILabel()
    
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
        let wrap: UIView = UIView()
        addSubview(wrap)
        wrap.backgroundColor = Constants.wrapColor
        wrap.layer.cornerRadius = Constants.wrapRadius
        wrap.pinVertical(self, Constants.wrapOffsetV)
        wrap.pinHorizontal(self, Constants.wrapOffsetH)
        wrap.addSubview(wishLabel)
        wishLabel.pin(wrap, Constants.wishLabelOffset)
    }
}
