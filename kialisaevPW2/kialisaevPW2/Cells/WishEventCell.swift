//
//  WishEventCell.swift
//  kialisaevPW2
//
//  Created by Кирилл Исаев on 03.12.2024.
//

// HW4
import UIKit
import Foundation
//MARK: - Protocols
protocol WishEventCellDelegate: AnyObject {
    func didPressCheckBox(cell: WishEventCell)
}

class WishEventCell: UICollectionViewCell {
    //MARK: - Constants
    enum Constants {
        static let reuseIdentifier: String = "WishEventCell"
        
        static let wrapCornerRadius: CGFloat = 15
        static let wrapTop: CGFloat = 8
        static let wrapBottom: CGFloat = 8
        static let wrapLeading: CGFloat = 8
        static let wrapTrailing: CGFloat = 8
        
        static let checkBoxImageSystemName: String = "square"
        static let checkBoxPressedImageSystemName: String = "checkmark.square"
        static let checkBoxHeight: CGFloat = 24
        static let checkBoxWidth: CGFloat = 24
        static let checkBoxTrailing: CGFloat = 10
        
        static let titleFontOfSize: CGFloat = 16
        static let titleNumberOfLines: Int = 1
        static let titleTop: CGFloat = 16
        
        static let descriptionFontOfSize: CGFloat = 14
        static let descriptionNumberOfLines: Int = 1
        static let descriptionTop: CGFloat = 16
        static let descriptionLeading: CGFloat = 14
        
        static let dateFontOfSet: CGFloat = 12
        static let dateTop: CGFloat = 16
        static let dateLeading: CGFloat = 12
        
        static let endDateBottom: CGFloat = 16
        
        static let transitionDuration: CGFloat = 0.3
        
    }

    //MARK: - Variables
    weak var delegate: WishEventCellDelegate?
    
    private let wrapView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let startDateLabel: UILabel = UILabel()
    private let endDateLabel: UILabel = UILabel()
    
    private let checkBoxButton: UIButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureWrapView()
        configureCheckBoxButton()
        configureTitleLabel()
        configureDescriptionLabel()
        configureStartDateLabel()
        configureEndDateLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func configureWrapView() {
        contentView.addSubview(wrapView)
        wrapView.backgroundColor = UIColor.systemGray6
        wrapView.layer.cornerRadius = Constants.wrapCornerRadius
        wrapView.pinTop(contentView.topAnchor, Constants.wrapTop)
        wrapView.pinLeft(contentView.leadingAnchor, Constants.wrapLeading)
        wrapView.pinRight(contentView.trailingAnchor, Constants.wrapTrailing)
        wrapView.pinBottom(contentView.bottomAnchor, Constants.wrapBottom)
    }
    
    private func configureCheckBoxButton() {
        wrapView.addSubview(checkBoxButton)
        checkBoxButton.contentVerticalAlignment = .fill
        checkBoxButton.contentHorizontalAlignment = .fill
        checkBoxButton.setImage(UIImage(systemName: Constants.checkBoxImageSystemName), for: .normal)
        checkBoxButton.tintColor = .systemBlue
        checkBoxButton.setHeight(Constants.checkBoxHeight)
        checkBoxButton.setWidth(Constants.checkBoxWidth)
        checkBoxButton.pinCentreY(contentView)
        checkBoxButton.pinRight(wrapView.trailingAnchor, Constants.checkBoxTrailing)
        
        checkBoxButton.addTarget(self, action: #selector(checkBoxPressed(_:)), for: .touchUpInside)
    }
    
    private func configureTitleLabel() {
        wrapView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: Constants.titleFontOfSize, weight: .semibold)
        titleLabel.textColor = UIColor.label
        titleLabel.numberOfLines = Constants.titleNumberOfLines
        
        titleLabel.pinTop(wrapView.topAnchor, Constants.titleTop)
        titleLabel.pinCentreX(contentView)
    }
    
    private func configureDescriptionLabel() {
        wrapView.addSubview(descriptionLabel)
        descriptionLabel.font = UIFont.systemFont(ofSize: Constants.descriptionFontOfSize, weight: .regular)
        descriptionLabel.textColor = UIColor.secondaryLabel
        descriptionLabel.numberOfLines = Constants.descriptionNumberOfLines
        
        descriptionLabel.pinTop(titleLabel.bottomAnchor, Constants.descriptionTop)
        descriptionLabel.pinLeft(wrapView.leadingAnchor, Constants.descriptionLeading)
    }
    
    private func configureStartDateLabel() {
        wrapView.addSubview(startDateLabel)
        startDateLabel.font = UIFont.systemFont(ofSize: Constants.dateFontOfSet, weight: .regular)
        startDateLabel.textColor = UIColor.secondaryLabel
        
        startDateLabel.pinTop(descriptionLabel.bottomAnchor, Constants.dateTop)
        startDateLabel.pinLeft(wrapView.leadingAnchor, Constants.dateLeading)
    }
    
    private func configureEndDateLabel() {
        wrapView.addSubview(endDateLabel)
        endDateLabel.font = UIFont.systemFont(ofSize: Constants.dateFontOfSet, weight: .regular)
        endDateLabel.textColor = UIColor.secondaryLabel
        
        endDateLabel.pinTop(startDateLabel.bottomAnchor, Constants.dateTop)
        endDateLabel.pinLeft(wrapView.leadingAnchor, Constants.dateLeading)
        endDateLabel.pinBottom(wrapView.bottomAnchor, Constants.endDateBottom)
    }
    
    // MARK: - Public methods
    func configure(with event: CalendarEventModel) {
        titleLabel.text = event.title
        descriptionLabel.text = event.description
        startDateLabel.text = "Start Date: \(event.startDate)"
        endDateLabel.text = "End Date: \(event.endDate)"
    }
    
    //MARK: - Objc methods
    @objc
    private func checkBoxPressed(_ sender: UIButton) {
        let newImageName: String
        if checkBoxButton.image(for: .normal) == UIImage(systemName: Constants.checkBoxPressedImageSystemName) {
            newImageName = Constants.checkBoxImageSystemName
        } else {
            newImageName = Constants.checkBoxPressedImageSystemName
        }
        UIView.transition(with: checkBoxButton, duration: Constants.transitionDuration, options: .transitionFlipFromTop, animations: {
            self.checkBoxButton.setImage(UIImage(systemName: newImageName), for: .normal)
        }, completion: nil)
        
        delegate?.didPressCheckBox(cell: self)
    }
}
