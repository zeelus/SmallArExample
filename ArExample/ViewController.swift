//
//  ViewController.swift
//  ArExample
//
//  Created by ggwizdala on 20.06.2018.
//  Copyright © 2018 ggwizdala. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var spotLightNode: SCNNode? = nil
    
    private var existingGrids = [UUID: GridNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.delegate = self
        
        self.sceneView.showsStatistics = true
        self.sceneView.debugOptions =  [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints, SCNDebugOptions.showPhysicsShapes]
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        sceneView.scene = scene
        
        self.setupLight()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Setup AR
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        self.addCabbage(at: self.sceneView.session.currentFrame!.camera.transform.translation.sceneVector3)
    }
    
    func addCabbage(at position: SCNVector3) {
        //Add node
    }
    
    // MARK: - Light
    
    func setupLight() {
        // Light
    }
    
     // MARK: - HitTest
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //HitTest
    }
    
}

extension float4x4 {
    
    /// Get float3 position from 4x4 transform matrix
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
    
}

extension float3 {
    
    /// Convert scene vector for simd float3 vector
    var sceneVector3: SCNVector3 {
        return SCNVector3Make(self.x, self.y, self.z)
    }
    
}
