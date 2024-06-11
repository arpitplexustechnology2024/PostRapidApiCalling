//
//  RapidAPIViewController.swift
//  PostRapidApiCalling
//
//  Created by Arpit iOS Dev. on 10/06/24.
//

import UIKit
import Alamofire

class RapidAPIViewController: UIViewController {
    
    var noInternetView: NoInternetView!
    var query: String?
    var items: [WelcomeElement] = []
    var isLoading = true
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        
        setupNoInternetView()
        
        
        if let query = query {
            if isConnectedToInternet() {
                showLoaderAndFetchData()
            } else {
                showNoInternetView()
            }
        }
        
    }
    
    func setupNoInternetView() {
        noInternetView = NoInternetView()
        noInternetView.translatesAutoresizingMaskIntoConstraints = false
        noInternetView.retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        view.addSubview(noInternetView)
        
        NSLayoutConstraint.activate([
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noInternetView.topAnchor.constraint(equalTo: view.topAnchor),
            noInternetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        noInternetView.isHidden = true
    }
    
    @objc func retryButtonTapped() {
        if isConnectedToInternet() {
            noInternetView.isHidden = true
            showLoaderAndFetchData()
        } else {
            showAlert(title: "No Internet", message: "Please check your internet connection and try again.")
        }
    }
    
    func showLoaderAndFetchData() {
        activityIndicator.startAnimating()
        activityIndicator.style = .large
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = false
            self.fetchData()
        }
    }
    
    func fetchData() {
        guard let count = query else {
            print("Count value is empty")
            return
        }
        
        let url = "https://andruxnet-random-famous-quotes.p.rapidapi.com/"
        let headers: HTTPHeaders = [
            "X-RapidAPI-Key": "e103305047msh67c54e4389f5e37p106668jsn6f55a35f4271",
        ]
        let parameters: [String: String] = [
            "cat": "movies",
            "count": count
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: headers)
            .responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: value)
                                self.items = try JSONDecoder().decode(Welcome.self, from: jsonData)
                                    self.tableView.reloadData()
                            } catch {
                                print("Error decoding JSON: \(error)")
                            }
                        case .failure(let error):
                            print("Error: \(error)")
                        }
                    }
    }
    
    func showNoInternetView() {
        DispatchQueue.main.async {
            self.noInternetView.isHidden = false
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func isConnectedToInternet() -> Bool {
        let networkManager = NetworkReachabilityManager()
        return networkManager?.isReachable ?? false
    }
}

// MARK: - TableView Dalegate & Datasource
extension RapidAPIViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.quoteLbl.text = items[indexPath.row].quote
        cell.authorLbl.text = items[indexPath.row].author
        cell.categoryLbl.text = items[indexPath.row].category
        return cell
    }
}
