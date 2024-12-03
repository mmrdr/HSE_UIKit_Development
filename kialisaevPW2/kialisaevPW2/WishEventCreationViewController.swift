//
//  WishEventCreationView.swift
//  kialisaevPW2
//
//  Created by Кирилл Исаев on 03.12.2024.
//

// HW4
import UIKit
import Foundation

//MARK: - Protocols
protocol WishEventCreationDelegate: AnyObject {
    func didSetEvent(_ event: CalendarEventModel)
}

class WishEventCreationViewController: UIViewController {
    //MARK: - Constants
    enum Constants {
        static let stackViewSpacing: CGFloat = 16
        static let stackViewTop: CGFloat = 200
        static let stackViewHorizontal: CGFloat = 20
        
        static let titleLabelPlaceholder: String = "Enter event's name"
        static let titleLabelCornerRadius: CGFloat = 15
        static let titleLabelBorderWidth: CGFloat = 1
        static let titleLabelHeight: CGFloat = 48
        static let titlePaddingViewWidth: CGFloat = 10
        
        static let descriptionLabelPlaceholder: String = "Enter event's description"
        static let descriptionLabelCornerRadius: CGFloat = 15
        static let descriptionLabelBorderWidth: CGFloat = 1
        static let descriptionLabelHeight: CGFloat = 48
        static let descriptionPaddingViewWidth: CGFloat = 10
        
        static let saveButtonHeight: CGFloat = 48
        static let saveButtonWidth: CGFloat = 200
        static let saveButtonBottom: CGFloat = 10
        static let saveButtonCornerRadius: CGFloat = 15
    }
    
    //MARK: - Variables
    private let calendarManager: CalendarEventManager = CalendarManager()
    weak var delegate: WishEventCreationDelegate?
    
    private let titleField = UITextField()
    private let descriptionField = UITextField()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let saveButton = UIButton(type: .system)
    private var stackView: UIStackView = UIStackView()
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        configureUI()
    }
    
    //MARK: - Private methods
    private func configureUI() {
        configureStackView()
        configureSaveButton()
    }
    
    private func configureStackView() {
        configureTitleField()
        configureDescriptionField()
        configureStartDatePicker()
        configureEndDatePicker()
        
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.spacing = Constants.stackViewSpacing
        
        for el in [titleField, descriptionField, startDatePicker, endDatePicker] {
            stackView.addArrangedSubview(el)
        }
        
        stackView.pinTop(view.topAnchor, Constants.stackViewTop)
        stackView.pinHorizontal(view, Constants.stackViewHorizontal)
    }
        
    private func configureTitleField() {
        view.addSubview(titleField)
        titleField.placeholder = Constants.titleLabelPlaceholder
        titleField.layer.cornerRadius = Constants.titleLabelCornerRadius
        titleField.layer.borderWidth = Constants.titleLabelBorderWidth
        titleField.layer.borderColor = UIColor.systemGray3.cgColor
        titleField.textColor = .black
        titleField.setHeight(Constants.titleLabelHeight)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.titlePaddingViewWidth, height: titleField.frame.height))
        titleField.leftView = paddingView
        titleField.leftViewMode = .always
    }
    
    private func configureDescriptionField() {
        view.addSubview(descriptionField)
        descriptionField.placeholder = Constants.descriptionLabelPlaceholder
        descriptionField.layer.cornerRadius = Constants.descriptionLabelCornerRadius
        descriptionField.layer.borderWidth = Constants.descriptionLabelBorderWidth
        descriptionField.layer.borderColor = UIColor.systemGray3.cgColor
        descriptionField.textColor = .black
        descriptionField.setHeight(Constants.descriptionLabelHeight)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.descriptionPaddingViewWidth, height: descriptionField.frame.height))
        descriptionField.leftView = paddingView
        descriptionField.leftViewMode = .always
    }
    
    private func configureStartDatePicker() {
        view.addSubview(startDatePicker)
        startDatePicker.datePickerMode = .dateAndTime
    }
    
    private func configureEndDatePicker() {
        view.addSubview(endDatePicker)
        endDatePicker.datePickerMode = .dateAndTime
        
    }
    
    private func configureSaveButton() {
        view.addSubview(saveButton)
        saveButton.setTitle("Save event", for: .normal)
        saveButton.setHeight(Constants.saveButtonHeight)
        saveButton.setWidth(Constants.saveButtonWidth)
        saveButton.pinBottom(view.safeAreaLayoutGuide.bottomAnchor, Constants.saveButtonBottom)
        saveButton.pinCentreX(view)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = Constants.saveButtonCornerRadius
        saveButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
    }
    
    
    //MARK: - Objc methods
    @objc
    private func saveButtonPressed(_ sender: UIButton) {
        guard let title = titleField.text, !title.isEmpty,
              let description = descriptionField.text, !description.isEmpty else {
            return
        }
        
        let event = CalendarEventModel(
            title: title,
            description: description,
            startDate: startDatePicker.date,
            endDate: endDatePicker.date,
            note: nil
        )
        
        if calendarManager.create(eventModel: event) {
            delegate?.didSetEvent(event)
            dismiss(animated: true, completion: nil)
        } else {
        }
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}
