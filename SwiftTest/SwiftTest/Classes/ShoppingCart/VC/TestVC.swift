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
//        let cycleTimer = Timer.jq_scheduled(timerInterval: 3, repeats: true, target: self.classForCoder, block: {
//            debugLog("测试")
//        })
//        RunLoop.main.add(cycleTimer, forMode: RunLoopMode.commonModes)
        setupUI()
        
    }
    
    // MARK: - Then 协议
    func setupUI() {
        
        // 2.0 带参数，可自行命名
        let label_AnyO = UILabel().then { (label) in
            label.backgroundColor = .blue
            label.font = UIFont.systemFont(ofSize: 18)
            label.textAlignment = .center
            label.text = "Then库写法_2.0"
            label.frame = CGRect.init(x: 0, y: 0, width: 150, height: 40)
        }
        view.addSubview(label_AnyO)
        
        
        
        // 2.1 (推荐)无参数，无需命名，用$取参数，可自动联想属性
        let lable = UILabel().then {
            $0.backgroundColor = .blue
            $0.font = UIFont.systemFont(ofSize: 18)
            $0.textAlignment = .center
            $0.text = "Then库写法_2.1"
            $0.frame = CGRect.init(x: 200, y: 260, width: 150, height: 40)
            view.addSubview($0)
        }
        
        lable.backgroundColor = UIColor.red
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    deinit {
        debugLog("子类视图已经释放")
    }

}
