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
    private lazy var categoryTransactionDateStack = UIStackView(arrangedSubviews: [category, transactionDate])
    
    override func prepareForReuse() {
        super.prepareForReuse()
        transactionDate.text = nil
        category.text = nil
        amount.text = nil
    }
    
    func configure(with transaction: Transaction) {
        self.transaction = transaction
        setup()
    }

    private func setup() {
        setupStackView()
        setupAmountLabel()
    }
    
    private func setupStackView() {
        setupTransactionDate()
        setupCategoryLabel()
        
        categoryTransactionDateStack.axis = .vertical
        categoryTransactionDateStack.spacing = 5
        categoryTransactionDateStack.alignment = .leading
        
        categoryTransactionDateStack.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(categoryTransactionDateStack)
        
        NSLayoutConstraint.activate([
            categoryTransactionDateStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryTransactionDateStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CGFloat(sideAnchorConstant)),
        ])
    }
    
    // MARK: - Setup the category
    private func setupCategoryLabel() {
        category.text = transaction?.category
        category.font = .systemFont(ofSize: 20, weight: .semibold)
        category.textColor = color
        
        category.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Setup the date
    private func setupTransactionDate() {
        let date = formatDate(transaction!.date!)
        transactionDate.text = date
        
        transactionDate.font = .systemFont(ofSize: 15, weight: .regular)
        transactionDate.textColor = color

        transactionDate.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Setup the transaction amount
    private func setupAmountLabel() {
        amount.text = "\(String(describing: transaction!.amount)) ₿"
        amount.font = .systemFont(ofSize: 20, weight: .bold)
        amount.textColor = color
        amount.textAlignment = .center
        
        
        amount.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(amount)
        
        NSLayoutConstraint.activate([
            amount.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            amount.leadingAnchor.constraint(equalTo: categoryTransactionDateStack.trailingAnchor, constant: CGFloat(sideAnchorConstant)),
            amount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -CGFloat(sideAnchorConstant))
        ])
    }
}
