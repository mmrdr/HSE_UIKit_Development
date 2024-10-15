//
//  ViewController.swift
//  kialisaevPW1
//
//  Created by Кирилл Исаев on 14.10.2024.
//

import UIKit

final class ViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet var views: [UIView]!
    @IBOutlet weak var animateButton: UIButton!
    
    //MARK: - Consts
    //Все магические числа здесь
    let switchButton: UISwitch = UISwitch()
    let dontTouchMeButton: UIButton = UIButton(type: .system)
    let animationTime: Double = 0.52
    let viewSize: Double = 100
    let sizeBetweenViews: Double = 140
    let switchButtonPosition: Double = 50
    
    //MARK: - Variables
    var uniqueColors: [UIColor] = []
    
    // MARK: - Lyfecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(switchButton)
        view.addSubview(animateButton)
        for v in views {
            view.addSubview(v)
        }
        setupSwitchButton(switchButton)
        setupAnimateButton(animateButton)
        setupViews(views)
    }
    
    //MARK: - Actions
    @IBAction func animateButtonPressed(_ sender: UIButton) {
        uniqueColors = getUniqueColors(count: 3)
        sender.isUserInteractionEnabled = false // Запораживаем кнопку.
        sender.alpha = 0.5 // Делаем более прозрачной на время заморозки.
        for (index, view) in views.enumerated() {
            buttonAnimation(view, uniqueColors[index])
        }
        // Через время = времени анимации делаем доступ к нажатию на кнопку, а также увеличиваем параметр alpha.
        DispatchQueue.main.asyncAfter(deadline: .now() + animationTime) {
            sender.isUserInteractionEnabled = true
            sender.alpha = 1
        }
    }
    
    @objc func switchButtonPressed(_ sender: UISwitch) {
        uniqueColors = getUniqueColors(count: 3)
        if sender.isOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + animationTime) { // Ждем пока закончится анимация свитч
                self.switchButton.pinTop(self.view, self.switchButtonPosition) // После перетаскиваем ее на
                self.switchButton.pinLeft(self.view, self.switchButtonPosition) // switchButtonPosition
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + animationTime) { // Параллельно с этим процессом ждем
                self.animateButton.isHidden = false                           // animationTime, чтобы показать все view
                for (index, view) in self.views.enumerated() {                // и кнопку
                    view.isHidden = false
                    self.buttonAnimation(view, self.uniqueColors[index])
                }
            }
        } else {
            for view in views {
                view.isHidden = true // Прячем все view
            }
            animateButton.isHidden = true // Прячем кнопку
        }
    }
    
    //MARK: - Methods
    func getUniqueColors(count: Int) -> [UIColor] {
        var uniqueColors = Set<UIColor>()
        while uniqueColors.count < count {
            let randomColor = UIColor.random() // Cool?
            uniqueColors.insert(randomColor)
        }
        return Array(uniqueColors)
    }
    
    func setRandomCornerRadius(view: UIView) {
        view.layer.cornerRadius = .random(in: (0...50))
    }
    
    //MARK: - Animation Method
    func buttonAnimation(_ view: UIView, _ color: UIColor) {
        UIView.animate(withDuration: animationTime, animations: {view.backgroundColor = color // Главная анимация наших view
            self.setRandomCornerRadius(view: view)})
    }
    
    //MARK: - Setup Methods
    func setupSwitchButton(_ button: UISwitch) {
        button.addTarget(self, action: #selector(switchButtonPressed(_:)), for: .valueChanged) // Связываем button с объектом
        button.pinCentre(view)                                                                 // который будет обрабатывать
    }                                                                                          // событие. При возникновении
                                                                        // события будет вызван метод switchButtonPressed
    func setupAnimateButton(_ button: UIButton) {
        button.pinCentreX(view)
        button.pinCentreY(view.topAnchor, 200)
        button.setTitle("Нажми", for: .normal)
        button.isHidden = true
    }
    
    func setupViews(_ views: [UIView]) {
        uniqueColors = getUniqueColors(count: 3) // Создаем 3 уникальных рандомных цвета при настройке кнопок
        var i = sizeBetweenViews
        for (index, v) in views.enumerated() {
            v.pinCentreX(view)
            v.pinCentreY(animateButton, i)
            v.setWidth(viewSize)
            v.setHeight(viewSize)
            v.backgroundColor = uniqueColors[index]
            v.isHidden = true
            i = i + sizeBetweenViews
        }
    }
}

