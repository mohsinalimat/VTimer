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

class ViewController: UIViewController,GADBannerViewDelegate,VTimerDelegate {

    let radius : CGFloat = 120.0
    
    @IBOutlet var banneriew : GADBannerView!
    @IBOutlet weak var btnStartAndStop: UIButton!
    @IBOutlet weak var lblDisplayTime: UILabel!
    
    var timerClass = VTimer()
    //MARK: TimerDemo Usage
    override func viewDidLoad() {
        super.viewDidLoad()
        timerClass = VTimer.init(self.view, radius: radius, ProgrssBarWidth: 10.0, ProgressBarColor: .red, smallCircleBorderColor: .yellow, smallCircleBackgroudColor: .blue, time:00.60,smallCircleRadius:10.0)
        timerClass.delegate = self
    }
    
    func timerValue(timer: String) {
        lblDisplayTime.text = timer
        if timer == "00:00" {
            btnStartAndStop.setImage(#imageLiteral(resourceName: "play.png"), for: .normal)
            btnStartAndStop.tag = 1
        }
    }
    
    @IBAction func btnStart(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            sender.setImage(#imageLiteral(resourceName: "play.png"), for: .normal)
        }else{
            sender.tag = 0
            sender.setImage(#imageLiteral(resourceName: "orangePause.png"), for: .normal)
        }
        timerClass.StartStopTimer()
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showAds()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- GoogleAdMobs
    func showAds() {
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
        banneriew.delegate = self
        banneriew.adUnitID = "ca-app-pub-5836937919655468/9394681163"
        banneriew.rootViewController = self
        banneriew.load(GADRequest())
        self.view.addSubview(banneriew)
    }
    
    
    //MARK:- GoogleAdMobs delegate methods
    // Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        view.addSubview(bannerView)
    }
    
    // Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
}

