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
    
    // Gesture nodes
    var tapIcon: SKSpriteNode!
    var upIcon: SKSpriteNode!
    var downIcon: SKSpriteNode!
    
    // Game
    var inGame: Bool = false
    
    override func didMove(to view: SKView) {
        setScreenSize()
        setPlayNode()
        setGestures()
    }
    
    func setScreenSize() {
        myWidth = self.size.width
        myHeight = self.size.height
    }
    
    func setPlayNode() {
        let playTexture = SKTexture(imageNamed: "playButton.png")
        playNode = SKSpriteNode(texture: playTexture)
        playNode.name = "playNode"
        
        let newWidth = myWidth * 1/5
        let newHeight = playNode.size.height * (newWidth / playNode.size.width)
        playNode.size = CGSize(width: newWidth, height: newHeight)
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
            
            // start game here
        }
    }
    
    func setGestures() {
        let tapTexture = SKTexture(imageNamed: "tapPicture.png")
        tapIcon = SKSpriteNode(texture: tapTexture)
        
        let tapWidth = myWidth * 1/6
        let tapHeight = tapIcon.size.height * (tapWidth / tapIcon.size.width)
        tapIcon.size = CGSize(width: tapWidth, height: tapHeight)
        tapIcon.position = CGPoint(x: myWidth*3/12, y: myHeight * 2/5)
        tapIcon.alpha = 0.2
        self.addChild(tapIcon)
        
        
        let upTexture = SKTexture(imageNamed: "up.png")
        upIcon = SKSpriteNode(texture: upTexture)
        
        let upHeight = tapHeight
        let upWidth = upIcon.size.width * (tapHeight / upIcon.size.height)
        upIcon.size = CGSize(width: upWidth, height: upHeight)
        upIcon.position = CGPoint(x: myWidth*6/12, y: myHeight * 2/5)
        upIcon.alpha = 0.2
        self.addChild(upIcon)
        
        
        let downTexture = SKTexture(imageNamed: "down.png")
        downIcon = SKSpriteNode(texture: downTexture)
        
        downIcon.size = upIcon.size
        downIcon.position = CGPoint(x: myWidth*9/12, y: myHeight * 2/5)
        downIcon.alpha = 0.2
        self.addChild(downIcon)
    }
    
    func tapAnimation() {
        let actions: [SKAction] = [
            SKAction.fadeAlpha(to: 1, duration: 0.2),
            SKAction.fadeAlpha(to: 0.2, duration: 0.2)
        ]
        tapIcon.run(SKAction.sequence(actions))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!inGame) {
            let touch: UITouch = touches.first! as UITouch
            let positionInScene = touch.location(in: self.scene!)
            let touchedNodes = self.scene!.nodes(at: positionInScene)
            
            for node in touchedNodes {
                if (node.name == "playNode") {
                    tappedPlayButton()
                    return
                }
            }
            
            tapAnimation()
        }
        
        // if is in game -----------------------------------------
        
        
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
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 700, height: 500))
let scene = GameScene(size: CGSize(width: 700, height: 500))
scene.scaleMode = .aspectFill
scene.backgroundColor = SKColor.white
sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
