//
//  JQCarouselView.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/28.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher

private let kCycleCellID = "kCycleCellID"
private let kTimerInterval: TimeInterval = 3

// pageControl
private let kpageControlSize: CGFloat = 7.0
private let kpageControlSpace: CGFloat = 3.0



@objc protocol JQCarouselViewDelegate {
    @objc optional func jQCarouselViewSeletedIndex(index: NSInteger)
}

enum PageControlPositionStyle: NSInteger {
    case none = 0              // 不显示
    case centerPosition    // 中心
    case rightPosition      // 居右
}

enum AutoPlayStyle: NSInteger {
    case noAutoPlay = 0     // 默认不使用自动轮播
    case autoPlay       // 开启自动轮播
}

class JQCarouselView: UIView {

    weak var delegate: JQCarouselViewDelegate?
    
    // 如果不强制解包会点不出对应的属性值
    var needAutoPlay: AutoPlayStyle!
    var pageControlPositionStyle: PageControlPositionStyle!
    var timeDuration: TimeInterval?
    
    // 添加定时器
    fileprivate var cycleTimer: Timer?
    
    var isFirstLoad: Bool?
    
    fileprivate var tempImageGroups: [String]?
    // 图片数组
    var imageGroups: [String]? {
        didSet{
            
            tempImageGroups = imageGroups
            guard ((imageGroups?.count)! > 0) else {
                return
            }
            if (imageGroups?.count)! == 1 {
                pageControl.isHidden = true
            }
            // 首尾各添加一张
            let first: String = (imageGroups?.first)!
            let last: String = (imageGroups?.last)!
            imageGroups?.insert(last, at: 0)
            imageGroups?.insert(first, at: (imageGroups?.count)!)
            
            collectionView.reloadData()
            // 2.设置pageControl个数
            pageControl.numberPageControls = tempImageGroups?.count ?? 0
            
            // 3.默认滚动到中间某一个位置
            perform(#selector(scrollIndex), with: nil, afterDelay: 0.0001)
    
            // 4.添加定时器
            removeCycleTimer()
            addCycleTimer()
        }
    }

    @objc func scrollIndex() {
        let indexPath = IndexPath(item: 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        pageControl.currentPageControl = 0
    }
    
    lazy var pageControl: JQPageControlView = {
        let pageControl = JQPageControlView()
        pageControl.datasource = self
        pageControl.delegate = self
        return pageControl
    }()
    
    lazy var collectionView: UICollectionView = {[unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        let collectV = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectV.dataSource = self
        collectV.delegate = self
        collectV.isPagingEnabled = true
        collectV.backgroundColor = UIColor.white
        collectV.showsVerticalScrollIndicator = false
        collectV.showsHorizontalScrollIndicator = false
        return collectV
    }()
    
    override init(frame: CGRect) {
        pageControlPositionStyle = .centerPosition
        needAutoPlay = .autoPlay
        imageGroups = [String]()
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPageControl() {
        debugLog(bounds)
        let numbers = imageGroups?.count ?? 0
        // 2.设置pageControl个数
        pageControl.numberPageControls = numbers
    }
    
    private func setupUI() {
        addSubview(collectionView)
        addSubview(pageControl)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        var constraintArray: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView": collectionView])
        constraintArray += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView": collectionView])
        addConstraints(constraintArray)
        // 注册cell
        collectionView.register(JQCarouselCell.self, forCellWithReuseIdentifier: kCycleCellID)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 设置collectionView的layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
        
        // 设置pageControl的位置
        let numbers = tempImageGroups?.count ?? 0
        var pageControlW: CGFloat? = 0
        var pageControlX: CGFloat? = 0
        if pageControlPositionStyle == .none {
            pageControl.isHidden = true
        }else if pageControlPositionStyle == .centerPosition {
            pageControlW = CGFloat(CGFloat(numbers) * kpageControlSize + CGFloat(numbers) * kpageControlSpace)
            pageControlX = (bounds.size.width - pageControlW!) / 2.0
        }else {
            pageControlW = CGFloat(CGFloat(numbers) * kpageControlSize + CGFloat(numbers) * kpageControlSpace)
            pageControlX = (bounds.size.width - pageControlW!)
        }
        let pageControlY: CGFloat = bounds.size.height - kpageControlSize - 10
        let pageControlH: CGFloat = kpageControlSize + 10
        pageControl.frame = CGRect(x: pageControlX!, y: pageControlY, width: pageControlW!, height: pageControlH)
    }
    
    
}

extension JQCarouselView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (imageGroups?.count ?? 0 );
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: JQCarouselCell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath) as! JQCarouselCell
        let url = URL(string: imageGroups![indexPath.item])
        cell.imageView.kf.setImage(with: url)
        return cell
    }
    
}

// MARK:- 遵守UICollectionView的代理协议
extension JQCarouselView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugLog("\(indexPath.item - 1)")
        if let _ = delegate {
            delegate?.jQCarouselViewSeletedIndex!(index: indexPath.item - 1)
        }
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 1.获取滚动的偏移量
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        
        // 2.计算pageControl的currentIndex
        var currentPage = Int(offsetX / scrollView.bounds.width)
        
        if 0 == currentPage {
            currentPage = (tempImageGroups?.count)!
        }else if (tempImageGroups?.count)! + 1 == currentPage {
            currentPage = 1
        }
        pageControl.currentPageControl = currentPage - 1
        
    }
    
    // 减速的时候调用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX: Int = Int(scrollView.contentOffset.x)
        var currentPage = offsetX / Int(scrollView.bounds.size.width)
        if 0 == currentPage {
            currentPage = (tempImageGroups?.count)!
        }else if (tempImageGroups?.count)! + 1 == currentPage {
            currentPage = 1
        }
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        pageControl.currentPageControl = currentPage - 1
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCycleTimer()
    }
}

extension JQCarouselView: JQPageControlViewDatasource {
    func pageControlSizeAndSpace() -> (pointSize: CGFloat, distance: CGFloat) {
        return (kpageControlSize,kpageControlSpace)
    }
    
    func pageControlColor() -> (currentColor: UIColor, otherColor: UIColor) {
        return (UIColor.red,UIColor.white)
    }
    
    func pageControlBG() -> (currentImageName: String, otherImageName: String) {
        return ("normal","selected")
    }
}

extension JQCarouselView: JQPageControlViewDlegate {
    func pageControlViewDidSelected(pageControlView: JQPageControlView, index: NSInteger) {
        addCycleTimer()
        debugLog("当前点击的是\(index)")
        let indexPath = IndexPath(item: index + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        pageControl.currentPageControl = index
    }
}

extension JQCarouselView {
    // MARK:- 对定时器的操作方法
    fileprivate func addCycleTimer() {
        
        guard needAutoPlay == .autoPlay else {
            return
        }
        if cycleTimer != nil { // 防止重复添加
            cycleTimer?.invalidate()
            cycleTimer = nil
        }
        
        cycleTimer = Timer(timeInterval: ((timeDuration ) != nil) ? timeDuration! : kTimerInterval, target: self, selector: #selector(self.scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode: RunLoopMode.commonModes)


    }
    
    public func removeCycleTimer() {
        if cycleTimer != nil { // 防止重复添加
            cycleTimer?.invalidate()// 从运行循环中移除
            cycleTimer = nil
        }
    }
    
    @objc fileprivate func scrollToNext() {
        
        let offsetX: Int = Int(collectionView.contentOffset.x)
        var currentPage = offsetX / Int(collectionView.bounds.size.width)
        if (tempImageGroups?.count)! == currentPage {
            currentPage = 1
        }else {
            currentPage += 1
        }
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
 
}
