//
//  UIViewController+Ext.swift
//  Popcorn
//
//  Created by Yavuz Aytekin on 21.01.2023.
//

import UIKit

extension UIViewController {
    func addErrorAlert(message: String) {
        Task { @MainActor in
            let dialogMessage = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
            
            let okBtn = UIAlertAction(title: "Tamam",
                                   style: .default)
            dialogMessage.addAction(okBtn)

            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
}
