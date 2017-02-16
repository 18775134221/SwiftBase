//
//  PoperMenuView.swift
//  SwiftTest
//
//  Created by MAC on 2017/2/15.
//  Copyright © 2017年 MAC. All rights reserved.
//

import UIKit

private let kCellID = "kCellID"
private let kMenuTag = 201712
private let kCoverViewTag = 201722
private let kMargin: CGFloat = 8 // 偏移
private let kTriangleHeight: CGFloat = 10.0 // 三角形的高
private let kRadius = 5.0 // 圆角半径
private let KDefaultMaxValue:CGFloat = 6 // 菜单项最大值

// MARK: - 优雅的管理selector
fileprivate struct Action {
    static let backViewGes = #selector(PoperMenuView.viewClick(tapGes:))
    
}

@objc protocol PoperMenuViewDelegate {
    func selectedItem(index: NSInteger);
}

class PoperMenuView: UIView {

    weak var delegate: PoperMenuViewDelegate?
    
    let cotentTableView: UITableView =  {
        let tableView = UITableView()
        tableView.bounces = false
        tableView.rowHeight = 40
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 61/255.0, green: 61/255.0, blue: 61/255.0, alpha: 1)
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 5
        tableView.register(PoperMenuCell.self, forCellReuseIdentifier:kCellID)
        return tableView
    }()
    
    
    let backView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        view.alpha = 1
        view.tag = kCoverViewTag
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let upImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        imageView.image = UIImage(named: "topArrow")
        return imageView
    }()
    
    var tempView: UIView?
    
    // 箭头的位置
    var arrowPointX: CGFloat? = 0
    
    var datasArray:[[String: String]]! {
        didSet {
            cotentTableView.frame = CGRect(x: 0, y: kTriangleHeight, width: CGFloat(self.width), height:CGFloat(datasArray.count) * 40.0 - 0.5)
            if datasArray.count > Int(KDefaultMaxValue) {
               cotentTableView.height = KDefaultMaxValue  * 40.0 - 0.5
            }
            self.height = CGFloat(datasArray.count > 6 ? CGFloat(KDefaultMaxValue) : CGFloat(datasArray.count)) * 40.0 + kTriangleHeight - 0.5
            // 坐标转换
            let window = UIApplication.shared.keyWindow
            let rect = self.superview?.convert((tempView?.frame)!, to: window)
            
            debugLog(rect)
            
            
            self.x = (rect?.origin.x)! - self.width * 0.5;
            if (self.x < kMargin) {
                self.x = kMargin;
                upImageView.x = (rect?.size.width)! / 2.0
            }else if (self.x > UIScreen.main.bounds.size.width - kMargin - self.width) { // 在右边
                self.x = UIScreen.main.bounds.size.width - kMargin - self.width
                upImageView.x = self.width / 2.0 + (rect?.size.width)! / 2.0
            }
            self.layer.setAffineTransform(CGAffineTransform(scaleX: 1.0, y: 1.0))
            cotentTableView.reloadData()
        }
    }
    
    init(frame: CGRect, view: UIView) {
        super.init(frame: frame)
        tempView = view
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        self.backgroundColor = .clear

        UIApplication.shared.keyWindow?.addSubview(backView)
        let tap = UITapGestureRecognizer.init(target: self, action: Action.backViewGes)
        backView.addGestureRecognizer(tap)
        
        addSubview(upImageView)
        UIApplication.shared.keyWindow?.addSubview(self)
        self.tag = kMenuTag
        
        cotentTableView.frame = CGRect(x: 0, y: kTriangleHeight, width: CGFloat(self.width), height: CGFloat(CGFloat(self.height) - kTriangleHeight))
        addSubview(cotentTableView)
        cotentTableView.delegate = self
        cotentTableView.dataSource = self
        
    }
    
    @objc fileprivate func viewClick(tapGes: UITapGestureRecognizer) {
        poperMenuViewDissmiss()
    }
    
    public func poperMenuViewShow() {
        backView.isHidden = false
        self.isHidden = false
    }
    
    public func poperMenuViewDissmiss() {
        cotentTableView.contentOffset = CGPoint(x: 0, y: 0)
        UIView.animate(withDuration: 0.25, animations:{ _ in
            //self.layer.setAffineTransform(CGAffineTransform(scaleX: 0.01, y: 0.01))
            self.alpha = 0
            self.backView.alpha = 0
        }, completion: { _ in
            
            let window = UIApplication.shared.keyWindow
            if ((window?.viewWithTag(kCoverViewTag)) != nil) {
                window?.viewWithTag(kCoverViewTag)?.removeFromSuperview()
            }
            if ((window?.viewWithTag(kMenuTag)) != nil) {
                window?.viewWithTag(kMenuTag)?.removeFromSuperview()
            }
            
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}

extension PoperMenuView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PoperMenuCell? = tableView.dequeueReusableCell(withIdentifier: kCellID) as? PoperMenuCell
        cell?.backgroundColor = UIColor(red: 61/255.0, green: 61/255.0, blue: 61/255.0, alpha: 1)
        cell?.menuModel = PoperMenuMD(dict: datasArray[indexPath.row] as [String : String] as [String : NSObject] )
        print("\(cell?.menuModel.itemName)")
        if let _ = cell {
        }else {
            cell = PoperMenuCell(style: .default, reuseIdentifier: kCellID)
        }
        return cell!
    }
}

extension PoperMenuView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedItem(index: indexPath.row)
        poperMenuViewDissmiss()
        debugLog(indexPath.row)
    }
}
