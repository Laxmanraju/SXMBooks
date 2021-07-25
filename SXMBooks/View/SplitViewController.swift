//
//  SplitViewController.swift
//  SXMBooks
//
//  Created by Laxman Penmetsa on 7/24/21.
//

import UIKit

class SplitVIewController: UISplitViewController,
                           UISplitViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = .oneBesideSecondary
    }

    func splitViewController(
             _ splitViewController: UISplitViewController,
             collapseSecondary secondaryViewController: UIViewController,
             onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior
        return true
    }
}
