//
//  ViewController.swift
//  PostRapidApiCalling
//
//  Created by Arpit iOS Dev. on 10/06/24.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlet
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var countDropDown: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var countText: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        countTextField.delegate = self
        
        countText.forEach { btn in
            btn.isHidden = true
            btn.alpha = 0
        }
        
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOpacity = 0.5
        stackView.layer.shadowOffset = CGSize(width: 3, height: 3)
        stackView.layer.shadowRadius = 10
        stackView.layer.masksToBounds = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnDonetapped(_ sender: UIButton) {
                if let query = countTextField.text, !query.isEmpty {
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RapidAPIViewController") as? RapidAPIViewController {
                        vc.query = query
                        navigationController?.pushViewController(vc, animated: true)
                    }
                }
                countTextField.resignFirstResponder()
    }
    
    @IBAction func countDropDown(_ sender: UIButton) {
        countText.forEach { btn in
            UIView.animate(withDuration: 0.5) {
                btn.isHidden = !btn.isHidden
                btn.alpha = btn.alpha == 0 ? 1 : 0
            }
        }
    }
    
    @IBAction func countTapped(_ sender: UIButton) {
        if let btn1 = sender.titleLabel?.text {
            self.countTextField.text = btn1
            animate(toggel: false)
        }
    }
    
    
    // MARK: - Animation Function
    func animate(toggel: Bool) {
        if toggel {
            countText.forEach { btn in
                UIView.animate(withDuration: 0.5) {
                    btn.isHidden = false
                    btn.alpha = btn.alpha == 0 ? 1 : 0
                }
            }
        } else {
            countText.forEach { btn in
                UIView.animate(withDuration: 0.5) {
                    btn.isHidden = true
                    btn.alpha = btn.alpha == 0 ? 1 : 0
                }
            }
        }
    }
    
    
    
}

