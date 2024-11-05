//
//  WishStoringViewController.swift
//  kialisaevPW2
//
//  Created by Кирилл Исаев on 05.11.2024.
//

import UIKit
final class WishStoringViewController: UIViewController {
    
    // MARK: Enum(Constants)
    enum Constants {
        static let tableCornerRadius: CGFloat = 20
        static let tableOffset: CGFloat = 40
    }
    
    private let table: UITableView = UITableView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureTable()
    }
    
    private func configureTable() {
        view.addSubview(table)
        table.backgroundColor = .systemPink
        table.dataSource = self
        table.separatorStyle = .none
        table.layer.cornerRadius = Constants.tableCornerRadius
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.pin(view, Constants.tableOffset)
    }
}

// MARK: - UITableViewDataSource
extension WishStoringViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
