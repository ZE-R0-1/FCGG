//
//  AlertPresenter.swift
//  FCGG
//
//  Created by USER on 8/5/24.
//

import UIKit

struct AlertPresenter {
    static func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let topViewController = windowScene.windows.first?.rootViewController {
                topViewController.present(alert, animated: true, completion: nil)
            }
        }
    }
}
