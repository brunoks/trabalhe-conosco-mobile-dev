//
//  PrimingController.swift
//  iOS-PicPay-Teste
//
//  Created by Mac Novo on 04/12/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit
import GoogleSignIn

class PrimingController: UIViewController {
    
    //Replace the color of next viewcontroller and change he's color to green
    override func viewWillDisappear(_ animated: Bool) {
        self.removeBackLabelAndChangeColor(with: .lightGreen)
    }
    
    
    lazy var priming: PrimingView = { [unowned self] in
        let view = PrimingView()
        view.assignButton.addTarget(self, action: #selector(cadastrarCarteira), for: .touchUpInside)
        return view
    }()
    
    
    var contato: Contato?
    lazy var loginView = LoginView()
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigurePrimingVC()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    fileprivate func ConfigurePrimingVC() {
        self.view.backgroundColor = .strongBlack
        self.view.addSubview(self.priming)
        self.priming.fillSuperviewLayoutGuide()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    @objc
    fileprivate func cadastrarCarteira() {
        
        let wallet = CarteiraViewModel()
        Alert(self).loading(title: "Carregando")
        wallet.cadastrarCarteira { [weak self] (result) in
            if let strong = self {
                Alert(strong).dissmiss()
                switch result {
                case .success(_):
                    Alert(strong).normalAlert(with: "Cadasdo realizado com sucesso") { [weak self] in
                        self?.chamaTelaPagamento()
                        }
                case .failure(let error):
                    Alert(strong).normalAlert(with: "Erro ao realizar cadastro", and: error.localizedDescription)
                    break
                }
            }
        }
    }
    
    
    @objc fileprivate func chamaTelaPagamento() {
        //GIDSignIn.sharedInstance()?.signIn()
        let viewc = NewCredCardFormVC()
        self.present(viewc, animated: true, completion: nil)
    }
}

extension PrimingController: GIDSignInUIDelegate {
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        print("logado")
    }
}
