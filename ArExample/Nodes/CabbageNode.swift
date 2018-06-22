//
//  CabbageNode.swift
//  ArExample
//
//  Created by pi29056 on 20.06.2018.
//  Copyright © 2018 ggwizdala. All rights reserved.
//

import Foundation
import SceneKit

class CabbageNode :SCNNode {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        guard let cabbageScene = SCNScene(named: "art.scnassets/Cabbage.scn"),
        let node = cabbageScene.rootNode.childNode(withName: "Cabbage", recursively: false) else { return }
        
        node.name = "Cabbage"
        self.addChildNode(node)
        self.scale = SCNVector3Make(0.01, 0.01, 0.01)
        
        
        let geometry = SCNSphere(radius: 0.05)
        let shape = SCNPhysicsShape(geometry: geometry, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.mass = 1

        
    }
}
