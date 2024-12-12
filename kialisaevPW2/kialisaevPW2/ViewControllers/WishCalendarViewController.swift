//
//  WishCalendarViewController.swift
//  kialisaevPW2
//
//  Created by Кирилл Исаев on 03.12.2024.
//
import UIKit
import Foundation
// HW4
class WishCalendarViewController: UIViewController, UICollectionViewDelegate, WishEventCellDelegate {
    //MARK: - Constants
    enum Constants {
        static let backButtonSystemName: String = "chevron.left"
        static let plusButtonSystemName: String = "plus.circle"
        
        static let saveEventKey: String = "savedEvents"
        
        static let collectionEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60)
        static let collectionBottom: CGFloat = 15
        static let collectionTop: CGFloat = 15
        static let collectionHeight: CGFloat = 200
        static let minusToCollectionWidth: CGFloat = 40
    }

    //MARK: - Variables
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var events: [CalendarEventModel] = []
    private let defaults = UserDefaults.standard
    var backgroundColor: UIColor?
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor ?? .white
        let backButton = UIBarButtonItem(image: UIImage(systemName: Constants.backButtonSystemName), style: .plain, target: self, action: #selector(backButtonPressed(_:)))
        let plusButton = UIBarButtonItem(image: UIImage(systemName: Constants.plusButtonSystemName), style: .plain, target: self, action: #selector(plusButtonPressed(_:)))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = plusButton
        loadWishes()
        configureCollectionView()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    // Пожалуй, самое лютое решение в этом дз. Не разобрался в CoreData для сохранения events(да и wishes)
    // поэтому пришлось использовать userDefaults. Столкнулся с проблемой что UserDefaults может работать
    // только с базовыми классами из Swift, поэтому приходится сериализовывать и десериализовывать в json
    // конвертировать в какой-нибудь базовый класс, по типу Dictionary не хотел
    //MARK: - Private methods
    private func loadWishes() {
        if let data = defaults.data(forKey: Constants.saveEventKey),
           let savedWishes = try? JSONDecoder().decode([CalendarEventModel].self, from: data) {
            events = savedWishes
        }
    }
    
    private func saveWishes() {
        if let data = try? JSONEncoder().encode(events) {
            defaults.set(data, forKey: Constants.saveEventKey)
        }
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.contentInset = Constants.collectionEdgeInsets
        
        if let layout = collectionView.collectionViewLayout as?
            UICollectionViewFlowLayout {
                layout.minimumInteritemSpacing = 0
                layout.minimumLineSpacing = 0
                layout.invalidateLayout()
            }
        
        collectionView.register(WishEventCell.self, forCellWithReuseIdentifier: WishEventCell.Constants.reuseIdentifier)
        
        collectionView.pinHorizontal(view)
        collectionView.pinBottom(view.safeAreaLayoutGuide.bottomAnchor, Constants.collectionBottom)
        collectionView.pinTop(view.safeAreaLayoutGuide.topAnchor, Constants.collectionTop)
    }
    
    //MARK: - Public methods
    func didPressCheckBox(cell: WishEventCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        events.remove(at: indexPath.row)
        saveWishes()
        collectionView.deleteItems(at: [indexPath])
    }
    
    //MARK: - Objc methods
    @objc
    private func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func plusButtonPressed(_ sender: UIButton) {
        let wishEventCreatingVC = WishEventCreationViewController()
        wishEventCreatingVC.delegate = self
        wishEventCreatingVC.backgroundColor = self.view.backgroundColor
        present(wishEventCreatingVC, animated: true, completion: nil)
    }
}

//MARK: - Extensions
extension WishCalendarViewController: WishEventCreationDelegate {
    func didSetEvent(_ event: CalendarEventModel) {
        events.append(event)
        saveWishes()
        collectionView.reloadData()
    }
}


extension WishCalendarViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return events.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishEventCell.Constants.reuseIdentifier, for: indexPath) as? WishEventCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: events[indexPath.item])
        cell.delegate = self // Чтобы удалять event из events и collectionView.
        return cell
    }
}

extension WishCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width - Constants.minusToCollectionWidth, height: Constants.collectionHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        print("Cell tapped at index \(indexPath.item)")
    }
}

