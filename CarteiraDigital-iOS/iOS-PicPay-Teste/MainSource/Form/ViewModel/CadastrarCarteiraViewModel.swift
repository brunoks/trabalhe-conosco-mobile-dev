//
//  CadastrarCarteiraViewModel.swift
//  iOS-PicPay-Teste
//
//  Created by Bruno Vieira on 09/05/19.
//  Copyright © 2019 Bruno iOS Dev. All rights reserved.
//

import Foundation

struct WalletKeysUser {
    static let private_key = "private_key_internal"
    static let public_key = "public_key_internal"
}

struct Carteira {
    var publicKey: String?
    var privateKey: String?
    var saldo: Double?
}

class CarteiraViewModel {
    
    let baseurl = "https://uclcriptocoin.herokuapp.com/"
    var carteira: Carteira?
    
    init() {
        UserDefaults.standard.setValue("10c3e7593eb0525c10652c835e85f8e709e897bf891ef9fd9451c94755690ccf", forKey: WalletKeysUser.private_key)
        let privateKey = UserDefaults.standard.value(forKey: WalletKeysUser.private_key) as? String
        let publicKey = UserDefaults.standard.value(forKey: WalletKeysUser.public_key) as? String
        self.carteira = Carteira()
        self.carteira?.privateKey = privateKey
        self.carteira?.publicKey = publicKey
    }
    
    enum EndPoint: String {
        case gerarCarteira
        case gerarChavePublica
        case transacao
        case saldo
        
        var raw: String {
            switch self {
            case .gerarCarteira:
                return "generate_wallet"
            case .gerarChavePublica:
                return "generate_public_key/"
            case .transacao:
                return "transaction/"
            case .saldo:
                return "balance/"
            }
        }
    }
    
    func cadastrarCarteira(_ completed: @escaping (Result<Bool,Error>) -> Void) {
        let url = "\(baseurl)" + EndPoint.gerarCarteira.raw
        
        BrunoFire.request(url) { (error, keys: NewWalletModel?) in
            if let error = error {
                completed(.failure(error))
            } else if let keys = keys {
                UserDefaults.standard.setValue(keys.private_key, forKey: WalletKeysUser.private_key)
                UserDefaults.standard.setValue(keys.public_key, forKey: WalletKeysUser.public_key)
                print(keys)
                completed(.success(true))
            } else {
                completed(.failure("Erro criar carteira" as! Error))
            }
            
        }
    }
    
    func mudarChavePublica(_ completed: @escaping (Result<String,Error>) -> Void) {
        guard let private_key = UserDefaults.standard.value(forKey: WalletKeysUser.private_key) as? String else { return }
        let url = "\(baseurl)" + EndPoint.gerarChavePublica.raw + "\(private_key)"
        
        BrunoFire.request(url) { (error, public_key: NewPublicKeyModel?) in
            if let error = error {
                completed(.failure(error))
            } else if let key = public_key?.public_key {
                UserDefaults.standard.setValue(key, forKey: WalletKeysUser.public_key)
                completed(.success(key))
            } else {
                completed(.failure("Erro criar carteira" as! Error))
            }
            
        }
    }
    
    func pagarSomebody(publicKey: String, valor: String,_ completed: @escaping (Result<String,Error>) -> Void) {
        
        guard let privateKey = self.carteira?.privateKey else { return }
        let url = "\(baseurl)" + EndPoint.transacao.raw + "\(privateKey)/\(publicKey)/\(valor)"

        BrunoFire.requestPayment(url, method: .post) { (error, retorno: Transaction?) in
            if let error = error {
                completed(.failure(error))
            }
            if let mensagem = retorno?.message {
                completed(.success(mensagem))
            } else {
                completed(.success("Falha na transação"))
            }
        }
    }
    
    func pegarBalanco(_ completed: @escaping (Result<String,Error>) -> Void) {
        guard let public_key = self.carteira?.publicKey else {
            completed(.failure("Por favor, gere outra chave publica" as! Error))
            return
        }
        let url = "\(baseurl)" + EndPoint.saldo.raw + "\(public_key)"
        
        BrunoFire.requestPayment(url) { [weak self] (error, saldo: Balanco?) in
            if let error = error {
                completed(.failure(error))
            }
            self?.carteira?.saldo = saldo?.balance
            completed(.success("Saldo atualizado"))
        }
    }
    
}
