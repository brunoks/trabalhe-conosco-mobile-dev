//
//  SearchBar.swift
//  iOS-PicPay-Teste
//
//  Created by Mac Novo on 17/12/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit

class SearchBarView: UIView {
    
    lazy var textField: UITextField = {
        let textf = UITextField()
        textf.backgroundColor = .darkGray
        textf.layer.cornerRadius = 25
        textf.layer.masksToBounds = true
        textf.textColor = .white
        textf.placeholderRect(forBounds: CGRect(x: 45, y: 0, width: 120, height: 30))
        textf.layer.borderColor = UIColor.white.cgColor
        textf.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return textf
    }()
    
    lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .strongBlack
        return view
    }()
    
    lazy var qrCodeButton: UIButton = { [unowned self] in
        let button = UIButton()
        button.imageView?.contentMode = .scaleToFill
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "qrcode-scan"), for: .normal)
        button.addTarget(self, action: #selector(self.actionButton(_:)), for: .touchUpInside)
        return button
    }()
    
    var actionQRCode: () -> Void = { }
    
    lazy var leftimage: UIImageView = {
        let imagel = UIImageView(image: #imageLiteral(resourceName: "search"))
        imagel.frame = CGRect(x: 45, y: 0, width: 35, height: 25)
        imagel.contentMode = .scaleAspectFit
        return imagel
    }()
    
    lazy var rightimage: UIButton = { [unowned self]in
        let imager = UIButton()
        imager.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        imager.frame = CGRect(x: 0, y: 0, width: 40, height: 25)
        imager.contentMode = .scaleAspectFit
        imager.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        return imager
    }()
    
    lazy var leftimageAnimation: UIImageView = {
        let imagel = UIImageView(image: #imageLiteral(resourceName: "search"))
        imagel.contentMode = .scaleAspectFit
        return imagel
    }()
    
    lazy var placeholderAnimation: UILabel = {
        let label = UILabel()
        label.text = "A quem você deseja pagar?"
        label.textColor = .lightGray
        return label
    }()
    
    var isEditing: Bool! {
        didSet {
            if isEditing {
                self.textField.rightViewMode = .always
                self.textField.layer.borderWidth = 1
                animationPlaceholder(true)
            } else {
                self.textField.rightViewMode = .never
                self.textField.layer.borderWidth = 0
                if self.textField.text == "" {
                    animationPlaceholder(false)
                }
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    func configure() {
        self.addSubview(self.container)
        self.container.addSubview(self.textField)
        self.container.addSubview(self.placeholderAnimation)
        self.container.addSubview(self.leftimageAnimation)
        self.addSubview(self.qrCodeButton)
        
        UITextField.appearance().tintColor = .lightGreen
        
        self.qrCodeButton.anchorXY(centerX: nil, centerY: self.centerYAnchor, top: nil, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 15), size: CGSize(width: 30, height: 30))
        
        self.container.anchorXY(centerX: nil, centerY: self.centerYAnchor, top: nil, leading: self.leadingAnchor, bottom: nil, trailing: self.qrCodeButton.leadingAnchor, padding: .init(), size: .init(width: 0, height: 60))
        self.textField.anchor(top: self.container.topAnchor, leading: self.container.leadingAnchor, bottom: self.container.bottomAnchor, trailing: self.container.trailingAnchor, padding: .init(top: 5, left: 15, bottom: 5, right: 15), size: .init(width: 0, height: 50))
        
        self.placeholderAnimation.centerInSuperview(size: CGSize(width: 0, height: 30))
        self.leftimageAnimation.anchorXY(centerX: nil, centerY: self.placeholderAnimation.centerYAnchor, top: nil, leading: nil, bottom: nil, trailing: self.placeholderAnimation.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 10), size: .init(width: 25, height: 25))
        
        self.textField.leftView = leftimage
        self.textField.rightView = rightimage
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func animationPlaceholder(_ bool: Bool) {
        if bool {
            UIView.animate(withDuration: 0.3, animations: {
                let positionp = -(((self.textField.frame.width - 250) / 4) + 15)
                print(positionp)
                self.placeholderAnimation.transform = CGAffineTransform(translationX: positionp, y: 0)
                self.leftimageAnimation.transform = CGAffineTransform(translationX: positionp, y: 0)
            }) { (_) in
                self.textField.attributedPlaceholder = NSAttributedString(string: "A quem você deseja pagar?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                self.placeholderAnimation.isHidden = true
                self.leftimageAnimation.isHidden = true
                self.textField.leftViewMode = .always
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.placeholderAnimation.transform = CGAffineTransform(translationX: 0, y: 0)
                self.leftimageAnimation.transform = CGAffineTransform(translationX: 0, y: 0)
            }) { (_) in
                self.textField.placeholder = ""
                self.textField.leftViewMode = .never
                self.placeholderAnimation.isHidden = false
                self.leftimageAnimation.isHidden = false
            }
        }
    }
    
    @objc
    fileprivate func actionButton(_ sender: Any) {
    print("Qrcode")
        self.actionQRCode()
    }
    
    @objc fileprivate func clearTextField() {
        self.textField.text = ""
        self.textField.endEditing(true)
        self.textField.sendActions(for: .allEditingEvents)
    }
}
