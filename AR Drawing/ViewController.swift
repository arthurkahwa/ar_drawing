//
//  ViewController.swift
//  AR Drawing
//
//  Created by Arthur Nsereko Kahwa on 04/08/2018.
//  Copyright © 2018 Arthur Nsereko Kahwa. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var draw: UIButton!

    let configuration = ARWorldTrackingConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,
                                       ARSCNDebugOptions.showWorldOrigin]

        self.sceneView.delegate = self
        self.sceneView.showsStatistics = true
        
        self.sceneView.session.run(configuration)

//        let pointer = SCNNode(geometry: SCNSphere(radius: 0.1))
//        pointer.position = SCNVector3(0, 0, 0.3)
//
//        self.sceneView.scene.rootNode.addChildNode(pointer)
//        pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView
            else {
                return
        }

        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)

        let currentPositionOfCamera = orientation + location
        let cubeSide: CGFloat = 0.01

        DispatchQueue.main.async {
            if self.draw.isHighlighted {
                // NSLog("%@", "draw")

                let sphereNode = SCNNode(geometry: SCNSphere(radius: cubeSide))
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                sphereNode.position = currentPositionOfCamera

                self.sceneView.scene.rootNode.addChildNode(sphereNode)
            }
            else {

                let pointer = SCNNode(geometry: SCNSphere(radius: cubeSide))
                pointer.position = currentPositionOfCamera
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                pointer.name = "pointer"

                self.sceneView.scene.rootNode.enumerateChildNodes({(node, _) in
                    if node.name == "pointer" {
                        node.removeFromParentNode()
                    }
                })

                self.sceneView.scene.rootNode.addChildNode(pointer)
            }

            // self.writeLocationAndOrientation(orientation, location)
        }
    }
}

func +(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
}
