//
//  GameViewController.swift
//  BigEmojiSnake
//
//  Created by Anton Babko on 02.11.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skview = SKView(frame: self.view.frame)
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                skview.presentScene(scene)
            }
            skview.ignoresSiblingOrder = true
        view.addSubview(skview)
        
        let secretButton = UIButton(type: .custom)
        secretButton.setImage(UIImage(named: "btn_back"), for: .normal)
        secretButton.imageView?.contentMode = .scaleAspectFit
        secretButton.translatesAutoresizingMaskIntoConstraints = false
        secretButton.addAction(UIAction(handler: {_ in
            self.dismiss(animated: true)
        }), for: .touchUpInside)
        view.addSubview(secretButton)
        
        NSLayoutConstraint.activate([
            secretButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            secretButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            secretButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.2),
            secretButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.2),
        ])

    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
