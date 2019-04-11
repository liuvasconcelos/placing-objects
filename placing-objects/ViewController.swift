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
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()

        sceneView.session.run(configuration)
        
        for _ in 1...20 {
            let xRandom = Float.random(in: (-1)...0)
            let yRandom = Float.random(in: (-1)...0)
            let zRandom = Float.random(in: (-1)...0)
            let vector = SCNVector3Make(xRandom, yRandom, zRandom)
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
            //see if is visible
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
