//
//  ContactFetch.swift
//  iOS-PicPay-Teste
//
//  Created by Mac Novo on 03/12/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit

struct ContactsFetch {
    static let shared = ContactsFetch()
    func fetchData<I: Decodable>(_ urlstring: String, completion: @escaping (Array<I>) -> ()) {
        
//        BrunoFire.request(urlstring) { (response) in
//            
//        }
    }
}
