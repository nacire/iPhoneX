//
//  ViewController.swift
//  iPhoneX
//
//  Created by nacire on 9/9/18.
//  Copyright © 2018 nacire. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    var focusSquare: FocusSquare?
    var screenCentre: CGPoint!
    
    var numberOfModel: Array<SCNNode> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        screenCentre = view.center
//        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
//        sceneView.debugOptions = ARSCNDebugOptions.showWorldOrigin
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/iPhoneX 3D/iPhone X.scn")!
        
        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(configuration)
        
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let viewCenter = CGPoint(x: size.width / 2, y: size.height / 2)
        screenCentre = viewCenter
    }
  
    func updateFocusSquare() {
        guard let focusSquareLocal = focusSquare else {return}
        
        guard let pointOfView = sceneView.pointOfView else {return}
        
        let firstVisibleModel = numberOfModel.first { (node) -> Bool in
            return sceneView.isNode(node, insideFrustumOf: pointOfView)
        }
        
        let modelsAreVisible = firstVisibleModel != nil
        
        if modelsAreVisible != focusSquareLocal.isHidden {
            focusSquareLocal.setHidden(to: modelsAreVisible)
        }
        
        let hitTest = sceneView.hitTest(screenCentre, types: .existingPlaneUsingExtent)
        if let hitTestResult = hitTest.first {
//            print("Focus square hits a plane")
            
            let addNewModel = hitTestResult.anchor is ARPlaneAnchor
            focusSquareLocal.isClosed = addNewModel
        } else {
//            print("Focus square does not hit a plane")
            focusSquareLocal.isClosed = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
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
