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
    var tapIcon: SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        setScreenSize()
        setPlayNode()
    }
    
    func setScreenSize() {
        myWidth = self.size.width
        myHeight = self.size.height
    }
    
    func setPlayNode() {
        let playTexture = SKTexture(imageNamed: "playButton.png")
        playNode = SKSpriteNode(texture: playTexture)
        playNode.name = "playNode"
        
        let newWidth = myWidth * 2/5
        let newHeight = playNode.size.height * (newWidth / playNode.size.width)
        playNode.size = CGSize(width: newWidth, height: newHeight)
//        playNode.size = CGSize(width: myWidth/4, height: myHeight/4)
        playNode.position = CGPoint(x: myWidth/2, y: myHeight * 4/5)
        self.addChild(playNode)
    }
    
    func tappedPlayButton() {
        playNode.run(SKAction.scale(to: 0.85, duration: 0.2))
        playTouched = true
    }
    
    func gameStart() {
        inGame = true
        
        playNode.run(SKAction.fadeOut(withDuration: 0.3)) {
            self.playNode.removeFromParent()
            
            self.setGestures()
        }
    }
    
    func setGestures() {
        let tapTexture = SKTexture(imageNamed: "tapPicture.png")
        tapIcon = SKSpriteNode(texture: tapTexture)
        
        let newWidth = myWidth * 1/5
        let newHeight = tapIcon.size.height * (newWidth / tapIcon.size.width)
        tapIcon.size = CGSize(width: newWidth, height: newHeight)
        tapIcon.position = CGPoint(x: myWidth*1/6, y: myHeight/2)
        tapIcon.alpha = 0.4
        self.addChild(tapIcon)
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
            return
        }
        
        // if is in game -----------------------------------------
        tapIcon.run(SKAction.fadeAlpha(to: 1, duration: 0.2)) {
            self.tapIcon.run(SKAction.fadeAlpha(to: 0.4, duration: 0.2))
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
            return
        }
        
        // if is in game -----------------------------------------
        
        
    }
}






// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 500, height: 500))
let scene = GameScene(size: CGSize(width: 500, height: 500))
scene.scaleMode = .aspectFill
scene.backgroundColor = SKColor.white
sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
