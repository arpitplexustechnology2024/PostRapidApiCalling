//
//  RowParameterViewController.swift
//  PostRapidApiCalling
//
//  Created by Arpit iOS Dev. on 10/06/24.
//

import UIKit
import Alamofire

class RowParameterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [WelcomeElement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
       
    }
    
    @IBAction func btnClickToApiCallingTapped(_ sender: UIButton) {
        fetchRandomQuotes()
    }
    
    
    
    func fetchRandomQuotes() {
            let headers: HTTPHeaders = [
                "X-RapidAPI-Key": "e103305047msh67c54e4389f5e37p106668jsn6f55a35f4271"
            ]
            
            let parameters = "cat=movies&count=10"
            
            let url = "https://andruxnet-random-famous-quotes.p.rapidapi.com"
            
            AF.request(url, method: .post, parameters: [:], encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [WelcomeElement].self) { response in
                    switch response.result {
                    case .success(let quotes):
                        self.items = quotes
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error)
                    }
            }
        }



}

// MARK: - TableView Dalegate & Datasource
extension RowParameterViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RowTableViewCell") as! RowTableViewCell
        
        cell.quoteLbl.text = items[indexPath.row].quote
        cell.authorLbl.text = items[indexPath.row].author
        cell.categoryLbl.text = items[indexPath.row].category
        
        return cell
    }
}
