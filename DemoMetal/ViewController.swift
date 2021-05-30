//
//  ViewController.swift
//  DemoMetal
//
//  Created by Higashihara Yoki on 2021/05/30.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let metalCircleView = MetalCircleView()
        view.addSubview(metalCircleView)
        
        //constraining to window
        metalCircleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        metalCircleView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        metalCircleView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        metalCircleView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}

