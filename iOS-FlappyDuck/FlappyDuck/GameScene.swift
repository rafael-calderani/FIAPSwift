//
//  GameScene.swift
//  FlappyDuck
//
//  Created by Usuário Convidado on 06/10/17.
//  Copyright © 2017 Unknow. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let gameArea:CGFloat = 410.0
    lazy var floor = SKSpriteNode(imageNamed: "Chao")
    lazy var intro = SKSpriteNode(imageNamed: "Intro")
    lazy var player = SKSpriteNode(imageNamed: "Pato1")
    lazy var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    lazy var livesLabel = SKLabelNode(fontNamed: "Chalkduster")
    var velocity: Double = 100
    var score = 0
    var lives = 3
    var flyForce = 25.0
    var gameFinished = false
    var restart = false
    var gameStarted = false
    var timer: Timer!
    
    let playerCategory: UInt32 = 1
    let pipeAndFloorCategory: UInt32 = 2
    let scoreCategory: UInt32 = 4
    
    let scoreSound = SKAction.playSoundFileNamed("pontuou.mp3", waitForCompletion: false)
    let gameOverSound = SKAction.playSoundFileNamed("bateu.mp3", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        addBackground()
        addFloorAndRoof()
        moveFloor()
        addIntro()
        addPlayer()
    }
    
    func addBackground() {
        let bg = SKSpriteNode(imageNamed: "Fundo")
        bg.position = CGPoint(x: self.size.width/2, y: self.size.height - (self.size.height/2))
        bg.zPosition = 0
        addChild(bg)
    }
    
    func addFloorAndRoof() {
        floor.position = CGPoint(x: floor.size.width/2, y: self.size.height - gameArea - floor.size.height/2)
        floor.zPosition = 2
        addChild(floor)
        
        let invisibleFloor = SKNode()
        invisibleFloor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 1))
        invisibleFloor.physicsBody?.isDynamic = false
        invisibleFloor.physicsBody?.categoryBitMask = pipeAndFloorCategory
        invisibleFloor.physicsBody?.contactTestBitMask = playerCategory
        invisibleFloor.position = CGPoint(x: size.width/2, y: size.height - gameArea)
        invisibleFloor.zPosition = 2
        
        addChild(invisibleFloor)
        
        let invisibleRoof = SKNode()
        invisibleRoof.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 1))
        invisibleRoof.physicsBody?.isDynamic = false
        invisibleRoof.position = CGPoint(x: size.width/2, y: size.height)
        invisibleRoof.zPosition = 2
        
        addChild(invisibleRoof)
    }
    
    func moveFloor() {
        let duration = Double(floor.size.width/2)/velocity
        let moveFloorAction = SKAction.moveBy(x: -floor.size.width/2, y: 0, duration: duration)
        let resetXAction = SKAction.moveBy(x: floor.size.width/2, y: 0, duration: 0)
        let sequenceAction = SKAction.sequence([moveFloorAction, resetXAction])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        
        floor.run(repeatAction)
    }
    
    func addIntro() {
        intro.position = CGPoint(x: size.width/2, y: size.height - 210)
        intro.zPosition = 3
        
        addChild(intro)
    }
    
    func addPlayer() {
        player.position = CGPoint(x: 60, y: size.height - gameArea/2)
        player.zPosition = 4
        
        addPlayerActions()
        
        addChild(player)
    }
    
    func addPlayerActions() {
        
        var playerTextures = [SKTexture]()
        
        for i in 1..<4 {
            playerTextures.append(SKTexture(imageNamed: "Pato\(i)"))
        }
        
        let changeDuckAction = SKAction.animate(with: playerTextures, timePerFrame: 0.09)
        let repeatAction = SKAction.repeatForever(changeDuckAction)
        
        player.run(repeatAction)
    }
    
    func addLabels() {
        livesLabel.fontSize = 30
        livesLabel.text = "Lives: \(lives)"
        livesLabel.position = CGPoint(x: 80, y: size.height - 560)
        livesLabel.alpha = 0.8
        livesLabel.zPosition = 5
        
        scoreLabel.fontSize = 30
        scoreLabel.text = "Score: \(score)"
        scoreLabel.position = CGPoint(x: size.width-80, y: size.height - 560)
        scoreLabel.alpha = 0.8
        scoreLabel.zPosition = 5
        
        addChild(livesLabel)
        addChild(scoreLabel)
    }
    
    func restartGame() {
        timer.invalidate()
        player.zRotation = 0
        player.texture = SKTexture(imageNamed: "PatoBateu")
        run(gameOverSound)
        
        for node in self.children {
            node.removeAllActions()
            
            if node.name == "CanoCima" || node.name == "CanoBaixo" || node.name == "laser" {
                node.removeFromParent()
            }
        }
        
        player.physicsBody?.isDynamic = false
        gameStarted = false
        
        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { (timer) in
            let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
            gameOverLabel.name = "ggLabel"
            gameOverLabel.fontColor = .red
            gameOverLabel.fontSize = 30
            gameOverLabel.text = "Touch to continue"
            gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            gameOverLabel.zPosition = 5
            
            self.addChild(gameOverLabel)
        }
    }
    
    func gameOver() {
        timer.invalidate()
        player.zRotation = 0
        player.texture = SKTexture(imageNamed: "PatoBateu")
        run(gameOverSound)
        
        for node in self.children {
            node.removeAllActions()
        }
        
        player.physicsBody?.isDynamic = false
        gameFinished = true
        gameStarted = false
        
        Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { (timer) in
            let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
            gameOverLabel.fontColor = .red
            gameOverLabel.fontSize = 40
            gameOverLabel.text = "Game Over"
            gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            gameOverLabel.zPosition = 5
            
            self.addChild(gameOverLabel)
            self.restart = true
        }
    }
    
    func prepareForStart() {
        if lives == 3 {
            intro.removeFromParent()
            addLabels()
        }
        else {
            for node in self.children {
                if node.name == "ggLabel" {
                    node.removeFromParent()
                }
            }
            addPlayerActions()
            floor.position = CGPoint(x: floor.size.width/2, y: self.size.height - gameArea - floor.size.height/2)
            moveFloor()
        }
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2 - 10)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.allowsRotation = true
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.collisionBitMask = pipeAndFloorCategory
        player.physicsBody?.contactTestBitMask = scoreCategory
        
        timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true, block: { (timer) in
            let initialPosition = CGFloat(arc4random_uniform(132)+74)
            let pipesDistance = self.player.size.height * 2.5
            let upperPipe = SKSpriteNode(imageNamed: "CanoCima")
            upperPipe.name = "CanoCima"
            upperPipe.position = CGPoint(x: self.size.width + upperPipe.size.width/2, y: self.size.height - initialPosition + upperPipe.size.height/2)
            upperPipe.zPosition = 1
            upperPipe.physicsBody = SKPhysicsBody(rectangleOf: upperPipe.size)
            upperPipe.physicsBody?.isDynamic = false
            upperPipe.physicsBody?.categoryBitMask = self.pipeAndFloorCategory
            upperPipe.physicsBody?.contactTestBitMask = self.playerCategory
            
            let bottomPipe = SKSpriteNode(imageNamed: "CanoBaixo")
            bottomPipe.name = "CanoBaixo"
            bottomPipe.position = CGPoint(x: self.size.width + bottomPipe.size.width/2, y: upperPipe.position.y - upperPipe.size.height - pipesDistance)
            bottomPipe.zPosition = 1
            bottomPipe.physicsBody = SKPhysicsBody(rectangleOf: bottomPipe.size)
            bottomPipe.physicsBody?.isDynamic = false
            bottomPipe.physicsBody?.categoryBitMask = self.pipeAndFloorCategory
            bottomPipe.physicsBody?.contactTestBitMask = self.playerCategory
            
            let distance = self.size.width + upperPipe.size.width
            let duration = Double(distance)/self.velocity
            
            let laser = SKNode()
            laser.name = "laser"
            laser.position = CGPoint(x: upperPipe.position.x + upperPipe.size.width/2, y: upperPipe.position.y - upperPipe.size.height/2 - pipesDistance/2)
            laser.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: distance))
            laser.physicsBody?.isDynamic = false
            laser.physicsBody?.categoryBitMask = self.scoreCategory
            
            let movePipeAction = SKAction.moveBy(x: -distance, y: 0, duration: duration)
            let removeAction = SKAction.removeFromParent()
            let sequenceAction = SKAction.sequence([movePipeAction, removeAction])
            
            upperPipe.run(sequenceAction)
            bottomPipe.run(sequenceAction)
            laser.run(sequenceAction)
            
            self.addChild(upperPipe)
            self.addChild(bottomPipe)
            self.addChild(laser)
        })
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered (60fps)
        if !gameStarted { return }
        
        let yVelocity = player.physicsBody!.velocity.dy * 0.001 as CGFloat
        player.zRotation = yVelocity
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameFinished {
            if gameStarted { // fazer o pato voar
                player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
            }
            else { // comecar jogo
                prepareForStart()
                gameStarted = true
            }
        }
        else { // permitir restart
            if restart {
                restart = false
                
                let scene = GameScene(size: CGSize(width: gameWidth, height: gameHeight))
                scene.scaleMode = .aspectFill
                view!.presentScene(scene, transition: .doorway(withDuration: 1))
            }
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) { //fires on every contact
        if contact.bodyA.categoryBitMask == scoreCategory || contact.bodyB.categoryBitMask == scoreCategory {
            score += 1
            scoreLabel.text = "Score: \(score)"
            run(scoreSound)
        }
        else if contact.bodyA.categoryBitMask == pipeAndFloorCategory || contact.bodyB.categoryBitMask == pipeAndFloorCategory{
            
            lives -= 1
            livesLabel.text = "Lives: \(lives)"
            if (lives == 0) { gameOver() }
            else { restartGame() }
        }
    }
}
