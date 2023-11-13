
import Foundation

final class Reward {
    var imageName: String
    
    var collected: Bool
    
    var title: String
    
    init(imageName: String, title: String, collected: Bool) {
        self.imageName = imageName
        self.title = title
        self.collected = collected
    }
}

final class ScoreManager {
    
    static let shared = ScoreManager()
    
    func addPoints(_ points: Int) {
        if let retrievedValue = UserDefaults.standard.object(forKey: "score") as? Int {
            let newValue = retrievedValue+points
            UserDefaults.standard.set(newValue, forKey: "score")
        } else {
            UserDefaults.standard.set(points, forKey: "score")
        }
    }
    
    func getPoints() -> Int {
        if let retrievedValue = UserDefaults.standard.object(forKey: "score") as? Int {
            return retrievedValue
        } else {
            UserDefaults.standard.set(0, forKey: "score")
            return 0
        }
    }
    
    func rewards() -> [Reward] {
        let res: [Reward] = [Reward(imageName: "reward1", title: "Reach total score 50!", collected: false), Reward(imageName: "reward2", title: "Reach total score 100!", collected: false), Reward(imageName: "reward3", title: "Reach total score 250!", collected: false),Reward(imageName: "reward4", title: "Reach total score 500!", collected: false)]
        if let score = UserDefaults.standard.object(forKey: "score") as? Int {
            if score >= 50 {
                res[0].imageName = "reward1"
                res[0].title = "Total score 50 reached!"
                res[0].collected = true
            }
            if score >= 100 {
                res[1].imageName = "reward2"
                res[1].title = "Total score 100 reached!"
                res[1].collected = true
            }
            if score >= 250 {
                res[2].imageName = "reward3"
                res[2].title = "Total score 250 reached!"
                res[2].collected = true
            }
            if score >= 500 {
                res[3].imageName = "reward3"
                res[3].title = "Total score 500 reached!"
                res[3].collected = true
            }
        }
        return res
    }
    
    
}
