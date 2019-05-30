//
//  Protocols.swift
//  iOS-PicPay-Teste
//
//  Created by Mac Novo on 26/12/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import Foundation


protocol CheckViewControllerProtocol {
    
    static func didPaymentSuccess(with ticketUser: TicketUser)
}

struct ControlNewPayment: CheckViewControllerProtocol {
    static func didPaymentSuccess(with ticketUser: TicketUser) {
        callTicketView(ticketUser)
    }
    
    static var callTicketView: (_ ticket: TicketUser) -> Void = { _ in }
}
