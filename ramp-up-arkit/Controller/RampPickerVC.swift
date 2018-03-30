//
//  RampPickerVC.swift
//  ramp-up-arkit
//
//  Created by Velkei Miklós on 2018. 03. 30..
//  Copyright © 2018. NeonatCore. All rights reserved.
//

import UIKit
import SceneKit

class RampPickerVC: UIViewController{
    
    //Változók
    var sceneView: SCNView!
    var size: CGSize!
    weak var rampPlacerVC: RampPlacerVC!
    
    init(size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = CGRect(origin: CGPoint.zero, size: size)
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.insertSubview(sceneView, at: 0)
        
        preferredContentSize = size
        view.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.borderWidth = 3.0
        
        //Popoverbe egy scene
        let scene = SCNScene(named: "art.scnassets/ramps.scn")
        sceneView.scene = scene
        
        //Kamera
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene?.rootNode.camera = camera
        
        //Gesture Recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tap)
        
        //Pipe
        let pipe = Ramp.getPipe()
        Ramp.startRotation(node: pipe)
        scene?.rootNode.addChildNode(pipe)
        
        //Pyramid
        let pyramid = Ramp.getPyramid()
        Ramp.startRotation(node: pyramid)
        scene?.rootNode.addChildNode(pyramid)
        
        //Quarter
        let quarter = Ramp.getQuarter()
        Ramp.startRotation(node: quarter)
        scene?.rootNode.addChildNode(quarter)
    }
    
    @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer){
        let p = gestureRecognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(p, options: [:])
        
        //Har rányomtunk egy objektumra
        if hitResults.count > 0{
            let node = hitResults[0].node//melyik node volt
            print(node.name!)
            rampPlacerVC.onRampSelected(rampName: node.name!)
            dismiss(animated: true, completion: nil)
        }
    }
    
}
