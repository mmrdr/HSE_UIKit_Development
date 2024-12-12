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
        
        static let chooseButtonTop: CGFloat = 10
        
        static let pickerCornerRadius: CGFloat = 15
        static let pickerNumberOfComponents: Int = 1
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
    private let chooseButton: UIButton = UIButton(type: .system)
    var pickerView: UIPickerView = UIPickerView()
    var pickerData: [String] = WishStoringViewController.shared.getUserDefauts()
    
    var backgroundColor: UIColor?
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor ?? .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        configureUI()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: - Private methods
    private func configureUI() {
        configureStackView()
        configureSaveButton()
        configureChooseButton()
        configurePickerView()
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
    
    private func configureChooseButton() {
        view.addSubview(chooseButton)
        chooseButton.setTitle("Choose from existing", for: .normal)
        chooseButton.setTitleColor(.white, for: .normal)
        chooseButton.pinTop(stackView.bottomAnchor, Constants.chooseButtonTop)
        chooseButton.pinCentreX(view)
        chooseButton.setHeight(Constants.saveButtonHeight)
        chooseButton.setWidth(Constants.saveButtonWidth)
        chooseButton.backgroundColor = .systemBlue
        chooseButton.layer.cornerRadius = Constants.saveButtonCornerRadius
        chooseButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
    }
    
    private func configurePickerView() {
        view.addSubview(pickerView)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.isHidden = true
        pickerView.backgroundColor = .white
        pickerView.layer.cornerRadius = Constants.pickerCornerRadius
        pickerView.pinCentre(view)
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
    private func showPicker() {
        pickerView.isHidden = false
        view.bringSubviewToFront(pickerView)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension WishEventCreationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Constants.pickerNumberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerData.indices.contains(row) {
            titleField.text = pickerData[row]
            pickerView.isHidden = true
        }
    }
}
