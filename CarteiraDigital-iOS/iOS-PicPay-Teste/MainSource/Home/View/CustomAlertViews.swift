//
//  CustomAlertViews.swift
//  iOS-PicPay-Teste
//
//  Created by Bruno Vieira on 07/04/19.
//  Copyright © 2019 Bruno iOS Dev. All rights reserved.
//

import UIKit

extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

class NewsFriendsAletView: UIView {
    
    lazy var labelText: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.tintColor = UIColor.darkGray
        label.numberOfLines = 10
        return label
    }()
    
    lazy var imageExample: UIImageView = {
        let image = UIImageView()
        image.contentMode = .center
        image.backgroundColor = .clear
        image.image = "😉".image()
        return image
    }()
    
    lazy var okButton: UIButton =  { [unowned self] in
        let button = UIButton(type: .system)
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGreen
        button.addTarget(self, action: #selector(actionButton(_:)), for: .touchUpInside)
        return button
    }()
    
    var resumeView: () -> Void = {  }
    
    var text: String! {
        get { return self.labelText.text ?? "" }
        set {self.labelText.text = newValue}
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 6
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubview(self.labelText)
        self.addSubview(self.imageExample)
        self.addSubview(self.okButton)
        
        self.labelText.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 35, left: 5, bottom: 0, right: 5))
        
        self.imageExample.anchorXY(centerX: self.centerXAnchor, centerY: nil, top: self.labelText.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 5, left: 0, bottom: 0, right: 0), size: .init(width: 75, height: 75))
        
        self.okButton.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 60))
    }
    
    @objc
    fileprivate func actionButton(_ sender: UIButton) {
        self.isHidden = true
    }
    
}
