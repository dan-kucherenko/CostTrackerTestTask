//
//  AddTransactionViewController.swift
//  CostTrackerTestTask
//
//  Created by Daniil on 02.06.2024.
//

import Foundation
import UIKit

class AddTransactionViewController: UIViewController {
    private let transactionAmountField = UITextField()
    private let categoryPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupInputField()
    }
    
    private func setupInputField() {
        transactionAmountField.placeholder = "Enter the transaction amount"
        transactionAmountField.borderStyle = .roundedRect
        transactionAmountField.layer.cornerRadius = 15
        
        transactionAmountField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(transactionAmountField)
        
        NSLayoutConstraint.activate([
            transactionAmountField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            transactionAmountField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40)
        ])
    }
}

#Preview {
    AddTransactionViewController()
}
