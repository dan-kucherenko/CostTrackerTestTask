//
//  TransactionTableCell.swift
//  CostTrackerTestTask
//
//  Created by Daniil on 02.06.2024.
//

import Foundation
import UIKit

class TransactionTableViewCell: UITableViewCell {
    static let cellIdentifier = "transactionCell"
    
    private var transaction: Transaction?
    
    // MARK: - UI elements
    private let transactionDate = UILabel()
    private let category = UILabel()
    private let amount = UILabel()
    
    
    func configure(with transaction: Transaction) {
        self.transaction = transaction
        setup()
    }

    private func setup() {
        self.contentView.backgroundColor = .black
        setupTransactionDate()
        setupCategoryLabel()
        setupAmountLabel()
    }
    
    // MARK: - Setup the category
    private func setupCategoryLabel() {
        category.text = transaction?.category
        category.font = .systemFont(ofSize: 20, weight: .semibold)
        category.textColor = .white
        
        category.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(category)
        
        NSLayoutConstraint.activate([
            category.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            category.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
    
    // MARK: - Setup the date
    private func setupTransactionDate() {
        let date = formatDate(transaction!.date!)
        transactionDate.text = date
        
        transactionDate.font = .systemFont(ofSize: 18, weight: .regular)
        transactionDate.textColor = .white
        
        transactionDate.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(transactionDate)

        NSLayoutConstraint.activate([
            transactionDate.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            transactionDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
        ])
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Setup the transaction amount
    private func setupAmountLabel() {
        amount.text = "\(String(describing: transaction!.amount)) ₿"
        amount.font = .systemFont(ofSize: 20, weight: .bold)
        amount.textColor = .white
        
        amount.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(amount)
        
        NSLayoutConstraint.activate([
            amount.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            amount.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
