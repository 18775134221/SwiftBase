//
//  TestVC.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/28.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class TestVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        let cycleTimer = Timer.jq_scheduled(timerInterval: 3, repeats: true, target: self.classForCoder, block: {
            debugLog("测试")
        })
        RunLoop.main.add(cycleTimer, forMode: RunLoopMode.commonModes)
        
    }
    
    func setupUI() {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
