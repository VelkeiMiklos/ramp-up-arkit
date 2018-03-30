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
    
    
    var sceneView: SCNView!
    var size: CGSize!
    
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
        
        //Popoverbe egy scene
        let scene = SCNScene(named: "art.scnassets/ramps.scn")
        sceneView.scene = scene
        
        //Kamera
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene?.rootNode.camera = camera
        
        //Egy pipe scene
        var obj = SCNScene(named: "art.scnassets/pipe.dae")
        var node = obj?.rootNode.childNode(withName: "pipe", recursively: true)//art.scnassets-be pipe azonosító
        node?.scale = SCNVector3Make(0.0022, 0.0022, 0.0022)//Méret
        node?.position = SCNVector3Make(-1, 0.7, -1)//Méret
        scene?.rootNode.addChildNode(node!)

        //Egy pyramid scene
        obj = SCNScene(named: "art.scnassets/pyramid.dae")
        node = obj?.rootNode.childNode(withName: "pyramid", recursively: true)//art.scnassets-be pipe azonosító
        node?.scale = SCNVector3Make(0.0058, 0.0058, 0.0058)//Méret
        node?.position = SCNVector3Make(-1, -0.45, -1)//Méret
        scene?.rootNode.addChildNode(node!)

        
        obj = SCNScene(named: "art.scnassets/quarter.dae")
        node = obj?.rootNode.childNode(withName: "quarter", recursively: true)//art.scnassets-be pipe azonosító
        node?.scale = SCNVector3Make(0.0058, 0.0058, 0.0058)//Méret
        node?.position = SCNVector3Make(-1, -2.2, -1)//Méret
        scene?.rootNode.addChildNode(node!)
        
    }
    
    
    
}
