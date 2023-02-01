//
//  RMSplashViewController.swift
//  RickAndMorty
//
//  Created by Filip Varda on 30.01.2023..
//

import UIKit
import SnapKit

/// A view controller that handles Splash animation
class RMSplashViewController: UIViewController {
    private var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "RMTitleImage")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    private var portalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "RMPortalImage")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    private var directedByLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25)
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()

    // MARK: - Implementation
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animateTitle()
        animatePortal()
        animateDirectedLabel()
    }

    private func setUpViews() {
        view.backgroundColor = .systemGray6
        directedByLabel.text = "Created by\nJustin Roiland and Dan Harmon"
        view.addSubviews(titleImageView, portalImageView, directedByLabel)
    }

    private func setUpConstraints() {
        titleImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(150)
        }
        directedByLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(150)
        }
        portalImageView.snp.makeConstraints { make in
            make.top.equalTo(titleImageView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(directedByLabel.snp.top)
        }
    }

    private func animateTitle() {
        let positionAnimation = CABasicAnimation(keyPath: "position.y")
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        let origin = titleImageView.layer.position.y
        
        positionAnimation.fromValue = origin
        positionAnimation.toValue = origin + 40
        positionAnimation.beginTime = CACurrentMediaTime() + 0.6
        positionAnimation.duration = 1.5
        positionAnimation.fillMode = .forwards
        positionAnimation.isRemovedOnCompletion = false
        
        alphaAnimation.fromValue = 0
        alphaAnimation.toValue = 1
        alphaAnimation.beginTime = CACurrentMediaTime() + 0.6
        alphaAnimation.duration = 1.5
        alphaAnimation.fillMode = .forwards
        alphaAnimation.isRemovedOnCompletion = false
        
        titleImageView.layer.add(alphaAnimation, forKey: nil)
        titleImageView.layer.add(positionAnimation, forKey: nil)
    }

    private func animatePortal() {
        let positionAnimation = CABasicAnimation(keyPath: "position.y")
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        let origin = portalImageView.layer.position.y
            
        positionAnimation.fromValue = origin
        positionAnimation.toValue = origin + 30
        positionAnimation.beginTime = CACurrentMediaTime() + 1
        positionAnimation.duration = 1.5
        positionAnimation.fillMode = .forwards
        positionAnimation.isRemovedOnCompletion = false
        
        alphaAnimation.fromValue = 0
        alphaAnimation.toValue = 1
        alphaAnimation.beginTime = CACurrentMediaTime() + 1
        alphaAnimation.duration = 1.5
        alphaAnimation.fillMode = .forwards
        alphaAnimation.isRemovedOnCompletion = false

        portalImageView.layer.add(alphaAnimation, forKey: nil)
        portalImageView.layer.add(positionAnimation, forKey: nil)
    }
    
    private func animateDirectedLabel() {
        let positionAnimation = CABasicAnimation(keyPath: "position.x")
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        let origin = directedByLabel.layer.position.x
        
        positionAnimation.fromValue = origin - UIScreen.main.bounds.width
        positionAnimation.toValue = origin
        positionAnimation.beginTime = CACurrentMediaTime() + 1.4
        positionAnimation.duration = 1.0
        positionAnimation.fillMode = .forwards
        positionAnimation.isRemovedOnCompletion = false
        positionAnimation.delegate = self
        
        alphaAnimation.fromValue = 0
        alphaAnimation.toValue = 1
        alphaAnimation.beginTime = CACurrentMediaTime() + 1.4
        alphaAnimation.duration = 1.5
        alphaAnimation.fillMode = .forwards
        alphaAnimation.isRemovedOnCompletion = false
        
        directedByLabel.layer.add(alphaAnimation, forKey: nil)
        directedByLabel.layer.add(positionAnimation, forKey: nil)
    }
}

// MARK: - CAAnimationDelegate
extension RMSplashViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            guard let window = view.window else { return }
            window.rootViewController = RMTabBarController()
            let options: UIView.AnimationOptions = [.transitionCrossDissolve]
            let duration = 1.5
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
        }
    }
}
