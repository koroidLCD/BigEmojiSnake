import UIKit

class MenuViewController: UIViewController {
    
    var logoImageView: UIImageView!
    var backgroundImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "background")
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleToFill
        view.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            logoImageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
        
        let playButton = UIButton(type: .custom)
        playButton.setImage(UIImage(named: "btn_start"), for: .normal)
        playButton.imageView?.contentMode = .scaleAspectFit
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addAction(UIAction(handler: {_ in
            let vc = GameViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }), for: .touchUpInside)
        view.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.2),
            playButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            playButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
        
        let rewardsButton = UIButton(type: .custom)
        rewardsButton.setImage(UIImage(named: "btn_rewards"), for: .normal)
        rewardsButton.imageView?.contentMode = .scaleAspectFit
        rewardsButton.translatesAutoresizingMaskIntoConstraints = false
        rewardsButton.addAction(UIAction(handler: {_ in
            let vc = RewardsViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }), for: .touchUpInside)
        view.addSubview(rewardsButton)
        
        NSLayoutConstraint.activate([
            rewardsButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 20),
            rewardsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rewardsButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.2),
            rewardsButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            rewardsButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
        
        let secretButton = UIButton(type: .custom)
        secretButton.setImage(UIImage(named: "btn_roll"), for: .normal)
        secretButton.imageView?.contentMode = .scaleAspectFit
        secretButton.translatesAutoresizingMaskIntoConstraints = false
        secretButton.addAction(UIAction(handler: {_ in
            let vc = BonusViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }), for: .touchUpInside)
        view.addSubview(secretButton)
        
        NSLayoutConstraint.activate([
            secretButton.topAnchor.constraint(equalTo: rewardsButton.bottomAnchor, constant: 20),
            secretButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secretButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.2),
            secretButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            secretButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])

        
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
}
