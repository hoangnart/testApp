//
//  String+.swift
//  TestApp
//
//  Created by MACBOOK on 30/06/2022.
//

import UIKit

extension String {
    func getDomainName() -> String? {
        guard let url = URL(string: self) else { return nil }
        return url.host
    }
    
    func getFullDomainName() -> String? {
        guard let url = URL(string: self),
              let domainName = url.host,
              let scheme = url.scheme
        else { return nil }
        let domainPart = "\(scheme)://\(domainName)"
        return domainPart
    }
}
