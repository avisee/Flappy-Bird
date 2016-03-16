//
//  GameScene.swift
//  Flappy Bird Tutorial1
//
//  Created by zero2one on 2014/10/07.
//  Copyright (c) 2014年 Zero2One. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var background = SKSpriteNode()
    var bird = SKSpriteNode()
    var blockingdObjects = SKNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -6)
        
        self.addChild(blockingdObjects)
        
        //Background
        let backgroundTexture = SKTexture(imageNamed: "background.png")
        
        //Background Move
        let backgroundMove = SKAction.moveByX(-backgroundTexture.size().width, y: 0, duration: 6)
        let backgroundRest = SKAction.moveByX(backgroundTexture.size().width, y: 0, duration: 0)
        let backgroundSequence = SKAction.sequence([backgroundMove, backgroundRest])
        let backgroundRepeatForever = SKAction.repeatActionForever(backgroundSequence)
        
        for var i=0; i < 3; i++ {
            background = SKSpriteNode(texture: backgroundTexture)
            background.position = CGPoint(x: backgroundTexture.size().width/2 + backgroundTexture.size().width * CGFloat(i), y: CGRectGetMidY(self.frame))
            background.size.height = self.frame.height
            blockingdObjects.addChild(background)
            background.runAction(backgroundRepeatForever)
        }

        
        //Bird
        let birdTexture = SKTexture(imageNamed: "bird.png")
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height/2)
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.categoryBitMask = 1
        bird.physicsBody?.collisionBitMask = 2
        bird.physicsBody?.contactTestBitMask = 2
        
        self.addChild(bird)
        
        bird.zPosition = 10
        
        //Ground
        let ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = 2
        
        blockingdObjects.addChild(ground)
        
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "createPipe", userInfo: nil, repeats: true)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        print("oops!")
        blockingdObjects.speed = 0
    }
    
    func createPipe() {
        let randomLength = arc4random() % UInt32(self.frame.size.height/2)
        let offset = CGFloat(randomLength) - self.frame.size.height/4
        
        //Pipes
        let gap = bird.size.height * 4
        
        let pipeTopTexture = SKTexture(imageNamed: "pipeTop.png")
        let pipeTop = SKSpriteNode(texture: pipeTopTexture)
        pipeTop.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.width/2, y: CGRectGetMidY(self.frame) + pipeTop.size.height/2 + gap/2 + offset)
        pipeTop.physicsBody = SKPhysicsBody(rectangleOfSize: pipeTop.size)
        pipeTop.physicsBody?.dynamic = false
        pipeTop.physicsBody?.categoryBitMask = 2
        
        blockingdObjects.addChild(pipeTop)
        
        let pipeBottomTexture = SKTexture(imageNamed: "pipeBottom.png")
        let pipeBottom = SKSpriteNode(texture: pipeBottomTexture)
        pipeBottom.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.width/2, y: CGRectGetMidY(self.frame) - pipeBottom.size.height/2 - gap/2 + offset)
        pipeBottom.physicsBody = SKPhysicsBody(rectangleOfSize: pipeTop.size)
        pipeBottom.physicsBody?.dynamic = false
        pipeBottom.physicsBody?.categoryBitMask = 2
        
        blockingdObjects.addChild(pipeBottom)
        
        //Pipe Move
        let pipeMove = SKAction.moveByX(-self.frame.width, y: 0, duration: 4)
        pipeTop.runAction(pipeMove)
        pipeBottom.runAction(pipeMove)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Called when a touch begins
        bird.physicsBody?.velocity = CGVectorMake(0, 0)
        bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}