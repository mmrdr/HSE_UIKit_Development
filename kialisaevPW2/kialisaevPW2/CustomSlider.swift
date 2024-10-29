//
//  CustomSlider.swift
//  kialisaevPW2
//
//  Created by Кирилл Исаев on 29.10.2024.
//

import UIKit
final class CustomSlider: UIView {
    
    //MARK: Enum(Constants)
    enum Constants {
        static let titleViewTop: CGFloat = 10
        static let titleViewLeading: CGFloat = 20
        static let sliderBottom: CGFloat = 10
        static let sliderLeading: CGFloat = 20
    }
    
    //MARK: Fields
    var valueChanged: ((Double) -> Void)?
    var slider = UISlider()
    var titleView = UILabel()
    
    init(title: String, min: Double, max: Double) {
        super.init(frame: .zero)
        titleView.text = title
        slider.minimumValue = Float(min)
        slider.maximumValue = Float(max)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private methods
    private func configureUI() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        for view in [slider, titleView] {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        titleView.pinCentreX(centerXAnchor)
        titleView.pinTop(topAnchor, Constants.titleViewTop)
        titleView.pinLeft(leadingAnchor, Constants.titleViewLeading)
        slider.pinTop(titleView.bottomAnchor, 0)
        slider.pinCentreX(centerXAnchor)
        slider.pinBottom(bottomAnchor, Constants.sliderBottom)
        slider.pinLeft(leadingAnchor, Constants.sliderLeading)

    }
    
    @objc
    private func sliderValueChanged() {
        valueChanged?(Double(slider.value))
    }
}
