//
//  ViewController.swift
//  WinkNavigation
//
//  Created by Derek Carter on 2/8/19.
//  Copyright © 2019 Derek Carter. All rights reserved.
//

import ARKit
import AVFoundation
import UIKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    enum EyeState {
        case opened
        case closed
    }
    
    @IBOutlet var carouselView: CarouselView! = CarouselView()
    @IBOutlet var sceneView: ARSCNView!
    
    private let blinkTimeThreshold: TimeInterval = 0.04
    private let eyeCoefficientThreshold: Float = 0.80
    
    private var leftEyeClosedInterval = DateInterval()
    private var leftEyeState: EyeState = .opened {
        didSet {
            guard oldValue != leftEyeState else {
                return
            }
            switch leftEyeState {
            case .closed:
                leftEyeClosedInterval.start = Date()
            case .opened:
                leftEyeClosedInterval.end = Date()
                leftEyeClosureDidEnd()
            }
        }
    }
    
    private var rightEyeClosedInterval = DateInterval()
    private var rightEyeState: EyeState = .opened {
        didSet {
            guard oldValue != rightEyeState else {
                return
            }
            switch rightEyeState {
            case .closed:
                rightEyeClosedInterval.start = Date()
            case .opened:
                rightEyeClosedInterval.end = Date()
                rightEyeClosureDidEnd()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup carouselView
        setupCarouselView()
        
        // Setup sceneView
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ARFaceTrackingConfiguration.isSupported {
            let configuration = ARFaceTrackingConfiguration()
            sceneView.session.run(configuration)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if ARFaceTrackingConfiguration.isSupported {
            sceneView.session.pause()
        }
    }
 
    
    // MARK: - Setup Methods
    
    private func setupCarouselView() {
        let slide1 = CarouselSlide(image: UIImage(named: "slide1"), title: "Slide 1", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
        let slide2 = CarouselSlide(image: UIImage(named: "slide2"), title: "Slide 2", description: "Vestibulum sed facilisis lacus.")
        let slide3 = CarouselSlide(image: UIImage(named: "slide3"), title: "Slide 3", description: "Praesent nec enim et sapien lacinia dictum a cursus lorem.")
        let slide4 = CarouselSlide(image: UIImage(named: "slide4"), title: "Slide 4", description: "Nam ac lectus quis arcu lobortis ornare.")
        let slide5 = CarouselSlide(image: UIImage(named: "slide5"), title: "Slide 5", description: "Duis nec euismod nibh.")
        let slide6 = CarouselSlide(image: UIImage(named: "slide6"), title: "Slide 6", description: "Sed et felis ut ex egestas consequat.")
        carouselView.slides = [slide1, slide2, slide3, slide4, slide5, slide6]
    }
    
    
    // MARK: - ARSCNViewDelegate Methods

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device else {
            return nil
        }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: faceGeometry)
        node.geometry?.firstMaterial?.transparency = 0.0
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
            return
        }
        
        faceGeometry.update(from: faceAnchor.geometry)
        
        let leftEyeCoefficient = faceAnchor.blendShapes[.eyeBlinkLeft]?.floatValue ?? 0.0
        let rightEyeCoefficient = faceAnchor.blendShapes[.eyeBlinkRight]?.floatValue ?? 0.0
        
        DispatchQueue.main.async {
            self.handleEyeClosureCoefficient(leftEyeCoefficient: leftEyeCoefficient, rightEyeCoefficient: rightEyeCoefficient)
        }
    }
    
    
    // MARK: - AR Handler Methods
    
    private func handleEyeClosureCoefficient(leftEyeCoefficient: Float, rightEyeCoefficient: Float) {
        // Prevent both eye closures
        if leftEyeCoefficient >= eyeCoefficientThreshold && rightEyeCoefficient >= eyeCoefficientThreshold {
            print("Cancelling, both eyes closed")
            return
        }
        
        //print("leftEyeCoefficient: \(leftEyeCoefficient)  |  rightEyeCoefficient: \(rightEyeCoefficient)")
        leftEyeState = leftEyeCoefficient >= eyeCoefficientThreshold ? .closed : .opened
        rightEyeState = rightEyeCoefficient >= eyeCoefficientThreshold ? .closed : .opened
    }
    
    private func leftEyeClosureDidEnd() {
        print("leftEyeClosureDidEnd | \(leftEyeClosedInterval.duration)")
        if leftEyeClosedInterval.duration >= blinkTimeThreshold {
            carouselView.nextSlide()
        }
    }
    
    private func rightEyeClosureDidEnd() {
        print("rightEyeClosureDidEnd | \(rightEyeClosedInterval.duration)")
        if rightEyeClosedInterval.duration >= blinkTimeThreshold {
            carouselView.previousSlide()
        }
    }
    
}
