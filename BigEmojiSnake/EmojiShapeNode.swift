import SpriteKit

class EmojiShapeNode: SKShapeNode {
    var id: Int
    var emojiLabel: SKLabelNode

    init(id: Int, emoji: String) {
        self.id = id

        emojiLabel = SKLabelNode(fontNamed: "Avenir Next")
        emojiLabel.fontSize = 24
        emojiLabel.text = emoji
        emojiLabel.horizontalAlignmentMode = .center
        emojiLabel.verticalAlignmentMode = .center

        super.init()

        addChild(emojiLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
