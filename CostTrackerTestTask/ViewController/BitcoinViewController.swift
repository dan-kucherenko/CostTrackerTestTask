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
    private let addTransactionBtn = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup view
    private func setupView() {
        self.setupBtcRateLabel()
        self.setupBalanceLabel()
        self.setupTransactionButton()
    }
    
    // MARK: - Bitcoin rate label
    private func setupBtcRateLabel() {
        Task {
            btcRateLbl.text = "$ \(await getBtcRateData() ?? "0.0")"
        }
        btcRateLbl.textColor = .cyan
        btcRateLbl.font = .systemFont(ofSize: 20)
        
        self.view.addSubview(btcRateLbl)
        btcRateLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            btcRateLbl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            btcRateLbl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
        ])
    }
    
    // MARK: - Bitcoin Balance label
    private func setupBalanceLabel() {
        balanceLbl.text = "0.0₿"
        balanceLbl.textColor = .cyan
        balanceLbl.font = .systemFont(ofSize: 50)
        
        self.view.addSubview(balanceLbl)
        balanceLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            balanceLbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            balanceLbl.topAnchor.constraint(equalTo: btcRateLbl.bottomAnchor, constant: 30),
        ])
    }
    
    // MARK: - Transaction button
    private func setupTransactionButton() {
        self.addTransactionBtn.setTitle("Add transaction", for: .normal)
        self.addTransactionBtn.backgroundColor = .blue
        self.addTransactionBtn.layer.cornerRadius = 10
        self.addTransactionBtn.addTarget(self, action: #selector(addTransactionClicked), for: .touchUpInside)

        self.view.addSubview(addTransactionBtn)
        addTransactionBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addTransactionBtn.topAnchor.constraint(equalTo: balanceLbl.bottomAnchor, constant: 20),
            addTransactionBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            addTransactionBtn.widthAnchor.constraint(equalToConstant: 150)
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
}
