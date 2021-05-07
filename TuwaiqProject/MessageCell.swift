//
//  MessageCellTableViewCell.swift
//  TuwaiqProject
//
//  Created by Eth Os on 24/09/1442 AH.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    enum sender{
        case me
        case other
    }
    func getMessageDesign(sender: sender){
        var backGroundColor : UIColor?
        
        switch sender {
        case .me:
            backGroundColor = #colorLiteral(red: 0.8125225902, green: 0.7926651239, blue: 0.95747298, alpha: 1)
            messageBubble.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMaxYCorner,.layerMinXMaxYCorner]
            textLabel?.textAlignment = .right
        case .other:
            backGroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            messageBubble.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMaxYCorner,.layerMaxXMinYCorner]
            textLabel?.textAlignment = .left
        break
        }
        
        messageBubble.backgroundColor = backGroundColor
        messageBubble.layer.cornerRadius = messageLabel.frame.size.height / 2.5
        messageBubble.layer.shadowOpacity = 0.1
    }
}
