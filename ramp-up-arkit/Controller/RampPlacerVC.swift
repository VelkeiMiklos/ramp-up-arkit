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

    @IBOutlet weak var controls: UIStackView!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var rotateBtn: UIButton!
    @IBOutlet weak var upBtn: UIButton!
    @IBOutlet weak var downBtn: UIButton!
    
    var selectedRampName: String?
    var selectedRamp: SCNNode?
    
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
        
        
        //Gesture-k
        let gesture1 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressed(gesture:)))
        let gesture2 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressed(gesture:)))
        let gesture3 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressed(gesture:)))
        
        gesture1.minimumPressDuration = 0.1
        gesture2.minimumPressDuration = 0.1
        gesture3.minimumPressDuration = 0.1
        
        rotateBtn.addGestureRecognizer(gesture1)
        upBtn.addGestureRecognizer(gesture2)
        downBtn.addGestureRecognizer(gesture3)
        
        
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
            controls.isHidden = false
            let ramp = Ramp.getRampForName(rampName: rampName)//Ramp név
            
            selectedRamp = ramp
            ramp.position = position//hova érintettem a képernyőn
            ramp.scale = SCNVector3Make(0.01, 0.01, 0.01)
            sceneView.scene.rootNode.addChildNode(ramp)
            
        }
    }
    @IBAction func removeBtnWasPressed(_ sender: Any) {
        if let ramp = selectedRamp{
            ramp.removeFromParentNode()
            selectedRamp = nil
        }
    }
    
    //Addig csinálja amíg a gomb le van nyomva
    @objc func onLongPressed(gesture: UILongPressGestureRecognizer){
        
        if let ramp = selectedRamp{
            
            if gesture.state == .ended{
                ramp.removeAllActions()
            }else if gesture.state == .began{
                //Melyik gomb volt megnyomva
                if gesture.view === rotateBtn{//=== memory location check
                    let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.8 * Double.pi), z: 0, duration: 0.1))
                    ramp.runAction(rotate)
                }else if gesture.view === upBtn{
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0.08, z: 0, duration: 0.1))
                    ramp.runAction(move)
                }else if gesture.view === downBtn{
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: -0.08, z: 0, duration: 0.1))
                    ramp.runAction(move)
                }
            }
        }
    }
}
