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
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        self.addCabbage(at: self.sceneView.session.currentFrame!.camera.transform.translation.sceneVector3)
    }
    
    func addCabbage(at position: SCNVector3) {
        let cabbageNode = CabbageNode()
        cabbageNode.position = position
        self.sceneView.scene.rootNode.addChildNode(cabbageNode)
    }
    
    // MARK: - Light
    
    func setupLight() {
        
        self.sceneView.automaticallyUpdatesLighting = false
        
        let light = SCNLight()
        light.type = .omni
        light.intensity = 0
        light.temperature = 0
        
        self.spotLightNode = SCNNode()
        self.spotLightNode?.light = light
        self.spotLightNode?.position = SCNVector3(0, 2, 0)
        self.sceneView.scene.rootNode.addChildNode(self.spotLightNode!)
        
        self.sceneView.session.configuration?.isLightEstimationEnabled = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self.sceneView)
        if let result = self.sceneView.hitTest(point, types: .existingPlane).first {
            let position = result.worldTransform.translation.sceneVector3
            self.addCabbage(at: SCNVector3Make(position.x, position.y + 0.2, position.z))
        }
    }
    

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        if let estimate = self.sceneView.session.currentFrame?.lightEstimate {
            self.spotLightNode?.light?.intensity = estimate.ambientIntensity
            self.spotLightNode?.light?.temperature = estimate.ambientColorTemperature
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let gridNode = GridNode(anchor: planeAnchor)
        node.addChildNode(gridNode)
        
        self.existingGrids[planeAnchor.identifier] = gridNode
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let gridNode = self.existingGrids[planeAnchor.identifier]
        // Update grids position and size
        gridNode?.update(anchor: planeAnchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        // After AR detecting collision between two grid nodes remove them and replace by a marged and bigger one
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        self.existingGrids.removeValue(forKey: planeAnchor.identifier)
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
