//
//  UIViewController+Extension.swift
//  Name Game
//
//  Created by Michal Hus on 5/18/20.
//  Copyright © 2020 Michal Hus. All rights reserved.
//

import UIKit

extension UIViewController {

    func errorAlertMessage(title: String, message: String, isGameOver: Bool = false) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        isGameOver ? alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
        })) : alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
