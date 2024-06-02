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
    private let addTransaction = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .black
        self.title = "Add transaction"
        setupInputField()
        setupCategoryPicker()
        setupAddTransactionButton()
    }
    
    private func setupInputField() {
        transactionAmountField.placeholder = "Enter the transaction amount…"
        transactionAmountField.borderStyle = .roundedRect
        transactionAmountField.layer.cornerRadius = 15
        
        
        transactionAmountField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(transactionAmountField)
        
        NSLayoutConstraint.activate([
            transactionAmountField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            transactionAmountField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 90)
        ])
    }
    
    private func setupCategoryPicker() {
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(categoryPicker)
        
        NSLayoutConstraint.activate([
            categoryPicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            categoryPicker.topAnchor.constraint(equalTo: self.transactionAmountField.bottomAnchor),
            categoryPicker.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setupAddTransactionButton() {
        addTransaction.setTitle("Add", for: .normal)
        addTransaction.setTitleColor(.secondaryLabel, for: .normal)
        addTransaction.layer.borderWidth = 2.0
        addTransaction.layer.cornerRadius = 10.0
        addTransaction.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        addTransaction.backgroundColor = .secondarySystemFill
        
        addTransaction.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addTransaction)
        
        addTransaction.addTarget(self, action: #selector(addBtnClicked), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addTransaction.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            addTransaction.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 20),
            addTransaction.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    @objc func addBtnClicked() {
        guard let transactionAmount = Double(transactionAmountField.text ?? ""), transactionAmount > 0 else {
            presentAnErrorAlert()
            return
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func presentAnErrorAlert() {
        let wrongAlertController = UIAlertController(
            title: "Wrong amount for transaction",
            message: "Please, enter a valid number (no negative numbers or zero)",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        wrongAlertController.addAction(cancelAction)
        
        present(wrongAlertController, animated: true, completion: nil)
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
}

#Preview {
    AddTransactionViewController()
}
