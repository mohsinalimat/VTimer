//
//  ViewController.swift
//  Scrollview_Pagecontroller
//
//  Created by Hiren on 27/10/17.
//  Copyright © 2017 Hiren. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate
{
    @IBOutlet var scrlview : UIScrollView!
    @IBOutlet var pageControl : UIPageControl!
    @IBOutlet var segment : UISegmentedControl!

    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func segmentChange(sender : UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0
        {
            self.view.backgroundColor = UIColor.brown
        }
        else
        {
            self.view.backgroundColor = UIColor.lightGray
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configurePageControl()
        scrlview.delegate = self
        scrlview.isPagingEnabled = true
        
        for index in 0..<4 {
            
            frame.origin.x = self.scrlview.frame.size.width * CGFloat(index)
            frame.size = self.scrlview.frame.size
            
            let subView = UIView(frame: frame)
            subView.backgroundColor = colors[index]
            self.scrlview .addSubview(subView)
        }
        
        self.scrlview.contentSize = CGSize(width:self.scrlview.frame.size.width * 4,height: self.scrlview.frame.size.height)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)

    }
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = colors.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrlview.frame.size.width
        scrlview.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
}
