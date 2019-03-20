//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

class GameScene: SKScene {
    
    // Screen size
    var myWidth: CGFloat!
    var myHeight: CGFloat!
    
    // Play node
    var playNode: SKSpriteNode!
    var playTouched: Bool = false
    
    // Game
    var inGame: Bool = false
    
    override func didMove(to view: SKView) {
        setScreenSize()
        setPlayNode()
    }
    
    func setScreenSize() {
        myWidth = self.size.width
        myHeight = self.size.height
    }
    
    func setPlayNode() {
        let playTexture = SKTexture(imageNamed: "play.png")
        playNode = SKSpriteNode(texture: playTexture)
        playNode.name = "playNode"
        
        playNode.size = CGSize(width: myWidth/4, height: myHeight/4)
        playNode.position = CGPoint(x: myWidth/2, y: myHeight/2)
        addChild(playNode)
    }
    
    func tappedPlayButton() {
        playNode.run(SKAction.scale(to: 0.85, duration: 0.2))
        playTouched = true
    }
    
    func gameStart() {
        playNode.run(SKAction.fadeOut(withDuration: 0.3)) {
            self.playNode.removeFromParent()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!inGame) {
            let touch: UITouch = touches.first! as UITouch
            let positionInScene = touch.location(in: self.scene!)
            let touchedNodes = self.scene!.nodes(at: positionInScene)
            
            for node in touchedNodes {
                if (node.name == "playNode") {
                    tappedPlayButton()
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!inGame) {
            if (playTouched) {
                let touch: UITouch = touches.first! as UITouch
                let positionInScene = touch.location(in: self.scene!)
                let touchedNodes = self.scene!.nodes(at: positionInScene)
                
                for node in touchedNodes {
                    if (node.name == "playNode") {
                        gameStart()
                    }
                }
                playNode.run(SKAction.scale(to: 1, duration: 0.2))
            }
            playTouched = false
        }
    }
}






// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 500, height: 500))
let scene = GameScene(size: CGSize(width: 500, height: 500))
scene.scaleMode = .aspectFill
scene.backgroundColor = SKColor.white
sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
