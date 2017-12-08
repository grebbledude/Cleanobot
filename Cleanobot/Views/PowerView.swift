//
//  PowerView.swift
//  Robots
//
//  Created by Pete Bennett on 24/10/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class PowerView: NumberView {
    
    @IBInspectable override var value: Int {
        get {
            return super.value
        }
        set (newValue) {
            if mCurrentValue == C.INITIAL_POWER && newValue < C.INITIAL_POWER {
                self.restartTimer()
            }
            super.value = newValue
            
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "power")
        }
    }
    var mTimerActive = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initPower()
    }


    func initPower() {
        let defaults = UserDefaults.standard
        
        var power = defaults.integer(forKey: "power")
        if power == C.INITIAL_POWER {
            let timestamp = Date().timeIntervalSinceReferenceDate
            defaults.set(timestamp, forKey: "lastConsume")
        } else {
            let oldTimestamp = defaults.double(forKey: "lastConsume")
            let timeDelta = ( Date().timeIntervalSinceReferenceDate - oldTimestamp ) / Double( C.POWER_REGEN * 60 )
            power += Int(timeDelta)
            if power >= C.INITIAL_POWER {
                power = C.INITIAL_POWER
                let timestamp = Date().timeIntervalSinceReferenceDate
                defaults.set(timestamp, forKey: "lastConsume")
            } else {
                let timestamp = oldTimestamp + Double( C.POWER_REGEN * 60 ) * Double(Int(timeDelta) + 1)
                    
                scheduleLoop(at: timestamp)
             
                    
 /*               let when = timestamp + Double( C.POWER_REGEN * 60 )
                DispatchQueue.main.asyncAfter(deadline: DispatchTime(when)) {
                    self.incrementPower()
                } */
            }
            
            
        }
        value = power
    }
    func scheduleLoop (at time: Double) {
        
        let defaults = UserDefaults.standard
        defaults.set(time, forKey: "lastConsume")
 //       let timer = Timer(fire: Date(timeIntervalSinceReferenceDate: time), interval: 1.0, repeats: false,
   //                       block: {(Timer) in self.incrementPower()})
        let timer = Timer(fireAt: Date(timeIntervalSinceReferenceDate: time), interval: 1.0, target: self,
                          selector: #selector(incrementPower), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: .commonModes)
        mTimerActive = true
    }
    @objc func incrementPower() {
        
        if !mTimerActive {  // do Nothing if we have deactivated the timer
            return
        }
        
        let defaults = UserDefaults.standard
        let timestamp = Date().timeIntervalSinceReferenceDate
        defaults.set(timestamp, forKey: "lastConsume")
        value += 1
        defaults.set(value, forKey: "power")
        if value < C.POWER_REGEN {
            scheduleLoop(at: Date().timeIntervalSinceReferenceDate + Double(C.POWER_REGEN) * 60.0)
        }
        
    }
    func restartTimer() {
        let defaults = UserDefaults.standard
        let timestamp = Date().timeIntervalSinceReferenceDate
        defaults.set(timestamp, forKey: "lastConsume")
        scheduleLoop(at: timestamp + Double(C.POWER_REGEN) * 60.0)
    }
    func stopTimer() {
        mTimerActive = false
    }
    func resetTimer() {
        initPower()
    }

}
