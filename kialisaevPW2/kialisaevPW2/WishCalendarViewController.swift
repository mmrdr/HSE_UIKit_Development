//
//  WishCalendarViewController.swift
//  kialisaevPW2
//
//  Created by Кирилл Исаев on 03.12.2024.
//
import UIKit
import Foundation
// HW4
class WishCalendarViewController: UIViewController, UICollectionViewDelegate {
    
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonPressed(_:)))
        navigationItem.leftBarButtonItem = backButton
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 48, bottom: 0, right: 0)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.pinHorizontal(view)
        collectionView.pinBottom(view.safeAreaLayoutGuide.bottomAnchor, 15)
        collectionView.pinTop(view.safeAreaLayoutGuide.topAnchor, 15)
        
    }
    
    
    @objc
    private func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
