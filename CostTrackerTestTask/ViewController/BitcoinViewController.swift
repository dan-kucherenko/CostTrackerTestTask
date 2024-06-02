//
//  BitcoinViewController.swift
//  CostTrackerTestTask
//
//  Created by Daniil on 01.06.2024.
//

import Foundation
import UIKit

class BitcoinViewController: UIViewController {
    private let btcRateLbl = UILabel()
    private let balanceLbl = UILabel()
    private let replenishBalanceBtn = UIButton()
    private lazy var balanceStackView = UIStackView(arrangedSubviews: [balanceLbl, replenishBalanceBtn])
    private let addTransactionBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup view
    private func setupView() {
        self.view.backgroundColor = .black

        setupBtcRateLabel()
        setupBalanceLabel()
        setupTheStackView()
        setupTransactionButton()
    }
    
    // MARK: - Bitcoin rate label
    private func setupBtcRateLabel() {
        Task {
            btcRateLbl.text = "$ \(await getBtcRateData() ?? "0.0")"
        }
        btcRateLbl.textColor = .secondaryLabel
        btcRateLbl.font = .systemFont(ofSize: 20)
        
        self.view.addSubview(btcRateLbl)
        btcRateLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            btcRateLbl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            btcRateLbl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
        ])
    }
    
    // MARK: - Stack view setup
    private func setupTheStackView() {
        balanceStackView.axis = .horizontal
        balanceStackView.spacing = 8
        balanceStackView.alignment = .center
    
        setupBalanceLabel()
        setupReplenishButton()
    
        balanceStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(balanceStackView)
        
        NSLayoutConstraint.activate([
            replenishBalanceBtn.widthAnchor.constraint(equalToConstant: 30),
            balanceStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            balanceStackView.topAnchor.constraint(equalTo: btcRateLbl.bottomAnchor, constant: 40)
        ])
    }
    
    // MARK: - Bitcoin Balance label
    private func setupBalanceLabel() {
        balanceLbl.text = "0.0₿"
        balanceLbl.textColor = .secondaryLabel
        balanceLbl.font = .systemFont(ofSize: 50)
    }
    
    private func setupReplenishButton() {
        replenishBalanceBtn.setImage(UIImage(systemName: "plus.square"), for: .normal)
        replenishBalanceBtn.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .regular), forImageIn: .normal)
        replenishBalanceBtn.tintColor = .white
        
        replenishBalanceBtn.addTarget(self, action: #selector(replenishBalance), for: .touchUpInside)
    }
    
    // MARK: - Transaction button
    private func setupTransactionButton() {
        addTransactionBtn.setTitle("Add transaction", for: .normal)
        addTransactionBtn.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        addTransactionBtn.setTitleColor(.secondaryLabel, for: .normal)
        addTransactionBtn.backgroundColor = .white
        addTransactionBtn.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        addTransactionBtn.backgroundColor = .secondarySystemFill
        addTransactionBtn.layer.cornerRadius = 10
        
        addTransactionBtn.addTarget(self, action: #selector(addTransactionClicked), for: .touchUpInside)
        
        self.view.addSubview(addTransactionBtn)
        addTransactionBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addTransactionBtn.topAnchor.constraint(equalTo: balanceLbl.bottomAnchor, constant: 20),
            addTransactionBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            addTransactionBtn.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK: - Fetch data from the API
    private func getBtcRateData() async -> String? {
        do {
            let btcRate = try await ApiBitcoinManager.shared.getBitcoinRate()
            return btcRate
        } catch {
            print(error)
        }
        return ""
    }
    
    @objc
    private func addTransactionClicked() {
        self.navigationController?.pushViewController(AddTransactionViewController(), animated: true)
    }
    
    @objc
    private func replenishBalance() {
        let replenishBalanceController = UIAlertController(
            title: "Replenish your balance",
            message: "Please, enter a valid number (no negative numbers or zero) to add bitcoins for your account",
            preferredStyle: .alert
        )
        replenishBalanceController.addTextField { input in
            input.placeholder = "Enter amount of bitcoins…"
            input.keyboardType = .decimalPad
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        replenishBalanceController.addAction(submitAction)
        replenishBalanceController.addAction(cancelAction)
        
        present(replenishBalanceController, animated: true, completion: nil)
    }
}

#Preview {
    BitcoinViewController()
}
