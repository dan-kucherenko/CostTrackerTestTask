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
    private let topAnchorConstant = 10
    private let sideAnchorConstant = 15
    
    // MARK: - UI elements
    private let transactionDate = UILabel()
    private let category = UILabel()
    private let amount = UILabel()
    private let color = UIColor(named: "TextColor")
    
    
    func configure(with transaction: Transaction) {
        self.transaction = transaction
        setup()
    }

    private func setup() {
        setupTransactionDate()
        setupCategoryLabel()
        setupAmountLabel()
    }
    
    // MARK: - Setup the category
    private func setupCategoryLabel() {
        category.text = transaction?.category
        category.font = .systemFont(ofSize: 20, weight: .semibold)
        category.textColor = color
        
        category.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(category)
        
        NSLayoutConstraint.activate([
            category.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(topAnchorConstant)),
            category.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -CGFloat(sideAnchorConstant))
        ])
    }
    
    // MARK: - Setup the date
    private func setupTransactionDate() {
        let date = formatDate(transaction!.date!)
        transactionDate.text = date
        
        transactionDate.font = .systemFont(ofSize: 18, weight: .regular)
        transactionDate.textColor = color
        
        transactionDate.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(transactionDate)

        NSLayoutConstraint.activate([
            transactionDate.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(topAnchorConstant)),
            transactionDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CGFloat(sideAnchorConstant))
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
        amount.textColor = color
        
        amount.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(amount)
        
        NSLayoutConstraint.activate([
            amount.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            amount.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
