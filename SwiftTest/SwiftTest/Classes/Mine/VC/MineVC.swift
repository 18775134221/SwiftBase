//
//  MineVC.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/10.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

struct User {
    var age: Int
    var height: Int
    var weight: Int
    
    mutating func gainWeight(newHeight: Int) {
        weight += newHeight
    }
}


class MineVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newUser = User(age: 10, height: 10, weight: 100)
        print("\(newUser.age) \(newUser.height) \(newUser.weight)")
        print("\(newUser.weight)")

    }

    // MARK: - 柯里化（Currying）

}

extension MineVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ResuableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
}
