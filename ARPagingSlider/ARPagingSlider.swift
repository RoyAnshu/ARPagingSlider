//
//  ARPagingSlider.swift
//  PagingSlider
//
//  MIT License
/*
Copyright (c) 2019 Anshu Roy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
//  MIT License

Copyright (c) 2019 Anshu Roy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import UIKit

open class ARPagingSlider: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
  public  var pageControl : UIPageControl!
   public var collectionView: UICollectionView!
  public  var dataSourceArray : NSMutableArray!
   public var dataSourceArray_title : NSMutableArray!

  public  var titleLbl: UILabel!

  public typealias CompletionHandler = (_ selectedIndex:NSInteger) -> Void
  public  var ARPagingSliderBlock : CompletionHandler!

    // MARK:- Setup Methods
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        self.collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        self.collectionView.contentInset = .zero
        self.addSubview(self.collectionView)
        self.titleLbl = UILabel.init()
        self.pageControl = UIPageControl.init()
        
        self.pageControl.addTarget(self, action: #selector(self.pageControlValueChanged(_:)), for: .valueChanged)
        self.addSubview(self.pageControl)
        self.addSubview(self.titleLbl)
        self.bringSubviewToFront(self.pageControl)
        self.bringSubviewToFront(self.titleLbl)

        self.collectionView.register(GridCell.self, forCellWithReuseIdentifier: "Slider")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isPagingEnabled = true
        self.collectionView.scrollIndicatorInsets = .zero
        self.dataSourceArray = NSMutableArray.init()
        self.dataSourceArray_title = NSMutableArray.init()
        self.collectionView.showsHorizontalScrollIndicator = false
        self.titleLbl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let width = NSLayoutConstraint(item: self.pageControl!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
        let  bottom_pg = NSLayoutConstraint(item: self.pageControl!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1.0, constant: 10)
        let  height =  NSLayoutConstraint(item: self.pageControl!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant:40)
        let  center = NSLayoutConstraint(item: self.pageControl!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        let top = NSLayoutConstraint(item: self.collectionView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        let  left = NSLayoutConstraint(item: self.collectionView!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        let  right =  NSLayoutConstraint(item: self.collectionView!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        let  bottom = NSLayoutConstraint(item: self.collectionView!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        
        let top_lbl = NSLayoutConstraint(item: self.titleLbl!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 8)
        let  left_lbl = NSLayoutConstraint(item: self.titleLbl!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 8)
        let  right_lbl =  NSLayoutConstraint(item: self.titleLbl!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 8)
        let  height_lbl =  NSLayoutConstraint(item: self.titleLbl!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant:30)

        NSLayoutConstraint.activate([width, bottom_pg, center, height, top, left, right, bottom, top_lbl, left_lbl, right_lbl, height_lbl])
       
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func imageChange() {
        if self.pageControl.currentPage < dataSourceArray.count-1 {
            self.pageControl.currentPage += 1
        }else if self.pageControl.currentPage == dataSourceArray.count-1 {
            self.pageControl.currentPage = 0
        }
        self.collectionView.scrollToItem(at: IndexPath.init(row: self.pageControl.currentPage, section: 0), at: .centeredHorizontally, animated: false)
        self.titleLbl.text = self.dataSourceArray_title.object(at: self.pageControl.currentPage) as? String
    }
    
    @objc func pageControlValueChanged(_ sender:UIPageControl){
        self.collectionView.scrollToItem(at: IndexPath.init(row: sender.currentPage, section: 0), at: .centeredHorizontally, animated: false)
        self.titleLbl.text = self.dataSourceArray_title.object(at: sender.currentPage) as? String
    }
    
    // MARK:- Customize Methods
    
   open func showSlider(array options:NSArray, pageControlTintColor color:UIColor, pageControlSelectedColor selectedColor:UIColor, isAnimated isanimated:Bool, titles titleArray:NSArray?, titleColor titlecolor:UIColor?, titleFont titlefont:UIFont?, titleShadow titleshadow:UIColor?, completionBlockSuccess:@escaping CompletionHandler) -> Void {
        self.ARPagingSliderBlock = completionBlockSuccess
        collectionView.backgroundColor = UIColor.clear
        self.dataSourceArray.addObjects(from: options as! [String])
        self.pageControl.pageIndicatorTintColor = color
        self.pageControl.currentPageIndicatorTintColor = selectedColor
        self.pageControl.numberOfPages = options.count
        
        self.collectionView.reloadData()
        if isanimated {
            Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(imageChange), userInfo: nil, repeats: true)
        }
        if titleArray == nil {
            self.titleLbl.isHidden = true
        }else {
            self.titleLbl.isHidden = false
            self.dataSourceArray_title.addObjects(from: titleArray as! [String])
            self.titleLbl.textColor = titlecolor
            self.titleLbl.font = titlefont
            
            if titleshadow != nil {
            self.titleLbl.layer.shadowColor = titleshadow?.cgColor
            self.titleLbl.layer.shadowRadius = 2.0
            self.titleLbl.layer.shadowOpacity = 1.0
            self.titleLbl.layer.shadowOffset = CGSize(width: 2, height: 2)
            self.titleLbl.layer.masksToBounds = false
            }
        }
    }
    
    @objc func deviceOrientationDidChange(_ notification: Notification) {
        self.collectionView.reloadData()
        self.collectionView.scrollToItem(at:
                IndexPath.init(row: self.pageControl.currentPage, section: 0), at: .centeredHorizontally, animated: false)
        self.titleLbl.text = self.dataSourceArray_title.object(at: self.pageControl.currentPage) as? String
    }
    
    // MARK:- UICollectionViewDelegate & UICollectionViewDataSource Methods
    
   public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width-0.5, height: self.collectionView.frame.size.height-0.5)
    }
    
  public  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }
    
   public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : GridCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Slider", for: indexPath) as! GridCell
        cell.imageView.image = UIImage.init(named: self.dataSourceArray.object(at: indexPath.row) as! String)
        return cell
    }
    
   public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.ARPagingSliderBlock(indexPath.row)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.collectionView.indexPathForItem(at: visiblePoint) {
            self.pageControl.currentPage = visibleIndexPath.row
            self.titleLbl.text = self.dataSourceArray_title.object(at: self.pageControl.currentPage) as? String
        }
    }
}

class GridCell: UICollectionViewCell {
    
    var imageView = UIImageView.init()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1.0, constant: 0)
        let  left = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1.0, constant: 0)
        let  right =  NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1.0, constant: 0)
        let  bottom = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        NSLayoutConstraint.activate([top, left, right, bottom])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
