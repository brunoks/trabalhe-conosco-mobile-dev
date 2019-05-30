//
//  NewCredCardFormVC.swift
//  iOS-PicPay-Teste
//
//  Created by Mac Novo on 04/12/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleSignIn
import FirebaseAuth

class NewCredCardFormVC: UIViewController {
    
    deinit {
        print("Removeu referência")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    var delegate: CheckViewControllerProtocol!
    
    var ref: DatabaseReference!
    
    
    var isEditable = false
    lazy var saldoView = SaldoView()
    let wallet = CarteiraViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saldoView.qrcodeImage.addTarget(self, action: #selector(gerarNovaChavePublica), for: .touchUpInside)
        self.saldoView.saldolabel.addTarget(self, action: #selector(pegarBalancoCriptoMoeda), for: .touchUpInside)
        configureFormVC()
        pegarBalancoCriptoMoeda()
        if let public_key = self.wallet.carteira?.publicKey {
            self.saldoView.qrcodeImage.setImage(gerarQRcode(public_key), for: .normal)
        }
    }
    
    @objc
    func pegarBalancoCriptoMoeda() {
        let alerta = Alert(self)
        self.saldoView.startActivity()
        self.saldoView.textSaldo = " - - "
        self.wallet.pegarBalanco { [weak self] (result) in
            self?.saldoView.stopActivity()
            switch result {
            case .success(_):
                if let saldo = self?.wallet.carteira?.saldo {
                    self?.saldoView.textSaldo = "\(Double(round(1000*saldo)/1000))".formataSaldo
                }
                break
            case .failure(_):
                alerta.normalAlert(with: "Erro ao atualizar saldo")
            }
        }
    }
    
    @objc
    func gerarNovaChavePublica() {
        self.saldoView.startActivity()
        wallet.mudarChavePublica { [weak self] (result) in
            self?.saldoView.stopActivity()
            switch result {
            case .success(let key):
                self?.saldoView.setImage = self?.gerarQRcode(key)
                break
            case .failure(let erro):
                Alert(self).showAlertWithTryAgain(title: "Erro Gerar nova chave", text: erro.localizedDescription, completion: {
                    self?.gerarNovaChavePublica()
                })
            }
        }
        
    }
    
    func gerarQRcode(_ public_key: String) -> UIImage? {
        let data = public_key.data(using: String.Encoding.ascii)
        if let qrFilter = CIFilter(name: "CIQRCodeGenerator") {
            qrFilter.setValue(data, forKey: "inputMessage")
            if let qrImage = qrFilter.outputImage {
                let transform = CGAffineTransform(scaleX: 10, y: 10)
                let scaledQrImage = qrImage.transformed(by: transform)
                return UIImage(ciImage: scaledQrImage)
            }
        }
        return nil
    }
    
    @objc
    fileprivate func paySomebody(publicKey: String, stringValor: String?) {
        
        let wallet = CarteiraViewModel()
        guard let valor = stringValor else { return }
        
        Alert(self).loading(title: "Carregando")
        wallet.pagarSomebody(publicKey: publicKey, valor: valor) { [weak self] (result) in
            if let strong = self {
                Alert(strong).dissmiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    switch result {
                    case .success(let text):
                        Alert(strong).normalAlert(with: text)
                    case .failure(let error):
                        Alert(strong).normalAlert(with: error.localizedDescription)
                    }
                })
            }
        }
    }

    
    //MARK:- Call PaymentView
    @objc fileprivate func goToQrCodeViewController() {
        let qrView = QRCodeViewController()
        qrView.delegate = self
        self.present(qrView, animated: true, completion: nil)
    }
    
    fileprivate func configureFormVC() {
        self.title = "Cadastrar Carteira Digital"
        self.view.backgroundColor = .strongBlack
        self.navigationItem.titleView = UIView()
        
        
        
        self.view.addSubview(self.saldoView)
        self.saldoView.anchor(top: self.view.layoutMarginsGuide.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.layoutMarginsGuide.bottomAnchor, trailing: self.view.trailingAnchor)
        
        self.saldoView.pagarButton.addTarget(self, action: #selector(goToQrCodeViewController), for: .touchUpInside)
    }
}

extension NewCredCardFormVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(textField.text!)
        return true
    }
}

extension NewCredCardFormVC: ProtocolQrCodeCatch {
    func didGetDataProtocol(_ string: String) {
        Alert(self).showCustomAlert(with: "Digite o valor", { [weak self] (valor) in
            //self?.paySomebody(publicKey: string, stringValor: valor)
            let view = PaymentViewController()
            self?.navigationController?.pushViewController(view, animated: true)
        }) { [weak self] (field) in
            field.delegate = self
        }
    }
}
