//
//  JQCarouselView.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/28.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import Foundation

private let kCycleCellID = "kCycleCellID"

// pageControl
private let kpageControlSize: CGFloat = 7.0
private let kpageControlSpace: CGFloat = 3.0



@objc protocol JQCarouselViewDelegate {
    @objc optional func jQCarouselViewSeletedIndex(index: NSInteger)
}

enum PageControlPositionStyle: NSInteger {
    case none               // 不显示
    case centerPosition    // 中心
    case rightPosition      // 居右
}

enum AutoPlayStyle: NSInteger {
    case noAutoPlay = 0     // 默认不使用自动轮播
    case autoPlay       // 开启自动轮播
}

class JQCarouselView: UIView {

    weak var delegate: JQCarouselViewDelegate?
    
    var needAutoPlay: AutoPlayStyle?
    var pageControlPositionStyle: PageControlPositionStyle?
    
    // 添加定时器
    fileprivate var cycleTimer: Timer?
    
    // 图片数组
    var imageGroups: [String]? {
        didSet{
            
            let first: String = (imageGroups?.first)!
            let last: String = (imageGroups?.last)!
            imageGroups?.insert(last, at: 0)
            imageGroups?.insert(first, at: (imageGroups?.count)!)
            
            collectionView.reloadData()
            
            let numbers = imageGroups?.count ?? 0
            // 2.设置pageControl个数
            pageControl.numberPageControls = (numbers - 2)
            
            // 3.默认滚动到中间某一个位置
            let currentOffsetX = collectionView.contentOffset.x
            let offsetX = currentOffsetX + collectionView.bounds.width
            collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
            
            // 4.添加定时器
            removeCycleTimer()
            addCycleTimer()
        }
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
        needAutoPlay = .noAutoPlay
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
        let numbers = imageGroups?.count ?? 0
        var pageControlW: CGFloat? = 0
        var pageControlX: CGFloat? = 0
        if pageControlPositionStyle == .none {
            pageControl.isHidden = true
        }else if pageControlPositionStyle == .centerPosition {
            pageControlW = CGFloat(CGFloat(numbers) * kpageControlSize + CGFloat(numbers) * kpageControlSpace)
            pageControlX = (bounds.size.width - pageControlW!) / 2.0
        }else {
            pageControlW = CGFloat(CGFloat(numbers) * kpageControlSize + CGFloat(numbers) * kpageControlSpace)
            pageControlX = (bounds.size.width - pageControlW!) - 15
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
        cell.imageView.image = UIImage(named: (imageGroups?[indexPath.item % imageGroups!.count])!)
        return cell
    }
    
}

// MARK:- 遵守UICollectionView的代理协议
extension JQCarouselView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugLog("\(indexPath.item % imageGroups!.count)")
        if let _ = delegate {
            delegate?.jQCarouselViewSeletedIndex!(index: indexPath.item)
        }
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 1.获取滚动的偏移量
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        
        // 2.计算pageControl的currentIndex
        let currentIndex = Int(offsetX / scrollView.bounds.width) % (imageGroups?.count ?? 1)
        pageControl.currentPageControl = currentIndex
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
        return (UIColor.green,UIColor.white)
    }
    
    func pageControlBG() -> (currentImageName: String, otherImageName: String) {
        return ("normal","selected")
    }
}

extension JQCarouselView: JQPageControlViewDlegate {
    func pageControlViewDidSelected(pageControlView: JQPageControlView, index: NSInteger) {
        addCycleTimer()
        
        // 1.获取滚动的偏移量
        let currentOffsetX = collectionView.contentOffset.x
        let currentSelected = Int(currentOffsetX / collectionView.bounds.width) % (imageGroups?.count ?? 1)
        debugLog(currentSelected)
        let offsetX = currentOffsetX + collectionView.bounds.width * CGFloat((index - currentSelected))
        // 2.滚动该位置
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
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
        
        cycleTimer = Timer(timeInterval: 3.0, target: self, selector: #selector(self.scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode: RunLoopMode.commonModes)


    }
    
    public func removeCycleTimer() {
        if cycleTimer != nil { // 防止重复添加
            cycleTimer?.invalidate()// 从运行循环中移除
            cycleTimer = nil
        }
    }
    
    @objc fileprivate func scrollToNext() {
        // 1.获取滚动的偏移量
        let currentOffsetX = collectionView.contentOffset.x
        let offsetX = currentOffsetX + collectionView.bounds.width
        
        // 2.滚动该位置
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
 
}
