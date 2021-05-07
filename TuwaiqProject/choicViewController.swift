//
//  MemeViewController.swift
//  TuwaiqProject
//
//  Created by Eth Os on 24/09/1442 AH.
//

import Foundation
import UIKit

class choicViewController : UIViewController {
    
    @IBAction func chatButton(_ sender: Any) {
        performSegue(withIdentifier: "chatView", sender: nil)
    }
    
    @IBAction func editImageButton(_ sender: Any) {
        performSegue(withIdentifier: "toMeme", sender: nil)
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
