//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Yuki Orikasa on 2018/05/13.
//  Copyright © 2018 Yuki Orikasa. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    
    let themes = [
        "Sports": ["⚽️", "🏀", "🏈", "🚴‍♂️", "🏄‍♀️", "🏋️‍♂️", "🏊‍♂️", "⛳️", "🏓"],
        "Animals": ["🐶", "🦁", "🐭", "🐷", "🐸", "🙊", "🦄", "🦆", "🐠"],
        "Faces": ["😀", "🤓", "😎", "🤬", "😇", "😱", "🤮", "😷", "😍"]
    ]
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        return false
    }

    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else if let cvc = lastSequedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastSequedToConcentrationViewController: ConcentrationViewController?
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Choose Theme":
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSequedToConcentrationViewController = cvc
                }
            }
        default:
            break
        }
    }

}
