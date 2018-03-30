//
//  ViewController.swift
//  ramp-up-arkit
//
//  Created by Velkei Miklós on 2018. 03. 30..
//  Copyright © 2018. NeonatCore. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class RampPlacerVC: UIViewController, ARSCNViewDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var selectedRampName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/main.scn")!
        sceneView.autoenablesDefaultLighting = true
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }

    @IBAction func onRampBtnPressed(_ sender: UIButton) {
        //Saját konstruktor
        let rampPickerVC = RampPickerVC(size: CGSize(width: 250, height: 500))
        rampPickerVC.rampPlacerVC = self
        rampPickerVC.modalPresentationStyle = .popover
        rampPickerVC.popoverPresentationController?.delegate = self
        present(rampPickerVC, animated: true, completion: nil)
        rampPickerVC.popoverPresentationController?.sourceView = sender//gombtól
        rampPickerVC.popoverPresentationController?.sourceRect = sender.bounds
        
    }
    
    //Mit választottunk ki a pop-upról
    func onRampSelected(rampName: String){
        selectedRampName = rampName
    }
    
    //.none akkor nem lez fullscreen a popup
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    //Ahova érint a képernyőn
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        //Location koordinátája
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [.featurePoint])
        
        guard let hitFeature = results.last else { return } // tap resultja, néha nem talál, pl túl sötét van ezért kell a guard let és returnolni
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)//transzformálni
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)//pozíció
        placeRamp(position: hitPosition)
    }
    
    //Kiválasztott Ramp elhelyezése
    func placeRamp(position: SCNVector3){
        
        if let rampName = selectedRampName{
          //  controls.isHidden = false
            let ramp = Ramp.getRampForName(rampName: rampName)//Ramp név
            
           // selectedRamp = ramp
            ramp.position = position//hova érintettem a képernyőn
            ramp.scale = SCNVector3Make(0.01, 0.01, 0.01)
            sceneView.scene.rootNode.addChildNode(ramp)
            
        }
    }
}
