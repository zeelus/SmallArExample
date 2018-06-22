//
//  PlaneNode.swift
//  ARKitDemo
//
//  Created by Gilbert Gwizdała on 01/12/2017.
//  Copyright © 2017 ggwizdala All rights reserved.
//

import SceneKit
import ARKit

/// This node is grid 3D model.
class GridNode: SCNNode {
    
    /// Every grid have anchor contains information about postion and size of detected plane.
    var anchor: ARPlaneAnchor!
    
    var planeGeometry: SCNPlane!
    var gridNode: SCNNode!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        self.anchor = anchor
        
        let material = SCNMaterial()
        // Setup image "grid" as main texture.
        material.diffuse.contents = UIImage(named: "grid")
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        self.planeGeometry.materials = [material]
        self.gridNode = SCNNode(geometry: self.planeGeometry)
        self.gridNode.physicsBody = self.generatePhysicBody()
        self.gridNode.physicsBody?.categoryBitMask = 1
        
        // grid node need rotate because inicial rotation is perpendicularly to the graund.
        gridNode.rotation = SCNVector4Make(1, 0, 0, -Float(Double.pi / 2))
        
        // The postion of node come from ar engine
        self.gridNode.position = SCNVector3Make(anchor.center.x, 0.0, anchor.center.z)
        
        self.addChildNode(gridNode)
        
        //Because texture is static image sometimes we need to scale this to make image bigger
        self.scaleTexture()
    }
    
    
    func update(anchor: ARPlaneAnchor) {
        // This mentohod will by call when ar engine update plane posistion and size
        self.planeGeometry.width = CGFloat(anchor.extent.x)
        self.planeGeometry.height = CGFloat(anchor.extent.z)
        self.gridNode.position = SCNVector3Make(anchor.center.x, 0.0, anchor.center.z)
        self.scaleTexture()
        self.updatePhysicBody()
    }
    
    private func scaleTexture() {
        
        let width: Float = Float(self.planeGeometry.width)
        let height: Float = Float(self.planeGeometry.height)
        let material = self.planeGeometry.firstMaterial
        
        // Image is to small to cover all object, we need scale it.
        material?.diffuse.contentsTransform = SCNMatrix4MakeScale(width, height, 1)
        //Because is to small we set wrapS and wrapT to repeta this image on edges.
        material?.diffuse.wrapS = .repeat
        material?.diffuse.wrapT = .repeat
        
    }
    
    
    
    //--------------------------------- This elements is described in Physics module. ---------------------------------
    private func generatePhysicBody() -> SCNPhysicsBody {
        let shape = SCNPhysicsShape(geometry: self.planeGeometry, options: nil)
        let body = SCNPhysicsBody(type: .kinematic, shape: shape)
        body.categoryBitMask = 1
        return body
    }
    
    private func updatePhysicBody() {
        self.gridNode.physicsBody = generatePhysicBody()
    }
    
}
//--------------------------------------------------------------------------------------------------------------------------

