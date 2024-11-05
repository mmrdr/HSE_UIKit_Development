//
//  AddWishSell.swift
//  kialisaevPW2
//
//  Created by Кирилл Исаев on 05.11.2024.
//

import UIKit

class AddWishCell: UITableViewCell, UITextViewDelegate {
    
    static let reuseId: String = "AddWishCell"
    
    private let wishText: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        textView.text = "Write your wish here..."
        textView.textColor = .lightGray
        return textView
    }()
    
    private let addWishButton: UIButton = {
        let addButton = UIButton(type: .system)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("Add wish", for: .normal)
        addButton.setTitleColor(.lightGray, for: .normal)
        addButton.backgroundColor = .systemYellow
        addButton.layer.cornerRadius = 10
        return addButton
    }()
    
    var addWish: ((String) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String? ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        wishText.pinTop(contentView.topAnchor, 10)
        wishText.pinLeft(contentView.leadingAnchor, 10)
        wishText.pinRight(contentView.trailingAnchor, 10)
        wishText.setHeight(60)
    }
    
    private func configureAddWishButton() {
        contentView.addSubview(addWishButton)
        addWishButton.pinTop(wishText.bottomAnchor, 10)
        addWishButton.pinCentreX(contentView.centerXAnchor)
        addWishButton.pinBottom(contentView.bottomAnchor, 10)
        addWishButton.setHeight(40)
        addWishButton.setWidth(110)
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed(_:)), for: .touchUpInside)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write your wish here..."
            textView.textColor = .lightGray
        }
    }
    
    @objc private func addWishButtonPressed(_ sender: UIButton) {
        let wishTextView = wishText.text
        if let text = wishTextView, !text.isEmpty, text != "Write your wish here..." {
            addWish?(text)
            wishText.textColor = .lightGray
            wishText.text = "Write your wish here..."
            wishText.resignFirstResponder()
        }
    }
}

