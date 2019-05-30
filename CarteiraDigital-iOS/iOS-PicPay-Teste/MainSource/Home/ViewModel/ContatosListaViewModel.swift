//
//  ContatosListaViewModel.swift
//  iOS-PicPay-Teste
//
//  Created by Bruno Vieira on 16/03/19.
//  Copyright © 2019 Bruno iOS Dev. All rights reserved.
//

import Foundation

class ContatosListaViewModel {
    
    var items = [Contato]()
    
    var filtered = [Contato]()
    
    var didSelect: (Contato) -> () = { _ in }
    
    func handleRequest(_ completion: @escaping (_ error: Error?,_ success: Bool) -> Void) {
        let url = BASEURL + LIST_USERS
        BrunoFire.request(url) { [weak self] (erro: Error?, result: Array<Contato>?)  in
            if let error = erro {
                completion(error, false)
            }
            self?.items = result ?? []
            self?.filtered = result ?? []
            self?.sorted()
            completion(nil, true)
        }
    }
    
    func sorted() {
        self.items = self.items.sorted(by: { $0.name < $1.name })
    }
    
    func numberOfRowsInSection() -> Int {
        return self.items.count
    }
    
    func cellForRow(with row: Int) -> Contato {
        return self.items[row]
    }
    
    func didSelectRow(with row: Int) {
        let item = items[row]
        self.didSelect(item)
    }
}
