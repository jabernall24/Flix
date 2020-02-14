//
//  Alert.swift
//  Flix
//
//  Created by Jesus Andres Bernal Lopez on 2/13/20.
//  Copyright © 2020 Jesus Bernal Lopez. All rights reserved.
//

import UIKit

struct Alert {
    
    static let shared = Alert()
    
    private init() {}
    
    private func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        DispatchQueue.main.async { vc.present(alert, animated: true) }
    }
    
    func showFlixErrorAlert(with error: FlixError, on vc: UIViewController) {
        showBasicAlert(on: vc, with: "", message: error.rawValue)
    }
}
