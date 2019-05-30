//
//  PaymentRequest.swift
//  iOS-PicPay-Teste
//
//  Created by Mac Novo on 05/12/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//
import UIKit

class PaymentRequest {

    private var _number: String!
    private var _cvv: String!
    private var _value: String!
    private var _date: String!
    private var _destionation: Contato!
    
    
    private var destionation: Contato {
        get {
            return self._destionation
        }
    }
    init(cred: CredCardViewModel, destination: Contato, payment: String) {
        
        self._number = cred.numero
        self._cvv = cred.cvv
        self._value = payment
        self._date = cred.vencimento
        self._destionation = destination
        
    }
    
    //Replace some characters
    fileprivate func removeCharacters(_ text: String) -> String? {
        let string = String(text.filter { !" /,".contains($0) })
        return string
    }
    
    
    func PaymentRequest<I: Decodable>(completion: @escaping (_ error: String?, I?) -> ()) {
        let pay = self._value.replacingOccurrences(of: ",", with: ".")
        guard let value_pay = Double(pay),
            let numero = removeCharacters(self._number),
            let cvv = self._cvv,
            let date = self._date else {
                completion("Erro inesperado.", nil)
                return
        }
        
        let parameters: [String : Any] = [
            "card_number":numero,
            "cvv":cvv,
            "value":value_pay,
            "expiry_date":date,
            "destination_user_id":self._destionation.id
        ]
        let headers: [String : String] = [
        "Content-Type":"application/json"
        ]
        
        let url = BASEURL + MAKE_TRANSACTION
        BrunoFire.requestPayment(url, method: .post, parameters: parameters, headers: headers) { (error,response)  in
            guard let response = response else {
                completion("Erro inesperado.", nil)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: response, options: JSONSerialization.ReadingOptions.allowFragments)
                print(json)
            } catch let error {
                completion(error.localizedDescription, nil)
            }
            do {
                let feed = try JSONDecoder().decode(I.self, from: response)
                DispatchQueue.main.async {
                    completion(nil, feed)
                }
            } catch let error {
                completion(error.localizedDescription, nil)
            }
        }
    }
}
