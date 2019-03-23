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
    
    // Gesture
    var tapIcon: SKSpriteNode!
    var upIcon: SKSpriteNode!
    var downIcon: SKSpriteNode!
    var spaceText: SKLabelNode = SKLabelNode()
    var spacePressed: Int = 0
    
    // Game
    var inGame: Bool = false
    var gameText: SKLabelNode = SKLabelNode()
    
    override func didMove(to view: SKView) {
        setScreenSize()
        setPlayNode()
        setGestures()
        setSpaceLabel()
    }
    
    func setSpaceLabel() {
        spaceText.text = "(space)"
        spaceText.fontName = "Helvetica Neue"
        spaceText.fontSize = 18
        spaceText.fontColor = SKColor.black
        spaceText.position = tapIcon.position
        spaceText.position.y -= (tapIcon.size.height/2 + 50)
        self.addChild(spaceText)
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
        
        let enterText = SKLabelNode()
        enterText.text = "Enter"
        enterText.fontName = "Helvetica Neue"
        enterText.fontSize = 24
        enterText.fontColor = SKColor.black
        playNode.addChild(enterText)
        enterText.position.x += playNode.size.width
        enterText.position.y -= 5
        
        let actions: [SKAction] = [
            SKAction.fadeAlpha(to: 0, duration: 1),
            SKAction.wait(forDuration: 0.2),
            SKAction.fadeAlpha(to: 1, duration: 1),
            SKAction.wait(forDuration: 0.3)
        ]
        enterText.run(SKAction.repeatForever(SKAction.sequence(actions)))
    }
    
    func tappedPlayButton() {
        playNode.run(SKAction.scale(to: 0.85, duration: 0.2))
        playTouched = true
    }
    
    func setGame() {
        inGame = true
        
        let actions: [SKAction] = [
            SKAction.fadeOut(withDuration: 0.6),
            SKAction.removeFromParent()
        ]
        
        playNode.run(SKAction.sequence(actions))
        tapIcon.run(SKAction.sequence(actions))
        upIcon.run(SKAction.sequence(actions))
        downIcon.run(SKAction.sequence(actions))
        
        if (spacePressed < 2) {
            spaceText.run(SKAction.sequence(actions))
        }
        
        self.run(SKAction.wait(forDuration: 0.7)) {
            self.startGame()
        }
    }
    
    func startGame() {
        gameText.text = "follow the beat"
        gameText.fontName = "Helvetica Neue"
        gameText.fontSize = 30
        gameText.fontColor = SKColor.black
        gameText.position = CGPoint(x: myWidth/2, y: myHeight * 4/5)
        self.addChild(gameText)
    }
    
    func setGestures() {
        let tapTexture = SKTexture(imageNamed: "tapPicture.png")
        tapIcon = SKSpriteNode(texture: tapTexture)
        
        let tapWidth = myWidth * 1/6
        let tapHeight = tapIcon.size.height * (tapWidth / tapIcon.size.width)
        tapIcon.size = CGSize(width: tapWidth, height: tapHeight)
        tapIcon.position = CGPoint(x: myWidth*6/12, y: myHeight * 2/5)
        tapIcon.alpha = 0.2
        self.addChild(tapIcon)
        
        
        let upTexture = SKTexture(imageNamed: "up.png")
        upIcon = SKSpriteNode(texture: upTexture)
        
        let upHeight = tapHeight
        let upWidth = upIcon.size.width * (tapHeight / upIcon.size.height)
        upIcon.size = CGSize(width: upWidth, height: upHeight)
        upIcon.position = CGPoint(x: myWidth*3/12, y: myHeight * 2/5)
        upIcon.alpha = 0.2
        self.addChild(upIcon)
        
        
        let downTexture = SKTexture(imageNamed: "down.png")
        downIcon = SKSpriteNode(texture: downTexture)
        
        downIcon.size = upIcon.size
        downIcon.position = CGPoint(x: myWidth*9/12, y: myHeight * 2/5)
        downIcon.alpha = 0.2
        self.addChild(downIcon)
        
    }
    
    func upAnimation() {
        if (inGame) {
            // do sth
            return
        }
        
        if (playTouched) {
            playNode.run(SKAction.scale(to: 1, duration: 0.2))
            playTouched = false
            return
        }
        
        let actions: [SKAction] = [
            SKAction.fadeAlpha(to: 1, duration: 0.2),
            SKAction.fadeAlpha(to: 0.2, duration: 0.2)
        ]
        upIcon.run(SKAction.sequence(actions))
        self.run(SKAction.playSoundFileNamed("up.wav", waitForCompletion: false))
    }
    
    func downAnimation() {
        if (inGame) {
            // do sth
            return
        }
        
        if (playTouched) {
            playNode.run(SKAction.scale(to: 1, duration: 0.2))
            playTouched = false
            return
        }
        
        let actions: [SKAction] = [
            SKAction.fadeAlpha(to: 1, duration: 0.2),
            SKAction.fadeAlpha(to: 0.2, duration: 0.2)
        ]
        downIcon.run(SKAction.sequence(actions))
        self.run(SKAction.playSoundFileNamed("down.wav", waitForCompletion: false))
    }
    
    func tapAnimation() {
        let actions: [SKAction] = [
            SKAction.fadeAlpha(to: 1, duration: 0.2),
            SKAction.fadeAlpha(to: 0.2, duration: 0.2)
        ]
        tapIcon.run(SKAction.sequence(actions))
        self.run(SKAction.playSoundFileNamed("lol.wav", waitForCompletion: false))
    }
    
    override func keyDown(with event: NSEvent) {
        let keyCode = event.keyCode
        print(keyCode)
        
        if (!inGame) {
            switch (keyCode) {
            case 49: // space
                tapAnimation()
                spacePressed += 1
                if (spacePressed == 2) {
                    spaceText.run(SKAction.fadeOut(withDuration: 0.5)) {
                        self.spaceText.removeFromParent()
                    }
                }
            case 126: // up
                upAnimation()
            case 125: // down
                downAnimation()
            case 36: // enter
                tappedPlayButton()
                setGame()
            default:
                return
            }
            return
        }
        
        
        
        
    }
    
    override func mouseDown(with event: NSEvent) {
        if (!inGame) {
            let positionInScene = event.location(in: self)
            let touchedNodes = self.scene!.nodes(at: positionInScene)
            
            for node in touchedNodes {
                if (node.name == "playNode") {
                    tappedPlayButton()
                    return
                }
            }
            return
        }
        
        // if is in game -----------------------------------------
    }
    
    override func mouseUp(with event: NSEvent) {
        if (!inGame) {
            if (playTouched) {
                let positionInScene = event.location(in: self)
                let touchedNodes = self.scene!.nodes(at: positionInScene)
                
                for node in touchedNodes {
                    if (node.name == "playNode") {
                        setGame()
                        return
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
