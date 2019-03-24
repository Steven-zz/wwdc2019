//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

class Beat {
    var iconName: String
    var keyCode: UInt16
    var soundName: String
    var nextBeat: Double
    
    init(iconName: String, keyCode: UInt16, soundName: String, nextBeat: Double) {
        self.iconName = iconName
        self.keyCode = keyCode
        self.soundName = soundName
        self.nextBeat = nextBeat
    }
}

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
        gameText.text = "listen to the beat"
        gameText.fontName = "Helvetica Neue"
        gameText.fontSize = 30
        gameText.fontColor = SKColor.black
        gameText.position = CGPoint(x: myWidth/2, y: myHeight * 4/5)
        self.addChild(gameText)
        
        self.run(SKAction.wait(forDuration: 1)) {
            self.startBeats()
        }
    }
    
    var beatTimer: Timer? = nil
    var index: Int = 0
    var currCounter: Double = 0
    var currTime: Double = 0
    var totalTime: Double!
    var beats: [Beat] = []
    var beatsNodes: [SKSpriteNode] = []
    var bar: SKShapeNode!
    var progress: SKShapeNode!
    var streak: Int = 0

    var playTimer: Timer? = nil
    
    func startBeats() {
        let temp = [
            Beat(iconName: "down.png", keyCode: 125, soundName: "down.wav", nextBeat: 1/2),
            Beat(iconName: "up.png", keyCode: 126, soundName: "up.wav", nextBeat: 1/2),
            Beat(iconName: "tapPicture.png", keyCode: 49, soundName: "tap.wav", nextBeat: 1/2),
        ]
        beats.removeAll()
        
        for _ in 1 ... 4 {
            let randomIndex = Int.random(in: 0 ..< temp.count)
            beats.append(temp[randomIndex])
        }
        
        currTime = 0
        currCounter = 0
        currPlayCounter = 0
        totalTime = 0
        isPressable = true
        
        for beat in beats {
            totalTime += beat.nextBeat
        }
        
        bar = SKShapeNode(rectOf: CGSize(width: 420, height: 5))
        bar.strokeColor = SKColor.clear
        bar.fillColor = SKColor.lightGray
        bar.position = CGPoint(x: myWidth/2, y: myHeight * 3/6)
        bar.alpha = 0
        self.addChild(bar)
        
        var beatTime: Double = 0
        beatsNodes.removeAll()
        for beat in beats {
            beatTime += beat.nextBeat
            
            let point = SKShapeNode(rectOf: CGSize(width: 5, height: 12))
            point.fillColor = SKColor.darkGray
            point.strokeColor = SKColor.white
            let xPos = bar.frame.width * CGFloat(beatTime/totalTime) - bar.frame.width/2
            point.position = CGPoint(x: xPos, y: 0)
            point.zPosition = 12
            bar.addChild(point)
            
            let texture = SKTexture(imageNamed: beat.iconName)
            let node = SKSpriteNode(texture: texture)
            
            let newHeight: CGFloat = 26
            let newWidth = node.size.width * (newHeight/node.size.height)
            node.size = CGSize(width: newWidth, height: newHeight)
            node.position = point.position
            node.position.y = node.size.height*3/2
            node.alpha = 0.2
            bar.addChild(node)
            
            if (streak >= 3) {
                node.alpha = 0
            }
            
            beatsNodes.append(node)
        }
        
        bar.run(SKAction.wait(forDuration: totalTime - 1/2)) {
            self.bar.run(SKAction.fadeIn(withDuration: 0.3))
        }
        
        performBeat()
        beatTimer = Timer.scheduledTimer(timeInterval: 1/4, target: self, selector: #selector(self.performBeat), userInfo: nil, repeats: true)
    }
    
    @objc func performBeat() {
        if (currCounter == beats[index].nextBeat) {
            self.run(SKAction.playSoundFileNamed(beats[index].soundName, waitForCompletion: false))
            
            currCounter = 0
            index += 1
            
            if (index >= beats.count) {
                beatTimer?.invalidate()
                beatTimer = nil
                currTime = 0
                index = 0
                
                gameText.text = "your turn"
                
                progress = SKShapeNode(rectOf: CGSize(width: 1, height: 5))
                progress.strokeColor = SKColor.clear
                progress.fillColor = SKColor.black
                progress.position = bar.position
                progress.position.x -= 210
                progress.zPosition = 10
                
                let progressActions: [SKAction] = [
                    SKAction.scaleX(to: 420, duration: totalTime),
                    SKAction.move(to: bar.position, duration: totalTime)
                ]
                
                self.run(SKAction.wait(forDuration: 1/2)) {
                    self.progress.run(SKAction.group(progressActions))
                    self.play()
                    self.playTimer = Timer.scheduledTimer(timeInterval: 1/4, target: self, selector: #selector(self.play), userInfo: nil, repeats: true)
                }
                self.addChild(progress)
            }
        }
        
        currCounter += 1/4
        currTime += 1/4
    }
    
    var isPressable: Bool = true
    var correct: Int = 0
    var currPlayCounter: Double = 0
    var beatCorrect: Bool = false
    
    @objc func play() {
        if (currPlayCounter == beats[index+1].nextBeat) {
            currPlayCounter = 0
            isPressable = true
            
            if (beatCorrect) {
//                beatsNodes[index].alpha = 1
            }
            else {
                let wrongTexture = SKTexture(imageNamed: "wrong.png")
                let wrongNode = SKSpriteNode(texture: wrongTexture)
                wrongNode.size = CGSize(width: 13, height: 13)
                wrongNode.zPosition = 20
                wrongNode.position = beatsNodes[index].position
                wrongNode.position.x += (beatsNodes[index].size.width/2 + 10)
                wrongNode.position.y += beatsNodes[index].size.height/2
                bar.addChild(wrongNode)
                print("wrong")
            }
            
            index += 1
            
            if (index >= (beats.count-1)) {
                playTimer?.invalidate()
                playTimer = nil
                isPressable = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1/2) {
                    if (!self.beatCorrect) {
                        let wrongTexture = SKTexture(imageNamed: "wrong.png")
                        let wrongNode = SKSpriteNode(texture: wrongTexture)
                        wrongNode.size = CGSize(width: 13, height: 13)
                        wrongNode.zPosition = 20
                        wrongNode.position = self.beatsNodes[self.index].position
                        wrongNode.position.x += (self.beatsNodes[self.index].size.width/2 + 10)
                        wrongNode.position.y += self.beatsNodes[self.index].size.height/2
                        self.bar.addChild(wrongNode)
                        self.isPressable = false
                        print("wrong here")
                        self.gameText.text = "let's try again"
                        self.streak = 0
                    }
                    else {
                        if (self.correct == self.beats.count) {
                            self.streak += 1
                            if (self.streak >= 3) {
                                self.gameText.text = "streak : \(self.streak), no icons"
                            }
                            self.gameText.text = "congratulations, streak : \(self.streak)"
                        }
                        else {
                            self.streak = 0
                        }
                    }
                    
                    self.run(SKAction.wait(forDuration: 1/2)) {
                        self.startBeats()
                    }
                    
                    self.bar.run(SKAction.fadeOut(withDuration: 0.5))
                    self.progress.run(SKAction.fadeOut(withDuration: 0.5))
                    self.correct = 0
                    self.index = 0
                }
            }
            beatCorrect = false
        }
        currPlayCounter += 1/4
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
//        print(keyCode)
        
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
        
        if (isPressable) {
            if (keyCode == beats[index].keyCode) {
                beatsNodes[index].alpha = 1
                correct += 1
                beatCorrect = true
                self.run(SKAction.playSoundFileNamed(beats[index].soundName, waitForCompletion: false))
                isPressable = false
            }
            else {
                isPressable = false
            }
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
