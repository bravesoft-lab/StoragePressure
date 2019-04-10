//
//  ViewController.swift
//  StoragePressure
//
//  Copyright © 2018年 breavesoft inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var strageLabel: UILabel!
    @IBOutlet weak var limitTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateStrageLabel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateStrageLabel() {
        strageLabel.text = String.init(format: "%d", Int(getFreeStrageSize()))
    }
    
    private func runAddData() {
        addImage(image: #imageLiteral(resourceName: "image_l")) //大きめサイズで埋める
        addImage(image: #imageLiteral(resourceName: "image_s")) //小さいサイズで微調整
        
        updateStrageLabel()
    }
    
    private func addImage(image: UIImage) {
        let pngImageData = UIImagePNGRepresentation(image)
        guard let text = limitTextField.text, let limit = Int(text) else {
            return
        }
        while getFreeStrageSize() >= Double(limit) {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(String.init(format: "image%d.png", NSDate.timeIntervalSinceReferenceDate))
            try? pngImageData?.write(to: fileURL)
        }
    }
    
    
    private func getFreeStrageSize() -> Double {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectoryPath.last!) {
            
            // systemAttributes の値を全て出力
            //            for value in systemAttributes {
            //                print(value)
            //            }
            
            if let freeSize = systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber {
                // MB単位で空き容量を取得
                let storageMb = freeSize.doubleValue / Double(1024 * 1024)
                return storageMb
            }
        }
        return 0
    }
    
    @IBAction func clickedRunButton(_ sender: Any) {
        runAddData()
    }
    
    @IBAction func clickedReloadButton(_ sender: Any) {
        updateStrageLabel()
    }
}

