//
//  VTimer.swift
//  TimerDemo
//
//  Created by vishal on 11/20/17.
//  Copyright © 2017 Brainvire. All rights reserved.
//

import UIKit


protocol VTimerDelegate {
    func timerValue(timer : String)
}

class VTimer : NSObject {
    
    private var ProgrssWidth = CGFloat()
    private var ProgressColor = UIColor()
    private var viewCustom = UIView()
    private var array = [[CGFloat:CGFloat]]()
    private var ProgrssCircleRadius = CGFloat()
    private var time = Double()
    private var OriginalTime = Double()
    private let roundView = UIView()
    private var timer = Timer()
    private var isStart = Bool()
    private var smallCircleRadius = CGFloat()
    
    var delegate : VTimerDelegate?
    
    
    // setup
    convenience init(_ addIntoView:UIView,radius:CGFloat,ProgrssBarWidth:CGFloat,ProgressBarColor:UIColor, smallCircleBorderColor:UIColor,smallCircleBackgroudColor:UIColor,time:Double,smallCircleRadius:CGFloat) {
        self.init()
        ProgrssCircleRadius = radius
        viewCustom = addIntoView
        ProgrssWidth = ProgrssBarWidth
        ProgressColor = ProgressBarColor
        self.smallCircleRadius = smallCircleRadius
        self.time = time
        OriginalTime = time
        array = self.GetCirclePoints(midX: addIntoView.frame.midX, midY: addIntoView.frame.midY, radius: radius)
        makeSmallRoundView(BorderColor: smallCircleBorderColor, backgroundColor: smallCircleBackgroudColor)
    }
    
    //Start And Stop Timer
    func StartStopTimer() {
        if isStart {
            isStart = false
            timer.invalidate()
        }else{
            isStart = true
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.moveSmallCircle), userInfo: nil, repeats: true)
        }
    }
    
    //Make Small Circle
    private func makeSmallRoundView(BorderColor:UIColor,backgroundColor:UIColor) {
        let key = Array(array[0].keys)[0]
        let value = Array(array[0].values)[0]
        
        roundView.frame = CGRect.init(x: key, y: value, width: smallCircleRadius*2, height: smallCircleRadius*2)
        roundView.center = CGPoint.init(x: key, y: value)
        roundView.backgroundColor = backgroundColor
        viewCustom.addSubview(roundView)
        roundView.layer.cornerRadius = roundView.frame.size.width/2
        roundView.layer.borderColor = BorderColor.cgColor
        roundView.layer.borderWidth = 2.0
        roundView.layer.masksToBounds = true
    }
    
    //Move small Circle on Big Circle.
    var k = 6
    var i = 0
    @objc private func moveSmallCircle(){
        if k < 359 {
            let key = Array(array[k].keys)[0]
            let value = Array(array[k].values)[0]
            roundView.center = CGPoint.init(x: key, y: value)
            k += 6
        }else{
            k = 6
            let key = Array(array[359].keys)[0]
            let value = Array(array[359].values)[0]
            roundView.center = CGPoint.init(x: key, y: value)
        }
        
        time = time - 00.01
        if String.init(format: "%.2f", time) == "-0.00"{
            StartStopTimer()
            time = OriginalTime
            self.delegate?.timerValue(timer: "00:00")
        }else{
            self.delegate?.timerValue(timer: String.init(format: "0%.2f", time).replacingOccurrences(of: ".", with: ":"))
        }
    }

    //get circle Point From Here.
    private func GetCirclePoints(midX:CGFloat, midY:CGFloat, radius:CGFloat) -> [[CGFloat:CGFloat]] {
        
        let path2 = UIBezierPath()
        path2.addArc(withCenter: CGPoint.init(x: midX, y: midY), radius: radius, startAngle:0, endAngle:2 * .pi, clockwise: true)
        
        //design path in layer
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.fillColor = UIColor.clear.cgColor
        shapeLayer2.path = path2.cgPath
        shapeLayer2.strokeColor = ProgressColor.cgColor
        shapeLayer2.lineWidth = ProgrssWidth
        viewCustom.layer.addSublayer(shapeLayer2)
        
        var array = [[CGFloat:CGFloat]]()
        var temp090x = [CGFloat:CGFloat]()
        var temp90180x = [CGFloat:CGFloat]()
        var temp180270x = [CGFloat:CGFloat]()
        var temp270360x = [CGFloat:CGFloat]()
        
        for i in 1...360 {
            let xPos = midX + radius * sin(CGFloat(i))
            let yPos =  midY + radius*cos(CGFloat(i))
            
            if  xPos > midX &&  yPos < midY {
                temp090x[xPos] = yPos
            }else if xPos > midX && yPos > midY {
                temp90180x[xPos] = yPos
            }else if xPos < midX && yPos > midY {
                temp180270x[xPos] = yPos
            }else if xPos < midX && yPos < midY {
                temp270360x[xPos] = yPos
            }
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
        return array
    }
    
    
    
    private func BubbleDescSort(array : [CGFloat:CGFloat]) -> [[CGFloat:CGFloat]] {
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
    
    
    private func BubbleAsceSort(array : [CGFloat:CGFloat]) -> [[CGFloat:CGFloat]] {
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
}
