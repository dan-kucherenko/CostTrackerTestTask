//
//  BitcoinViewController.swift
//  CostTrackerTestTask
//
//  Created by Daniil on 01.06.2024.
//

import Foundation
import UIKit

class BalanceViewController: UIViewController {
    // MARK: - Cell identifier
    private let cellIdentifier = "transactionCell"
    
    // MARK: - UI elements
    private let btcRateLbl = UILabel()
    private let balanceLbl = UILabel()
    private let replenishBalanceBtn = UIButton()
    private lazy var balanceStackView = UIStackView(arrangedSubviews: [balanceLbl, replenishBalanceBtn])
    private let addTransactionBtn = UIButton()
    private let transactionsTable = UITableView()
    
    
    // MARK: - Fields for view
    private var transactions: [Transaction] = []
    private var balance: Balance?
    private var rate = ""
    private var timeOfLastUpdate: Date?
    private let transactionsLimit = 20
    private var transactionOffset = 0
    
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
        setupTransactionsTable()
        
        fetchBalance()
        fetchTransactions()
    }
    
    // MARK: - Bitcoin rate label
    private func setupBtcRateLabel() {
        updateBtcRate()
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
    
    // MARK: - Transactions table configuration
    private func setupTransactionsTable() {
        transactionsTable.backgroundColor = .black
        transactionsTable.register(TransactionTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        self.transactionsTable.delegate = self
        self.transactionsTable.dataSource = self
        
        transactionsTable.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(transactionsTable)
        
        NSLayoutConstraint.activate([
            transactionsTable.topAnchor.constraint(equalTo: addTransactionBtn.bottomAnchor, constant: 15),
            transactionsTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            transactionsTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            transactionsTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    // MARK: - Fetch data from the API
    private func getBtcRateData() async -> String? {
        do {
            return try await ApiBitcoinManager.shared.getBitcoinRate()
        } catch {
            print(error)
        }
        return ""
    }
    
    @objc
    private func addTransactionClicked() {
        let addTransactionVc = AddTransactionViewController()
        addTransactionVc.delegate = self
        self.navigationController?.pushViewController(addTransactionVc, animated: true)
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
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            guard let self else { return }
            guard let amountText = replenishBalanceController.textFields?[0].text,
                  let amount = Double(amountText), amount > 0 else {
                presentAnErrorAlert()
                return
            }
            CoreDataManager.shared.updateBalance(by: amount)
            
            createTransaction(amount: amount, category: "replanishing")
            transactionConfirmation()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        replenishBalanceController.addAction(submitAction)
        replenishBalanceController.addAction(cancelAction)
        
        present(replenishBalanceController, animated: true, completion: nil)
    }
    
    private func fetchBalance() {
        self.balance = CoreDataManager.shared.fetchBalance()
        
        guard let balance = self.balance else {
            let initialBalance = Balance(context: CoreDataManager.shared.context)
            initialBalance.bitcoins = 0.0
            CoreDataManager.shared.saveContext()
            self.balance = initialBalance
            return
        }
        
        DispatchQueue.main.async {
            self.balanceLbl.text = "\(String(describing: balance.bitcoins)) ₿"
            self.transactionsTable.reloadData()
        }
    }
    
    private func fetchTransactions() {
        if transactionOffset % 20 == 0 {
            print("Loading more transactions with offset \(transactionOffset)")
            if let fetchedTransactions = CoreDataManager.shared.fetchTransactions(limit: transactionsLimit, offset: transactionOffset) {
                if !fetchedTransactions.isEmpty {
                    transactions += fetchedTransactions
                    transactionOffset += fetchedTransactions.count
                    DispatchQueue.main.async {
                        self.transactionsTable.reloadData()
                    }
                }
            }
        }
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
    
    private func createTransaction(amount: Double, category: String, date: Date = Date()) {
        let transaction = Transaction(context: CoreDataManager.shared.context)
        transaction.amount = amount
        transaction.category = category
        transaction.date = date
        
        CoreDataManager.shared.saveContext()
    }
    
    private func updateBtcRate() {
        let defaults = UserDefaults.standard
        
        if let lastUpdate = defaults.object(forKey: "timeOfLastUpdate") as? Date {
            timeOfLastUpdate = lastUpdate
        }
        
        let storedRate = defaults.string(forKey: "bitcoinRate")
        
        if timeOfLastUpdate == nil || storedRate == nil || Date().timeIntervalSince(timeOfLastUpdate!) >= 3600 {
            print("Updating the rate")
            Task {
                self.rate = await getBtcRateData() ?? ""
                defaults.set(Date(), forKey: "timeOfLastUpdate")
                defaults.set(self.rate, forKey: "bitcoinRate")
                DispatchQueue.main.async {
                    self.btcRateLbl.text = "$ \(self.rate)"
                }
            }
        } else {
            print("No need to update, get from the user defaults")
            self.rate = storedRate ?? "0"
            self.btcRateLbl.text = "$ \(self.rate)"
        }
    }
}

// MARK: - UITableViewDelegate
extension BalanceViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            fetchTransactions()
        }
    }
}

// MARK: - UITableViewDataSource
extension BalanceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TransactionTableViewCell
        cell.configure(with: transactions[indexPath.row])
        return cell
    }
}

extension BalanceViewController: TransactionDelegate {
    func transactionConfirmation() {
        transactionOffset = 0
        transactions = []
        fetchTransactions()
        fetchBalance()
        
        transactionsTable.reloadData()
    }
}

#Preview {
    BalanceViewController()
}
