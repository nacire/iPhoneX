//
//  ObjectAddition.swift
//  iPhoneX
//
//  Created by nacire on 9/9/18.
//  Copyright © 2018 nacire. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

extension ViewController {
    
    fileprivate func getModel(named name: String) -> SCNNode? {
        let scene = SCNScene(named: "art.scnassets/\(name)/\(name).scn")
        guard let model = scene?.rootNode.childNode(withName: "SketchUp", recursively: false)
            else {
                return nil
        }
        
        model.name = name
        return model
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        print("The button is pressed")
        
        
        guard focusSquare != nil else {return}
        
        let modelName = "iPhone X"
        guard let model = getModel(named: modelName) else {
            print("The app is unable to load \(modelName) from files")
            
            return
        }
        
        let hitTest = sceneView.hitTest(screenCentre, types: .existingPlaneUsingExtent)
        guard let worldTransformColumn3 = hitTest.first?.worldTransform.columns.3 else {return}
        model.position = SCNVector3(worldTransformColumn3.x, worldTransformColumn3.y, worldTransformColumn3.z)
        
        
        sceneView.scene.rootNode.addChildNode(model)
        numberOfModel.append(model)
        print("We have \(numberOfModel.count) model(s) in the scene")
        print("\(modelName) just added to the screen")
    }
    
    
}
