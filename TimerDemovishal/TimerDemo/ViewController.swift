//
//  ViewController.swift
//  TimerDemo
//
//  Created by Shweta Vani on 08/11/17.
//  Copyright © 2017 Brainvire. All rights reserved.
//

import UIKit
import CoreGraphics
import GoogleMobileAds

class ViewController: UIViewController,GADBannerViewDelegate {

    let view1 = UIView()
    var array = [[CGFloat:CGFloat]]()
    var midX : CGFloat = CGFloat()
    var midY : CGFloat = CGFloat()
    let radius : CGFloat = 120.0
    var timer = Timer()
    var time = 00.60
    
    @IBOutlet var banneriew : GADBannerView!
    @IBOutlet weak var btnStartAndStop: UIButton!
    @IBOutlet weak var lblDisplayTime: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        midX = self.view.frame.midX
        midY = self.view.frame.midY
        // Do any additional setup after loading the view, typically from a nib.
        
        let path2 = UIBezierPath()
        path2.addArc(withCenter: CGPoint.init(x: midX, y: midY), radius: radius, startAngle:0, endAngle:2 * .pi, clockwise: true)
        //design path in layer
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.fillColor = UIColor.clear.cgColor
        shapeLayer2.path = path2.cgPath
        shapeLayer2.strokeColor = UIColor.orange.cgColor
        shapeLayer2.lineWidth = 4.0
        self.view.layer.addSublayer(shapeLayer2)
        
        
        var temp090x = [CGFloat:CGFloat]()
        var temp90180x = [CGFloat:CGFloat]()
        var temp180270x = [CGFloat:CGFloat]()
        var temp270360x = [CGFloat:CGFloat]()
        
        for i in 1...360 {
            let path3 = UIBezierPath()
            path3.move(to: CGPoint.init(x: midX, y: midY))
            path3.addLine(to:CGPoint.init(x: midX + radius * sin(CGFloat(i)), y:midY + radius*cos(CGFloat(i))))
            //design path in layer
            if midX + radius * sin(CGFloat(i)) > midX && midY + radius*cos(CGFloat(i)) < midY {
                temp090x[midX + radius * sin(CGFloat(i))] = midY + radius*cos(CGFloat(i))
            }else if midX + radius * sin(CGFloat(i)) > midX && midY + radius*cos(CGFloat(i)) > midY {
               temp90180x[midX + radius * sin(CGFloat(i))] = midY + radius*cos(CGFloat(i))
            }else if midX + radius * sin(CGFloat(i)) < midX && midY + radius*cos(CGFloat(i)) > midY {
                temp180270x[midX + radius * sin(CGFloat(i))] = midY + radius*cos(CGFloat(i))
            }else if midX + radius * sin(CGFloat(i)) < midX && midY + radius*cos(CGFloat(i)) < midY {
                temp270360x[midX + radius * sin(CGFloat(i))] = midY + radius*cos(CGFloat(i))
            }
            let shapeLayer3 = CAShapeLayer()
            shapeLayer3.path = path3.cgPath
            shapeLayer3.strokeColor = UIColor.clear.cgColor
            shapeLayer3.lineWidth = 1.0
            self.view.layer.addSublayer(shapeLayer3)
        }
        
        let tempSorted090x = BubbleAsceSort(array: temp090x)
        let tempSorted90180x = BubbleDescSort(array: temp90180x)
        let tempSorted180270x = BubbleDescSort(array: temp180270x)
        let tempSorted270360x = BubbleAsceSort(array: temp270360x)

        for item in tempSorted090x {
            array.append(item)
        }
        for item in tempSorted90180x {
            array.append(item)
        }
        for item in tempSorted180270x {
            array.append(item)
        }
        for item in tempSorted270360x {
            array.append(item)
        }
        
        //Google ads bannerview showing in view
        banneriew = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        var rect = banneriew.frame
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            rect.origin.y = self.view.frame.size.height - 90
        }
        else
        {
            rect.origin.y = self.view.frame.size.height - 50
        }
        banneriew.frame = rect
        self.view.addSubview(banneriew)
        print(banneriew)
        banneriew.delegate = self
        
        banneriew.adUnitID = "ca-app-pub-5836937919655468/9394681163"
        banneriew.rootViewController = self
        banneriew.load(GADRequest())
        
    }
    
    
    func BubbleDescSort(array : [CGFloat:CGFloat]) -> [[CGFloat:CGFloat]] {
        var sortedArray = Array(array.keys)
        var sortedvalueArray = Array(array.values)
        var sortedAboveIndex = sortedArray.count-1 // Assume all values are not in order
        repeat {
            var lastSwapIndex = 0
            
            for i in 1...sortedAboveIndex{
                if (sortedArray[i] as AnyObject) as! CGFloat > (sortedArray[i - 1] as AnyObject) as! CGFloat  {
                    sortedArray.swapAt(i, i-1)
                    sortedvalueArray.swapAt(i, i-1)
                    lastSwapIndex = i
                }
            }
            sortedAboveIndex = lastSwapIndex
            
        } while (sortedAboveIndex != 0)
        var index = 0
        var arr = [[CGFloat:CGFloat]]()
        for item in sortedArray {
            var dic = [CGFloat:CGFloat]()
            dic[item] = sortedvalueArray[index]
            arr.append(dic)
            index += 1
        }
        return arr
    }
    
    func BubbleAsceSort(array : [CGFloat:CGFloat]) -> [[CGFloat:CGFloat]] {
        var sortedArray = Array(array.keys)
        var sortedvalueArray = Array(array.values)
        var sortedAboveIndex = sortedArray.count-1 // Assume all values are not in order
        repeat {
            var lastSwapIndex = 0
            
            for i in 1...sortedAboveIndex{
                if (sortedArray[i - 1] as AnyObject) as! CGFloat > (sortedArray[i] as AnyObject) as! CGFloat {
                    sortedArray.swapAt(i, i-1)
                    sortedvalueArray.swapAt(i, i-1)
                    lastSwapIndex = i
                }
            }
            sortedAboveIndex = lastSwapIndex
            
        } while (sortedAboveIndex != 0)
        var index = 0
        var arr = [[CGFloat:CGFloat]]()
        for item in sortedArray {
            var dic = [CGFloat:CGFloat]()
            dic[item] = sortedvalueArray[index]
            arr.append(dic)
            index += 1
        }
        return arr
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lblDisplayTime.text = String.init(format: "0%.2f", time).replacingOccurrences(of: ".", with: ":")
        
        let key = Array(array[0].keys)[0]
        let value = Array(array[0].values)[0]
        
        view1.frame = CGRect.init(x: key, y: value, width: 30, height: 30)
        view1.center = CGPoint.init(x: key, y: value)
        view1.backgroundColor = UIColor.white
        //view1.alpha = 0.3
        self.view.addSubview(view1)
        view1.layer.cornerRadius = view1.frame.size.width/2
        view1.layer.borderColor = UIColor.orange.cgColor
        view1.layer.borderWidth = 2.0
        view1.layer.masksToBounds = true
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.drawAnimation), userInfo: nil, repeats: true)
    }
    var k = 6
    var i = 0
    @objc func drawAnimation(){
        if k < 359 {
                let key = Array(array[k].keys)[0]
                let value = Array(array[k].values)[0]
                view1.frame = CGRect.init(x: key, y: value, width: 30, height: 30)
                view1.center = CGPoint.init(x: key, y: value)
            
            k += 6
        }else{
            k = 6
            let key = Array(array[359].keys)[0]
            let value = Array(array[359].values)[0]
            view1.frame = CGRect.init(x: key, y: value, width: 30, height: 30)
            view1.center = CGPoint.init(x: key, y: value)
        }
        time = time - 00.01
        if String.init(format: "%.2f", time) == "-0.00"{
            timer.invalidate()
            lblDisplayTime.text = "00:00"
            time = 00.60
            btnStartAndStop.tag = 1
            btnStartAndStop.setImage(#imageLiteral(resourceName: "play.png"), for: .normal)
        }else{
            lblDisplayTime.text = String.init(format: "0%.2f", time).replacingOccurrences(of: ".", with: ":")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillDisappear(_ animated: Bool) {
    }
    @IBAction func btnStart(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            timer.invalidate()
            sender.setImage(#imageLiteral(resourceName: "play.png"), for: .normal)
        }else{
            sender.tag = 0
            sender.setImage(#imageLiteral(resourceName: "orangePause.png"), for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.drawAnimation), userInfo: nil, repeats: true)
        }
    }
    
    
    //MARK:- GoogleAdMobs delegate methods
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        view.addSubview(bannerView)
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}

