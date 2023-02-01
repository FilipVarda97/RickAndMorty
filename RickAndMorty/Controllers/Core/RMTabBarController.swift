//
//  RMTabBarController.swift
//  RickAndMorty
//
//  Created by Filip Varda on 25.01.2023..
//

import UIKit

/// A UITabBarController responsible for housing four core UIViewControllers:
/// RMCharactersViewController, RMLocationsViewController, RMEpisodesViewController, RMSettingsViewController.
///
/// Those UIViewControllers are embeden in UINavigationControllers as rootViewController, after which those
/// UINavigationControllers are set as viewControllers of the UITabBarController.
///
/// UITabBarController is set as rootViewController of UIWindow. (File: "SceneDelegate.swift" in group "Resources")
final class RMTabBarController: UITabBarController {
    private let controllers: [UIViewController] = [
        RMCharactersViewController(),
        RMSavedCharactersViewController(),
        RMSettingsViewController()
    ]

    private let tabBarItems = [
        UITabBarItem(title: "Character", image: UIImage(systemName: "person.2"), tag: 1),
        UITabBarItem(title: "Saved Characters", image: UIImage(systemName: "location"), tag: 2),
        UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), tag: 3)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
    }

    private func setUpTabs() {
        let navControllers = controllers.enumerated().compactMap { (index, controller) in
            let navigationController = UINavigationController(rootViewController: controller)
            
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.backgroundColor = RMColors.green2
            
            navigationController.navigationItem.largeTitleDisplayMode = .always
            navigationController.navigationBar.prefersLargeTitles = true

            navigationController.navigationBar.standardAppearance = navBarAppearance
            navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
            navigationController.navigationBar.compactAppearance = navBarAppearance
            navigationController.navigationBar.compactScrollEdgeAppearance = navBarAppearance
            
            navigationController.tabBarItem = tabBarItems[index]
            
            return navigationController


        }
        setViewControllers(navControllers, animated: true)
    }
}
