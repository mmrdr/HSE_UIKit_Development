//
//  WishMakerViewController.swift
//  kialisaevPW2
//
//  Created by Кирилл Исаев on 29.10.2024.
//

import UIKit

final class WishMakerViewController : UIViewController {
    
    // MARK: Enum(Constants)
    enum Constants {
        static let sliderMin: Double = 0
        static let sliderMax: Double = 1
        
        static let red: String = "Red"
        static let green: String = "Green"
        static let blue: String = "Blue"
        
        static let titleFontSize: CGFloat = 30
        static let titleTop: CGFloat = 30
        
        static let descriptionFontSize: CGFloat = 16
        static let descriptionLeading: CGFloat = 10
        static let descriptionTrailing: CGFloat = 10
        static let descriptionTop: CGFloat = 20
        
        static let addWishButtonHeight: CGFloat = 50
        static let addWishButtonWidth: CGFloat = 30
        static let addWishButtonBottom: CGFloat = 60
        static let addWishButtonHorizontal: CGFloat = 20
        static let addWishButtonTitle: String = "Add wish"
        static let addWishButtonCornerRadius: CGFloat = 20
        
        // HW 4
        static let scheduleWishesButtonHeight: CGFloat = 50
        static let scheduleWishesButtonWidth: CGFloat = 30
        static let scheduleWishesButtonBottom: CGFloat = 10
        static let scheduleWishesButtonHorizontal: CGFloat = 20
        static let scheduleWishesButtonTitle: String = "Schedule wish granting"
        static let scheduleWishesButtonCornerRadius: CGFloat = 20
        
        // HW 4
        static let actionStackSpacing: CGFloat = 15
        
        static let stackRadius: CGFloat = 20
        static let stackBottom: CGFloat = 10
        static let stackLeading: CGFloat = 20
        
        static let switchButtonTop: CGFloat = 30
        static let switchButtonTrailing: CGFloat = 30
        
        static let animationTime: CGFloat = 0.5
    }
    
    // MARK: Fields
    private let switchButton = UISwitch()
    private let greetingText = UILabel()
    private var addWishButton: UIButton = UIButton(type: .system)
    private var scheduleWishesButton: UIButton = UIButton(type: .system) // HW4
    private let actionStack: UIStackView = UIStackView() // HW4
    
    private var sliders: [CustomSlider] = [
        CustomSlider(title: Constants.red, min: Constants.sliderMin, max: Constants.sliderMax),
        CustomSlider(title: Constants.green, min: Constants.sliderMin, max: Constants.sliderMax),
        CustomSlider(title: Constants.blue, min: Constants.sliderMin, max: Constants.sliderMax)
    ]
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: Private methods
    private func configureUI() {
        view.backgroundColor = UIColor.random()
        configureTitle()
        configureSwitchButton()
        configureDescription()
        configureActionStack() // HW4
        configureSliders()
    }
    
    private func configureTitle() {
        let title = UILabel()
        let text = "Introducing"
        let attributedString = NSMutableAttributedString(string: text)
        for (i, _) in text.enumerated() {
            let color = UIColor.random()
            attributedString.addAttribute(.foregroundColor, value: color, range: NSRange(location: i, length: 1))
        }
        title.attributedText = attributedString
        title.font = UIFont.systemFont(ofSize: Constants.titleFontSize)
        view.addSubview(title)
        title.pinCentreX(view.centerXAnchor)
        title.pinTop(view.safeAreaLayoutGuide.topAnchor, Constants.titleTop)
    }
    
    private func configureDescription() {
        let description = UILabel()
        description.text = """
            This is a description of the PW2 and PW3 homework. In the process, I learned how to: \
            delete the Storyboard (I will never use it again), create my own custom sliders and customize them.
            Also, I learned how to do beauty wish maker. If u press "Add Wish" button you can test it.
            If you want to deleat wish - drag it to the left edge.
            If you want to edit wish - click on it.
            """
        description.font = UIFont.systemFont(ofSize: Constants.descriptionFontSize)
        description.numberOfLines = 0;
        description.lineBreakMode = .byWordWrapping
        description.textColor = .darkGray
        view.addSubview(description)
        description.pinLeft(view.safeAreaLayoutGuide.leadingAnchor, Constants.descriptionLeading)
        description.pinRight(view.safeAreaLayoutGuide.trailingAnchor, Constants.descriptionTrailing)
        description.pinTop(view.subviews[0].bottomAnchor, Constants.descriptionTop)
    }
    
    private func configureAddWishButton() {
        view.addSubview(addWishButton)
        addWishButton.setHeight(Constants.addWishButtonHeight)
        addWishButton.pinBottom(view.safeAreaLayoutGuide.bottomAnchor, Constants.addWishButtonBottom)
        addWishButton.pinHorizontal(view, Constants.addWishButtonHorizontal)
        
        addWishButton.backgroundColor = .white
        addWishButton.setTitleColor(.systemPink, for: .normal)
        addWishButton.setTitle(Constants.addWishButtonTitle, for: .normal)
        
        addWishButton.layer.cornerRadius = Constants.addWishButtonCornerRadius
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed(_:)), for: .touchUpInside)
    }
    // HW4 method
    private func configureScheduleWishesButton() {
        view.addSubview(scheduleWishesButton)
        scheduleWishesButton.setHeight(Constants.scheduleWishesButtonHeight)
        scheduleWishesButton.pinTop(addWishButton.bottomAnchor, Constants.scheduleWishesButtonBottom)
        scheduleWishesButton.pinHorizontal(view, Constants.scheduleWishesButtonHorizontal)
        
        scheduleWishesButton.backgroundColor = .white
        scheduleWishesButton.setTitleColor(.systemPink, for: .normal)
        scheduleWishesButton.setTitle(Constants.scheduleWishesButtonTitle, for: .normal)
        
        scheduleWishesButton.layer.cornerRadius = Constants.scheduleWishesButtonCornerRadius
        scheduleWishesButton.addTarget(self, action: #selector(scheduleWishesButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func configureSliders() {
        let stack = UIStackView()
        stack.axis = .vertical
        view.addSubview(stack)
        stack.layer.cornerRadius = Constants.stackRadius
        stack.clipsToBounds = true
        let array = [addWishButton, scheduleWishesButton]
        for slider in sliders {
            stack.addArrangedSubview(slider)
            slider.valueChanged = { [weak self] _ in
                self?.updateBackgroundColor(array: array)
            }
        }
        stack.pinCentreX(view.centerXAnchor)
        stack.pinLeft(view.safeAreaLayoutGuide.leadingAnchor, Constants.stackLeading)
        stack.pinBottom(addWishButton.topAnchor, Constants.stackBottom)
    }
    
    private func configureSwitchButton() {
        view.addSubview(switchButton)
        switchButton.isOn = true
        switchButton.pinTop(view.safeAreaLayoutGuide.topAnchor, Constants.switchButtonTop)
        switchButton.pinRight(view.safeAreaLayoutGuide.trailingAnchor, Constants.switchButtonTrailing)
        switchButton.addTarget(self, action: #selector(switchButtonPressed(_:)), for: .valueChanged)
        
    }
    // HW4 Method
    private func configureActionStack() {
        actionStack.axis = .vertical
        view.addSubview(actionStack)
        actionStack.spacing = Constants.actionStackSpacing
        
        for button in [addWishButton, scheduleWishesButton] {
            actionStack.addArrangedSubview(button)
        }
        
        configureAddWishButton()
        configureScheduleWishesButton()
        
        actionStack.pinBottom(view, 80)
        actionStack.pinHorizontal(view, Constants.stackLeading)
    }
    
    private func updateBackgroundColor(array : [UIButton]) {
        let redValue = CGFloat(sliders[0].slider.value)
        let greenValue = CGFloat(sliders[1].slider.value)
        let blueValue = CGFloat(sliders[2].slider.value)
        let newColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
        UIView.animate(withDuration: Constants.animationTime) {
            self.view.backgroundColor = newColor
            // Change color for buttons(HW4)
            for el in array {
                el.setTitleColor(newColor, for: .normal)
            }
        }
    }
    
    @objc private func switchButtonPressed(_ sender: UISwitch) {
        if sender.isOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.animationTime) {
                self.view.subviews[3].isHidden = false
            }
        } else {
            self.view.subviews[3].isHidden = true
        }
    }
    
    @objc
    private func addWishButtonPressed(_ sender: UIButton) {
        present(WishStoringViewController(), animated: true)
    }
    
    // HW 4
    @objc
    private func scheduleWishesButtonPressed(_ sender: UIButton) {
        let wishCalendarVS = WishCalendarViewController()
        navigationController?.pushViewController(wishCalendarVS, animated: true)
    }
}
