//
//  WishStoringViewController.swift
//  kialisaevPW2
//
//  Created by Кирилл Исаев on 05.11.2024.
//

import UIKit
final class WishStoringViewController: UIViewController, UITableViewDelegate {
    
    // MARK: Enum(Constants)
    enum Constants {
        static let keyForSave: String = "savedWishes"
        
        static let alertTitle: String = "Edit Wish"
        static let alertMessage: String = "Update your wish"
        static let alertSave: String = "Save"
        static let alertCancel: String = "Cancel"
        
        static let tableCornerRadius: CGFloat = 20
        static let tableOffset: CGFloat = 40
        
        static let numberOfSections: Int = 2
        
    }
    
    // MARK: Fields
    private let table: UITableView = UITableView(frame: .zero)
    var wishArray: [String] = []
    let defaults = UserDefaults.standard
    var backgoundColor: UIColor?
    static let shared = WishStoringViewController()
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgoundColor ?? .red
        loadWishes()
        configureTable()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func getUserDefauts() -> [String] {
        return UserDefaults.standard.stringArray(forKey: Constants.keyForSave)!
    }
    
    // MARK: Private methods
    private func loadWishes() {
        if let savedWishes = defaults.array(forKey: Constants.keyForSave) as? [String] {
            wishArray = savedWishes
        }
    }
    
    private func saveWishes() {
        defaults.set(wishArray, forKey: Constants.keyForSave)
    }
    
    private func configureTable() {
        view.addSubview(table)
        table.backgroundColor = .systemPink
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.layer.cornerRadius = Constants.tableCornerRadius
        table.rowHeight = UITableView.automaticDimension
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.pin(view, Constants.tableOffset)
        
        table.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.reuseId)
        table.register(AddWishCell.self, forCellReuseIdentifier: AddWishCell.reuseId)
    }
}

// MARK: - UITableViewDataSource
extension WishStoringViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return wishArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddWishCell.reuseId, for: indexPath) as! AddWishCell
            cell.addWish = { [weak self] wish in 
                self?.wishArray.append(wish)
                self?.saveWishes()
                self?.table.reloadData()}
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: WrittenWishCell.reuseId, for: indexPath) as! WrittenWishCell
            cell.configure(with: wishArray[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == 1 {
            wishArray.remove(at: indexPath.row)
            saveWishes()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        let wishToEdit = wishArray[indexPath.row]
        
        let alert = UIAlertController(title: Constants.alertTitle, message: Constants.alertMessage, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = wishToEdit
        }
        
        let saveAction = UIAlertAction(title: Constants.alertSave, style: .default) { [weak self] _ in
            guard let newText = alert.textFields?.first?.text, !newText.isEmpty else { return }
            self?.wishArray[indexPath.row] = newText
            self?.saveWishes()
            self?.table.reloadRows(at: [indexPath], with: .automatic)
        }
        
        let cancelAction = UIAlertAction(title: Constants.alertCancel, style: .cancel, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
