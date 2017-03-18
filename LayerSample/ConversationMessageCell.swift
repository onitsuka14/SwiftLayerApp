//
//  ConversationMessageCell.swift
//  LayerSample
//
//  Created by Katherine Torralba on 3/18/17.
//  Copyright © 2017 Takashi Someda. All rights reserved.
//

import UIKit
import Atlas

class ConversationMessageCell: UICollectionViewCell, ATLMessagePresenting {
 
    var imageView: UIImageView!
    var labelView: UILabel!
    var message:LYRMessage!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.imageView = UIImageView()
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.contentMode = .scaleAspectFit
//        self.imageView.backgroundColor = UIColor.blue
        self.contentView.addSubview(self.imageView)
        
        self.labelView = UILabel()
        self.labelView.translatesAutoresizingMaskIntoConstraints = false
        self.labelView.textAlignment = .center
//        self.labelView.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(self.labelView)
        
        self.configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureConstraints() {
        
        let margins = self.contentView.layoutMarginsGuide
        
        self.labelView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.labelView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        self.labelView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.labelView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        self.imageView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        let labelmargins = self.labelView.layoutMarginsGuide
        self.imageView.bottomAnchor.constraint(equalTo: labelmargins.topAnchor, constant: -8).isActive = true
    }
    
    //MARK: Protocol Functions
    public func present(_ message: LYRMessage) {
        
        self.message = message;
        let parts = message.parts
        
        if let textData = parts[0].data {
            let text = String(data: textData, encoding: String.Encoding.utf8)
            self.labelView.text = text!
        }
        
        if let imageData = parts[1].data {
            let image = UIImage(data: imageData)
            self.imageView.image = image!
        }
    }
    
    public func update(withSender sender: ATLParticipant?) {
        return
    }
    
    public func shouldDisplayAvatarItem(_ shouldDisplayAvatarItem: Bool) {
        return
    }
}
