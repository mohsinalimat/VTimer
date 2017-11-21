# VTimer

## Requirements ##

Xcode 8+

Swift 3.0, Swift 4.0

iOS 8+

ARC


### Basic Usage ###

**Initilize the Class with different Properties**
```
let timerClass = VTimer.init(self.view, radius: radius, ProgrssBarWidth: 10.0, ProgressBarColor: .red, smallCircleBorderColor: .yellow, smallCircleBackgroudColor: .blue, time:00.60,smallCircleRadius:10.0)
timerClass.delegate = self
```

**call Toggle function for start and stop timer**
```
timerClass.StartStopTimer()
```

**Write Delegate function for the timer Value**
```
class ViewController: UIViewController,VTimerDelegate

func timerValue(timer: String) {
    print(timer)
}
```

<a href="https://github.com/vishalkalola1/DemoBasic/blob/master/ReadMe.gif"><img src="https://github.com/vishalkalola1/DemoBasic/blob/master/ReadMe.gif" title=""/></a>





