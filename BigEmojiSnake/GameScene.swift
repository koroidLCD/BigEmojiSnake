
import SpriteKit
import GameplayKit

class Point: Equatable {
    static func == (lhs: Point, rhs: Point) -> Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y
        }
    
    var x: Int
    var y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    func equals(_ other: Point) -> Bool {
        return self.x == other.x && self.y == other.y
    }
}

class GameScene: SKScene {
    private var gameLogo: SKSpriteNode!
    private var playButton: SKSpriteNode!
    private var youDiedText: SKLabelNode!
    
    private var totalScore: SKLabelNode!
    private var totalScoreView: SKSpriteNode!
    
    private var game: GameManager!
    var currentScore: SKLabelNode!
    private var currentScoreView: SKSpriteNode!
    private var gameBG: SKSpriteNode!
    var gameArray: [(node: EmojiShapeNode, point: Point)] = []
    
    private var scaleOutAction: SKAction!
    private var scaleInAction: SKAction!
    private var moveOutsideTopAction: SKAction!
    private var moveBackFromTopAction: SKAction!
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 0, y: 0)
        background.size = CGSize(width: size.width, height: size.height)
        addChild(background)
        scaleInAction = SKAction.init(named: "ScaleIn")
        scaleOutAction = SKAction.init(named: "ScaleOut")
        moveOutsideTopAction = SKAction.init(named: "MoveOutsideTop")
        moveBackFromTopAction = SKAction.init(named: "MoveBackFromTop")
        
        initializeMenu()
        game = GameManager(scene: self, numRows: 30, numCols: 20)
        initializeGameView()
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeR))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeL))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeU))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeD))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc func swipeR() { game.changeDirection(.RIGHT) }
    @objc func swipeL() { game.changeDirection(.LEFT) }
    @objc func swipeU() { game.changeDirection(.UP) }
    @objc func swipeD() {  game.changeDirection(.DOWN) }
    
    override func update(_ currentTime: TimeInterval) {
        game.update(time: currentTime)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = nodes(at: location)
            for node in touchedNode {
                if node.name == "play_button" { startGame() }
            }
        }
    }
    
    private func startGame() {
        self.gameBG.setScale(0)
        self.currentScore.setScale(0)
        self.currentScoreView.setScale(0)
        
        playButton.run(scaleOutAction) {
            self.playButton.isHidden = true
        }
        
        totalScore.run(scaleOutAction) {
            self.totalScore.isHidden = true
        }
        
        totalScoreView.run(scaleOutAction) {
            self.totalScoreView.isHidden = true
        }

        gameLogo.run(moveOutsideTopAction) {
            self.gameLogo.isHidden = true
            self.gameBG.isHidden = false
            self.currentScore.isHidden = false
            self.currentScoreView.isHidden = false
            self.currentScoreView.run(self.scaleInAction)
            self.currentScore.run(self.scaleInAction)
            self.gameBG.run(self.scaleInAction) {
                self.game.initGame()
            }
        }
    }
    
    private func initializeMenu() {
        gameLogo = SKSpriteNode(imageNamed: "logo")
        gameLogo.zPosition = 1
        gameLogo.setScale(0.5)
        gameLogo.position = CGPoint(x: 0, y: (frame.size.height / 2) - 350)
        self.addChild(gameLogo)
        
        totalScoreView = SKSpriteNode(imageNamed: "clearTable")
        totalScoreView.size = CGSize(width: (view?.frame.width)!*0.9, height: (view?.frame.width)!*0.3)
        totalScoreView.zPosition = 1
        totalScoreView.position = CGPoint(x: 0, y: 6)
        self.addChild(totalScoreView)
        
        totalScore = SKLabelNode(text: "Total Score: \(ScoreManager.shared.getPoints())")
        totalScore.fontName = "MarkerFelt-Wide"
        totalScore.fontSize = 40
        totalScore.zPosition = 2
        totalScore.position = CGPoint(x: 0, y: 0)
        totalScore.color = .black
        self.addChild(totalScore)
        
        playButton = SKSpriteNode(imageNamed: "btn_play")
        playButton.name = "play_button"
        playButton.zPosition = 1
        playButton.position = CGPoint(x: 0, y: (frame.size.height / -2) + 200)
        playButton.setScale(0.3)
        self.addChild(playButton)
    }
    
    private func initializeGameView() {
        
        currentScoreView = SKSpriteNode(imageNamed: "clearTable")
        currentScoreView.size = CGSize(width: (view?.frame.width)!*0.9, height: (view?.frame.width)!*0.3)
        currentScoreView.zPosition = 1
        currentScoreView.position = CGPoint(x: 0, y:  (frame.size.height / -2) + 66)
        currentScoreView.isHidden = true
        self.addChild(currentScoreView)
        
        currentScore = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        currentScore.zPosition = 2
        currentScore.position = CGPoint(x: 0, y: (frame.size.height / -2) + 60)
        currentScore.fontSize = 40
        currentScore.isHidden = true
        currentScore.text = "Score: 0"
        currentScore.fontColor = SKColor.white
        self.addChild(currentScore)
        
        let width = frame.size.width - 200
        let cellSize = width  / CGFloat(game.numCols)
        let height = cellSize * CGFloat(game.numRows)

        
        let rect = CGRect(x: -width / 2, y: -height / 2, width: width, height: height)
        gameBG = SKSpriteNode(color: UIColor(cgColor: CGColor(red: 0, green: 1, blue: 0, alpha: 0.3)), size: CGSize(width: rect.width, height: rect.height))
        gameBG.zPosition = 2
        gameBG.isHidden = true
        self.addChild(gameBG)

        createGameBoard(width: width, height: height, cellSize: cellSize)
    }
    
    private func createGameBoard(width: CGFloat, height: CGFloat, cellSize: CGFloat) {
        var x = -width / 2 + cellSize / 2
        var y = height / 2 - cellSize / 2
        for i in 0...game.numRows - 1 {
            for j in 0...game.numCols - 1 {
                let emojiNode = EmojiShapeNode(id: -1, emoji: " ")
                emojiNode.scene?.size = CGSize(width: cellSize, height: cellSize)
                emojiNode.strokeColor = SKColor.black
                emojiNode.zPosition = 2
                emojiNode.position = CGPoint(x: x, y: y)
                gameArray.append((node: emojiNode, point: Point(j, i)))
                gameBG.addChild(emojiNode)
                x += cellSize
            }
            x = CGFloat(width / -2) + (cellSize / 2)
            y -= cellSize
        }
    }
    
    func finishAnimation() {
        currentScore.run(scaleOutAction) {
            self.currentScore.isHidden = true
        }
        currentScoreView.run(scaleOutAction) {
            self.currentScoreView.isHidden = true
        }
        gameBG.run(scaleOutAction) {
            self.totalScore.text = "Total Score: \(ScoreManager.shared.getPoints())"
            self.gameBG.isHidden = true
            self.gameLogo.isHidden = false
            self.totalScore.isHidden = false
            self.totalScoreView.isHidden = false
            self.gameLogo.run(self.moveBackFromTopAction) {
                self.playButton.isHidden = false
                self.playButton.run(SKAction.group([
                    SKAction.scale(to: 0.3, duration: 0.3),
                    SKAction.fadeIn(withDuration: 0.3),
                    SKAction.rotate(toAngle: 0, duration: 0.3)
                ]))
                self.totalScore.run(SKAction.group([
                    SKAction.scale(to: 1, duration: 0.3),
                    SKAction.fadeIn(withDuration: 0.3),
                    SKAction.rotate(toAngle: 0, duration: 0.3)
                ]))
                self.totalScoreView.run(SKAction.group([
                    SKAction.scale(to: 1, duration: 0.3),
                    SKAction.fadeIn(withDuration: 0.3),
                    SKAction.rotate(toAngle: 0, duration: 0.3)
                ]))
            }
        }
    }

}
