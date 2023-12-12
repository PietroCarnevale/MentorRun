//
//  GameScene.swift
//  G2
//
//  Created by Pietro Carnevale on 06/12/23.
//

import SpriteKit
import GameplayKit
import SwiftUI

struct PhysicsCategory {
    
    static let none : UInt32 = 0
    static let all : UInt32 = UInt32.max
    static let player : UInt32 = 0b1
    static let student : UInt32 = 0b10
    
    // CIAO
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var background1: SKSpriteNode!
    var background2: SKSpriteNode!
    var player: SKSpriteNode!
    var isJumping: Bool = false
    var hearts: Int = 3
    let backgroundSpeed: CGFloat = 3.0
    var scoreLabel: SKLabelNode!
    var score:Int = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        self.setUp()
        self.startStudentsCycle()
        
    }
    
    func setUp() {
        
        physicsWorld.contactDelegate = self
        
        background1 = SKSpriteNode(imageNamed: "background_1")
        background1.position = CGPoint(x: 0, y: 0)
        background1.zPosition = -1
        background1.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        
        self.addChild(background1)
        
        background2 = SKSpriteNode(imageNamed: "background_2")
        background2.position = CGPoint(x: background1.size.width, y: 0)
        background2.zPosition = -1
        background2.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        
        self.addChild(background2)
        
        player = SKSpriteNode(imageNamed: "player_1")
        player.name = "player"
        player.position = CGPoint(x: -self.frame.size.width / 2 + 100, y: -self.frame.size.height / 2 + 64)
        player.size = CGSize(width: 64, height: 64)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width / 2, height: player.size.height))
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.student
        player.physicsBody?.collisionBitMask = PhysicsCategory.student
        
        let animationAction = SKAction.animate(with: [SKTexture(imageNamed: "player_1"), SKTexture(imageNamed: "player_2"), SKTexture(imageNamed: "player_3"), SKTexture(imageNamed: "player_4"), SKTexture(imageNamed: "player_5"), SKTexture(imageNamed: "player_6"), SKTexture(imageNamed: "player_7"), SKTexture(imageNamed: "player_8"),], timePerFrame: 0.10)
        let runAction = SKAction.repeatForever(animationAction)
        player.run(runAction)
        
        self.addChild(player)
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 0, y: self.frame.size.height / 2 - 50)
        scoreLabel.fontName = "AmericanTypewriter"
        scoreLabel.fontSize = 32
        scoreLabel.fontColor = UIColor.white
        score = 0
        
        self.addChild(scoreLabel)
        
    }
    
    func startStudentsCycle() {
        var num: Double = 2.0
        
        let createStudentAction = SKAction.run(createStudent)
        let randomNumberAction = SKAction.run {
            num = Double(Int.random(in: 2...5))
        }
        let waitAction = SKAction.wait(forDuration: num)
        
        let createAndWaitAction = SKAction.sequence([createStudentAction, waitAction])
        let studentCycleAction = SKAction.repeatForever(createAndWaitAction)
        
        run(studentCycleAction)
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveBackground()
        if (hearts == 0) {
            showGameOverScreen()
        }
    }
    
    func moveBackground() {
        
        background1.position.x -= backgroundSpeed
        background2.position.x -= backgroundSpeed
        
        if background1.position.x <= -background1.size.width {
            background1.position.x = background2.position.x + background2.size.width
        }
        
        if background2.position.x <= -background2.size.width {
            background2.position.x = background1.position.x + background1.size.width
        }
        
    }
    
}
    
// MARK: - User Interaction

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!isJumping){
            playerJump()
        }
    }
    
    func playerJump() {
        isJumping = true
        
        let jumpUpAction = SKAction.moveBy(x: 0, y: 100, duration: 0.3)
        let stayUpAction = SKAction.moveBy(x: 0, y: 20 , duration: 0.1)
        let StayDownAction = SKAction.moveBy(x: 0, y: -20, duration: 0.1)
        let jumpDownAction = SKAction.moveBy(x: 0, y: -100, duration: 0.3)
        let jumpSequence = SKAction.sequence([jumpUpAction, stayUpAction, StayDownAction, jumpDownAction])
        
        player.run(jumpSequence) {
            self.isJumping = false
        }
    }
}

// MARK: - Students

extension GameScene {
    
    private func createStudent() {
        newStudent()
    }
    
    private func newStudent() {
        let i = Int.random(in: 1...4)
        let newStudent = SKSpriteNode(texture: SKTexture(imageNamed: "student\(i)_1"))
        newStudent.name = "student"
        newStudent.size = CGSize(width: 48, height: 48)
        newStudent.position = CGPoint(x: self.frame.size.width / 2 + 50, y: -self.frame.size.height / 2 + 60)
        
        newStudent.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: newStudent.size.width / 2, height: newStudent.size.height))
        newStudent.physicsBody?.affectedByGravity = false
        
        newStudent.physicsBody?.categoryBitMask = PhysicsCategory.student
        
        newStudent.physicsBody?.contactTestBitMask = PhysicsCategory.player
        newStudent.physicsBody?.collisionBitMask = PhysicsCategory.player
        
        addChild(newStudent)
        
        let animationAction = SKAction.animate(with: [SKTexture(imageNamed: "student\(i)_1"), SKTexture(imageNamed: "student\(i)_2"), SKTexture(imageNamed: "student\(i)_3"), SKTexture(imageNamed: "student\(i)_4"), SKTexture(imageNamed: "student\(i)_5"), SKTexture(imageNamed: "student\(i)_6"), SKTexture(imageNamed: "student\(i)_7"), SKTexture(imageNamed: "student\(i)_8"),], timePerFrame: 0.10)
        let moveAction = SKAction.moveBy(x: -self.frame.size.width - 50, y: 0, duration: 3.2)
        let removeAction = SKAction.removeFromParent()
        
        let animationSequence = SKAction.repeat(animationAction, count: 4)
        
        // Use group to run animation and movement simultaneously
        let groupAction = SKAction.group([animationSequence, moveAction])
        
        // Use sequence to ensure that removeAction is performed after groupAction
        let sequenceAction = SKAction.sequence([groupAction, removeAction])
        
        newStudent.run(sequenceAction) {
            self.score += 1
        }
        
    }
    
}

// MARK: - Contacts and Collisions

extension GameScene {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB
        
        if let node = firstBody.node, node.name == "student" {
            node.removeFromParent()
            hearts -= 1
        }
        if let node = secondBody.node, node.name == "student" {
            node.removeFromParent()
            hearts -= 1
        }
        
    }
    
}

// MARK: - GameOver

extension GameScene {
    
    struct GameOverWrapper: UIViewControllerRepresentable {
        
        var score: Int
        
        func makeUIViewController(context: Context) -> UIViewController {
            let hostingController = UIHostingController(rootView: GameOverView(score: score))
            return hostingController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            // Update the view controller if needed
        }
    }

    func showGameOverScreen() {
        let gameOverWrapper = GameOverWrapper(score: score)
        self.view?.window?.rootViewController?.present(
            UIHostingController(rootView: gameOverWrapper),
            animated: true,
            completion: nil
        )
    }
    
}
