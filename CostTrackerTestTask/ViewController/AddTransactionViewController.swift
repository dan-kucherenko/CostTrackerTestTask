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
        setupCategoryPicker()
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
    
    private func setupCategoryPicker() {
        categoryPicker.backgroundColor = .systemBackground
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(categoryPicker)
        
        NSLayoutConstraint.activate([
            categoryPicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            categoryPicker.topAnchor.constraint(equalTo: self.transactionAmountField.topAnchor, constant: 90)
        ])
    }
}

// MARK: - UIPickerViewDataSource
extension AddTransactionViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Category.allCases.count
    }
}

// MARK: - UIPickerViewDelegate
extension AddTransactionViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Category.getCategoryBy(index: row)?.rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected item: \(Category.getCategoryBy(index: row)?.rawValue)")
    }
}

#Preview {
    AddTransactionViewController()
}
