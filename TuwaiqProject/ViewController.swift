//
//  ViewController.swift
//  TuwaiqProject
//
//  Created by Eth Os on 22/09/1442 AH.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func regeister(){
        if let email = emailTextField.text,
           let password = passwordTextField.text{
           
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                }else{
                    self.performSegue(withIdentifier: "selectID", sender: nil)
                }
            }
            
        }
    }
    
    func login(){
        if let email = emailTextField.text,
           let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                }else{
                    self.performSegue(withIdentifier: "selectID", sender: nil)
                }
            }
        }
    }

    @IBAction func nextButton(_ sender: Any) {
        
        switch segment.selectedSegmentIndex {
        case 0:
            login()
        case 1:
            regeister()
        default:
            print("nothing has been selected")
        }
    }
    
}

