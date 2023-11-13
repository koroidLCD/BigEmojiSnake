import SpriteKit

enum PlayerDirection {
    case LEFT
    case RIGHT
    case UP
    case DOWN
    case DIED
}

class GameManager {
    
    private var scene: GameScene!
    var numRows: Int!
    var numCols: Int!
    
    private var nextTime: Double?
    private var timeExtension: Double = 0.12
    private var playerDirection: PlayerDirection = .LEFT
    private var playerPositions: [Point] = []
    
    private var scorePos: Point?
    private var currentScore: Int = 0
    
    private var currentEmoji = 0
    private var snakeEmojis: [String] = ["🍆", "🍅", "🥒"]
    
    private var emojis: [String] = [
        "🍎", "🍌", "🍇", "🍓", "🍊", "🥕", "🍔", "🍕", "🍟", "🍩",
        "🍏", "🍒", "🍈", "🍑", "🍋", "🥦", "🍗", "🍖", "🍭", "🍰",
        "🥝", "🥥", "🍆", "🍅", "🥒", "🌽", "🥔", "🍠", "🥖", "🥨",
        "😍", "😇", "😂", "😅", "🥹", "🥳", "😎", "🤪", "😛", "🥺",
        "🤩", "😢", "😭", "🤬", "🥵", "😱", "🫡", "😈", "👻", "💩",
        "👾", "😻", "🎃", "🧚", "🎩", "🐶", "🦊", "🐻", "🦁", "💧",
        "🐸", "🐔", "🐵", "🐙", "🍀", "🌸", "🌚", "🪐", "🔥", "⚡️",
    ]
    
    init(scene: GameScene, numRows: Int, numCols: Int) {
        self.scene = scene
        self.numRows = numRows
        self.numCols = numCols
    }
    
    func initGame() {
        playerPositions.append(Point(10, 10))
        playerPositions.append(Point(10, 11))
        playerPositions.append(Point(10, 12))
        playerDirection = .LEFT
        renderChange()
        generateNewScorePos()
    }
    
    func update(time: Double) {
        if nextTime == nil {
            nextTime = time + timeExtension
        } else if time >= nextTime! {
            nextTime = time + timeExtension
            if playerPositions.count > 0 {
                updatePlayerPosition()
                checkForScore()
                checkPlayerDied()
            } else if playerPositions.count == 0 && playerDirection == .DIED {
                playerPositions.removeAll()
                playerDirection = .LEFT
                renderChange()
                scene.finishAnimation()
            }
        }
    }
    
    func changeDirection(_ direction: PlayerDirection) {
        if playerDirection == .DIED { return }
        
        if playerDirection == .LEFT && direction != .RIGHT { playerDirection = direction }
        else if playerDirection == .RIGHT && direction != .LEFT { playerDirection = direction }
        else if playerDirection == .UP && direction != .DOWN { playerDirection = direction }
        else if playerDirection == .DOWN && direction != .UP { playerDirection = direction }
    }
    
    private func updatePlayerPosition() {
        var xChange = 0
        var yChange = 0
        if playerDirection == .LEFT {
            xChange = -1
        } else if playerDirection == .RIGHT {
            xChange = 1
        } else if playerDirection == .UP {
            yChange = -1
        } else if playerDirection == .DOWN {
            yChange = 1
        }
        
        if playerPositions.count > 0 {
            if playerDirection == .DIED {
                playerPositions.removeLast()
            } else {
                var start = playerPositions.count - 1
                while start > 0 {
                    playerPositions[start] = playerPositions[start - 1]
                    start -= 1
                }
                playerPositions[0] = Point(
                    playerPositions[0].x + xChange,
                    playerPositions[0].y + yChange
                )
            }
        }
        if playerPositions.count > 0 {
            let x = playerPositions[0].x
            let y = playerPositions[0].y
            if y >= numRows {
                playerPositions[0].y = 0
            } else if y < 0 {
                playerPositions[0].y = numRows - 1
            }
            if x >= numCols {
                playerPositions[0].x = 0
            } else if x < 0 {
                playerPositions[0].x = numCols - 1
            }
        }
        renderChange()
    }
    
    func checkForScore() {
        if scorePos != nil && playerPositions.count > 0 {
            let playerPos: Point = playerPositions[0]
            if playerPos.equals(scorePos!) {
                currentScore += 1
                scene.currentScore.text = "Score: \(currentScore)"
                generateNewScorePos()
                playerPositions.append(playerPositions.last!)
                snakeEmojis.append(emojis[currentEmoji])
                currentEmoji += 1
                ScoreManager.shared.addPoints(1)
                if currentEmoji > 70 {
                    currentEmoji = 0
                }
            }
        }
    }
    
    func generateNewScorePos() {
        var p: Point? = nil
        while p == nil || contains(allPoint: playerPositions, point: p!) {
            p = Point(Int.random(in: 0 ..< numCols), Int.random(in: 0 ..< numRows))
        }
        scorePos = p!
    }
    
    func checkPlayerDied() {
        if playerPositions.count > 0 {
            var positions = playerPositions.filter { _ in return true }
            let headSnake = positions[0]
            positions.remove(at: 0)
            if contains(allPoint: positions, point: headSnake) {
                changeDirection(.DIED)
                return
            }
        }
    }
    
    func renderChange() {
        for (node, point) in scene.gameArray {
            let isScorePos = scorePos != nil && point.equals(scorePos!)
            let isPlayerPos = contains(allPoint: playerPositions, point: point)
            
            if isPlayerPos && playerDirection != .DIED {
                node.id = 1
                node.emojiLabel.text = snakeEmojis[playerPositions.firstIndex(of: point)!]
            } else if isScorePos {
                node.id = -2
                node.emojiLabel.text = emojis[currentEmoji]
            } else if isPlayerPos && playerDirection == .DIED {
                node.id = 0
                node.emojiLabel.text = "🤡"
            } else {
                node.id = -1
                node.emojiLabel.text = " "
            }
        }
    }
    
    func contains(allPoint: [Point], point: Point) -> Bool {
        for p in allPoint {
            if point.x == p.x && point.y == p.y { return true }
        }
        return false
    }
}
