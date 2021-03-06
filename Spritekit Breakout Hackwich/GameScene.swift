//
//  GameScene.swift
//  Spritekit Breakout Hackwich
//
//  Created by Jean Cho on 7/12/18.
//  Copyright © 2018 Jean Cho. All rights reserved.
//


import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball = SKShapeNode()
    var paddle = SKSpriteNode()
    var bricksArray = [SKSpriteNode]() //make this an array
    var loseZone = SKSpriteNode()
    var startButton = SKLabelNode()
    var lives = SKLabelNode()
    var numLives = 3
    var removedBricks = 0
    
    
    override func didMove(to view: SKView) {
        //ball recognizes sides
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        createBackground()
        makeBall()
        makePaddle()
        makeBrick()
        makeLoseZone()
        makeStartButton()
        makeLivesLabel()
        
    }
    
    //Background
    func createBackground () {
        let stars = SKTexture(imageNamed: "stars")
        for i in 0...1 {
            let starsBackground = SKSpriteNode(texture: stars)
            starsBackground.zPosition = -1
            starsBackground.position = CGPoint(x: 0, y: starsBackground.size.height * CGFloat(i))
            addChild(starsBackground)
            //below: adding a second view of the stars background below the actual screen and moving it up forever ; background isn't actually a moving gif
            let moveDown = SKAction.moveBy(x: 0, y: -starsBackground.size.height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y: starsBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            starsBackground.run(moveForever)
        }
    }
    
    func makeStartButton () {
        //startButton = SKLabelNode(color: .clear, size: CGSize(width: frame.width/3, height: 50))
        startButton.position = CGPoint(x: frame.midX, y: frame.midY)
        startButton.text = "Tap to Start"
        startButton.color = .clear
        startButton.fontColor = .white
        startButton.fontSize = 40
        startButton.name = "start button"
        
        addChild(startButton)
    }
    
    
    func makeBall() {
        ball = SKShapeNode(circleOfRadius: 10) //creating ball
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.strokeColor = .yellow
        ball.fillColor = .yellow
        ball.name = "ball"
        
        
        //DECLARING BALL's PHYSICS PROPERTIES
        // physics shape matches ball image
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        // ignores all forces and impulses
        ball.physicsBody?.isDynamic = false
        // use precise collision detection
        ball.physicsBody?.usesPreciseCollisionDetection = true
        // no loss of energy from friction
        ball.physicsBody?.friction = 0
        // gravity is not a factor
        ball.physicsBody?.affectedByGravity = false
        // bounces fully off of other objects
        ball.physicsBody?.restitution = 1
        // does not slow down over time
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
        ball.physicsBody?.isResting = false
        
        addChild(ball) // add ball object to the view
    }
    
    func makePaddle() {
        paddle = SKSpriteNode(color: UIColor.white, size: CGSize(width: frame.width/4, height: 20))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        addChild(paddle)
    }
    
    
    
    func makeBrick() {
        //removing leftover bricks
        for brick in bricksArray {
            if brick.parent != nil {
                brick.removeFromParent()
            }
        }
        bricksArray.removeAll() //clearing array
        removedBricks = 0
        
        let bWidth = (frame.width / 5) - 30
        for xIndex in stride(from: frame.minX - (bWidth / 2), to: frame.maxX, by: bWidth + 5) {
            let brick = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 50, height: 20))
            brick.position = CGPoint(x: xIndex, y: frame.maxY - 30)
            
            brick.size = CGSize(width: bWidth, height: 20)
            brick.name = "brick"
            brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
            brick.physicsBody?.isDynamic = false
            bricksArray.append(brick)
            addChild(brick)
        }
        for xIndex in stride(from: frame.minX - (bWidth / 2), to: frame.maxX, by: bWidth + 5) {
            let brick = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 50, height: 20))
            brick.position = CGPoint(x: xIndex, y: frame.maxY - 60)
            
            brick.size = CGSize(width: bWidth, height: 20)
            brick.name = "brick"
            brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
            brick.physicsBody?.isDynamic = false
            bricksArray.append(brick)
            addChild(brick)
        }
        for xIndex in stride(from: frame.minX - (bWidth / 2), to: frame.maxX, by: bWidth + 5) {
            let brick = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 50, height: 20))
            brick.position = CGPoint(x: xIndex, y: frame.maxY - 90)
            
            brick.size = CGSize(width: bWidth, height: 20)
            brick.name = "brick"
            brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
            brick.physicsBody?.isDynamic = false
            bricksArray.append(brick)
            addChild(brick)
        }
        
        
    }
    
    
    
    func makeLoseZone() {
        loseZone = SKSpriteNode(color: .red, size: CGSize(width: frame.width, height: 50))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "loseZone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        addChild(loseZone)
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //when you first touch the paddle
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x //only x so the paddle can't move vertically
        }
        //start button
        for startButtonTouch in touches {
            startButton.isHidden = true
            if startButton.isHidden == true {
                ball.physicsBody?.isDynamic = true
                ball.physicsBody?.applyImpulse(CGVector(dx: 3, dy: 5)) //dx = x magnitude, dy = y magnitude
            }
            
        }
        
    }
    
    //as you keep touching the paddle
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x //only x so the paddle can't move veritcally
        }
        for startButtonTouch in touches {
            startButton.isHidden = true
            if startButton.isHidden == true {
                
            }
        }
    }
    
    //declaring winner/loser
    func didBegin(_ contact: SKPhysicsContact) {
        for brick in bricksArray {
            if contact.bodyA.node == brick || contact.bodyB.node == brick {
                //numLives += 1
                //call update labels func here
                if brick.color == .blue {
                    brick.color = .red
                }
                else if brick.color == .red {
                    brick.color = .green
                }
                else {
                    brick.removeFromParent()
                    removedBricks += 1
                    if removedBricks == bricksArray.count {
                        lives.text = "You win!"
                        print("You win!")
                    }
                    
                }
            }
        }
        
        //if it hits the losing thing and user only has one life
        if contact.bodyA.node?.name == "loseZone" &&  numLives == 1 ||
            contact.bodyB.node?.name == "loseZone" &&  numLives == 1 {
            lives.text = "You lose"
            print("You lose!")
            ball.removeFromParent() //removes ball from game
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.restart()
            }
            
        }
        // if it hits the losing thing and user has 3 or 2 lives
        if contact.bodyA.node?.name == "loseZone" &&  numLives != 1 ||
            contact.bodyB.node?.name == "loseZone" &&  numLives != 1 {
            numLives = numLives - 1
            lives.text = "Lives: \(numLives)"
            print(numLives)
            ball.removeFromParent()
            makeBall()
        }
    }
    
    func restart() {
        makeBrick()
        numLives = 3
        lives.text = "Lives: 3"
        makeBall()
        
        
    }
    
    func makeLivesLabel() {
        lives.position = CGPoint(x: loseZone.position.x, y: loseZone.position.y)
        lives.text = "Lives: \(numLives)"
        lives.color = .clear
        lives.fontColor = .black
        lives.fontSize = 25
        lives.name = "lives"
        lives.fontName = "Arial"
        
        addChild(lives)
    }
}
