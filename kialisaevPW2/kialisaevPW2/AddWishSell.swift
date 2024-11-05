//
//  AddWishSell.swift
//  kialisaevPW2
//
//  Created by Кирилл Исаев on 05.11.2024.
//

import UIKit

class AddWishCell: UITableViewCell, UITextViewDelegate {
    
    static let reuseId: String = "AddWishCell"
    
    enum Constants {
        static let textBorderWidth: CGFloat = 1
        static let textCornerRadius: CGFloat = 10
        static let text: String = "Write your wish here..."
        static let textTop: CGFloat = 10
        static let textLeading: CGFloat = 10
        static let textTrailing: CGFloat = 10
        static let textHeight: CGFloat = 60
        
        static let addWishButtonTitle: String = "Add wish"
        static let addWishButtonCornerRadius: CGFloat = 10
        static let addWishButtonTop: CGFloat = 10
        static let addWishButtonBottom: CGFloat = 10
        static let addWishButtonHeight: CGFloat = 40
        static let addWishButtonWidth: CGFloat = 110
    }
    
    private let wishText: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderColor = UIColor.yellow.cgColor
        textView.layer.borderWidth = Constants.textBorderWidth
        textView.layer.cornerRadius = Constants.textCornerRadius
        textView.text = Constants.text
        textView.textColor = .systemOrange
        return textView
    }()
    
    private let addWishButton: UIButton = {
        let addButton = UIButton(type: .system)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle(Constants.addWishButtonTitle, for: .normal)
        addButton.setTitleColor(.lightGray, for: .normal)
        addButton.backgroundColor = .systemYellow
        addButton.layer.cornerRadius = Constants.addWishButtonCornerRadius
        return addButton
    }()
    
    var addWish: ((String) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String? ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemPink
        selectionStyle = .none
        configureUI()
        wishText.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        configureWishText()
        configureAddWishButton()
    }
    
    private func configureWishText() {
        contentView.addSubview(wishText)
        wishText.backgroundColor = .systemPink
        wishText.pinTop(contentView.topAnchor, Constants.textTop)
        wishText.pinLeft(contentView.leadingAnchor, Constants.textLeading)
        wishText.pinRight(contentView.trailingAnchor, Constants.textTrailing)
        wishText.setHeight(Constants.textHeight)
    }
    
    private func configureAddWishButton() {
        contentView.addSubview(addWishButton)
        addWishButton.pinTop(wishText.bottomAnchor, Constants.addWishButtonTop)
        addWishButton.pinCentreX(contentView.centerXAnchor)
        addWishButton.pinBottom(contentView.bottomAnchor, Constants.addWishButtonBottom)
        addWishButton.setHeight(Constants.addWishButtonHeight)
        addWishButton.setWidth(Constants.addWishButtonWidth)
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed(_:)), for: .touchUpInside)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemOrange {
            textView.text = nil
            textView.textColor = .systemYellow
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.text
            textView.textColor = .systemOrange
        }
    }
    
    @objc private func addWishButtonPressed(_ sender: UIButton) {
        let wishTextView = wishText.text
        if let text = wishTextView, !text.isEmpty, text != Constants.text {
            addWish?(text)
            wishText.textColor = .systemOrange
            wishText.text = Constants.text
            wishText.resignFirstResponder()
        }
    }
}

