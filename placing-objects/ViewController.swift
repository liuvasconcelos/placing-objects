//
//  ViewController.swift
//  placing-objects
//
//  Created by Mac Mini Novo on 21/03/19.
//  Copyright © 2019 LiuVasconcelos. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var balls = [SCNNode]()
    var firstVisibility = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()

        sceneView.session.run(configuration)
        
        for n in 1...20 {
            let multiplier = Float(n)
            let vector = SCNVector3Make(0, (-0.1)*multiplier, (-0.1)*multiplier)
            createBall(position: vector)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        guard let firstBallInScene = balls.first else {
            return
        }
        if firstVisibility {
            let isVisible = renderer.isNode(firstBallInScene, insideFrustumOf: renderer.pointOfView!)
            
            if isVisible {
                firstVisibility = false
            }
        } else {
            let isVisible = renderer.isNode(firstBallInScene, insideFrustumOf: renderer.pointOfView!)
            if !isVisible {
                firstBallInScene.geometry = firstBallInScene.geometry!.copy() as? SCNGeometry
                firstBallInScene.geometry?.firstMaterial = firstBallInScene.geometry?.firstMaterial!.copy() as? SCNMaterial
                firstBallInScene.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                balls.removeFirst()
            }
        }
    }

    func createBall(position: SCNVector3) {
        let ballShape = SCNSphere(radius: 0.01)
        let ballNode = SCNNode(geometry: ballShape)
        ballNode.position = position
        sceneView.scene.rootNode.addChildNode(ballNode)
        
        balls.append(ballNode)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
