//
//  ViewController.swift
//  CoffeeControl
//
//  Olle

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var onOffLight1: UISegmentedControl!
    @IBOutlet weak var onOffLight2: UISegmentedControl!
    @IBOutlet weak var onOffCoffee: UISegmentedControl!
    @IBOutlet weak var manualControls: UILabel!
    @IBOutlet weak var messageField: UITextView!
    
    @IBOutlet weak var onPicker: UIDatePicker!
    @IBOutlet weak var offPicker: UIDatePicker!
    @IBOutlet weak var timerOnField: UILabel!
    @IBOutlet weak var timerOffField: UILabel!
    
    var sshWrapper = SSHWrapper()
    let alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: UIAlertControllerStyle.Alert)
    
    let spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    @IBAction func updateTimer(sender: AnyObject) {
        
        let seconds = 0.1
        let delay = seconds * Double(NSEC_PER_SEC)
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        self.presentViewController(self.alertController, animated: false, completion: nil)
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            let offLine = self.pickerToString(self.offPicker) + " * * * /usr/bin/python /home/pi/CoffeeControl/offCoffee.py"
            let onLine = self.pickerToString(self.onPicker) + " * * * /usr/bin/python /home/pi/CoffeeControl/onCoffee.py"
            
            print(offLine)
            print(onLine)
            
            do {
                try self.sshWrapper.executeCommand("rm /home/pi/CoffeeControl/cronTemp")
            }
            catch {
            }
            
            do {
                try self.sshWrapper.executeCommand("echo '" + offLine + "' >> /home/pi/CoffeeControl/cronTemp")
            }
            catch {
            }
            
            do {
                try self.sshWrapper.executeCommand("echo '" + onLine + "' >> /home/pi/CoffeeControl/cronTemp")
            }
            catch {
            }
            
            do {
                try self.sshWrapper.executeCommand("sudo crontab /home/pi/CoffeeControl/cronTemp")
            }
            catch {
            }
            
            self.refreshTimer()
            
        })
        
        self.dismissViewControllerAnimated(false, completion: nil)
        
        
    }
    
    @IBAction func light1Changed(sender: AnyObject) {
        
        let seconds = 0.1
        let delay = seconds * Double(NSEC_PER_SEC)
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        self.presentViewController(self.alertController, animated: false, completion: nil)
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            switch (self.onOffLight1.selectedSegmentIndex) {
            case 0:
                
                do {
                    try self.sshWrapper.executeCommand("sudo /usr/bin/python /home/pi/CoffeeControl/onLight1.py")
                }
                catch {
                    
                }
            case 1:
                
                do {
                    try self.sshWrapper.executeCommand("sudo /usr/bin/python /home/pi/CoffeeControl/offLight1.py")
                }
                catch {
                    
                }
                
                
                
            default:
                break
            }
            
        })
        
        self.dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    @IBAction func light2Changed(sender: AnyObject) {
        
        let seconds = 0.1
        let delay = seconds * Double(NSEC_PER_SEC)
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        self.presentViewController(self.alertController, animated: false, completion: nil)
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            switch (self.onOffLight2.selectedSegmentIndex) {
            case 0:
                
                do {
                    try self.sshWrapper.executeCommand("sudo /usr/bin/python /home/pi/CoffeeControl/onLight2.py")
                }
                catch {
                    
                }
            case 1:
                
                do {
                    try self.sshWrapper.executeCommand("sudo /usr/bin/python /home/pi/CoffeeControl/offLight2.py")
                }
                catch {
                    
                }
                
            default:
                break
            }
            
        })
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func coffeeChanged(sender: AnyObject) {
        
        let seconds = 0.1
        let delay = seconds * Double(NSEC_PER_SEC)
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        self.presentViewController(self.alertController, animated: false, completion: nil)
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            switch (self.onOffCoffee.selectedSegmentIndex) {
            case 0:
                do{
                    try self.sshWrapper.executeCommand("sudo /usr/bin/python /home/pi/CoffeeControl/onCoffee.py")
                } catch {
                    
                }
            case 1:
                do{
                    try self.sshWrapper.executeCommand("sudo /usr/bin/python /home/pi/CoffeeControl/offCoffee.py")
                } catch {
                    
                }
                
            default:
                break
            }
            
        })
        
        self.dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Coffee Control"
        
        spinnerIndicator.center = CGPointMake(135.0, 65.5)
        spinnerIndicator.color = UIColor.blackColor()
        spinnerIndicator.startAnimating()
        
        alertController.view.addSubview(spinnerIndicator)
        
        sshWrapper = SSHWrapper()
        var error: NSError?
        
        sshWrapper.connectToHost("192.168.0.126", port: 22, user: "pi", password: "raspberry", error: &error)
        
        if error != nil {
            let alertController = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            refreshTimer()
            refreshPicker()
        }
        
    }
    
    func refreshTimer(){
        var result: String!
        do {
            result = try sshWrapper.executeCommand("sudo crontab -l")
        }
        catch {
            result = "Error"
            
        }
        
        var hourRange = result.startIndex.advancedBy(3)..<result.startIndex.advancedBy(5)
        var minRange = result.startIndex.advancedBy(0)..<result.startIndex.advancedBy(2)
        var hour = result.substringWithRange(hourRange).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var min = result.substringWithRange(minRange).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let timerOff = hour + "h " + min + "m"
        
        hourRange = result.startIndex.advancedBy(67)..<result.startIndex.advancedBy(69)
        minRange = result.startIndex.advancedBy(64)..<result.startIndex.advancedBy(66)
        hour = result.substringWithRange(hourRange).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        min = result.substringWithRange(minRange).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let timerOn = hour + "h " + min + "m"
        
        timerOnField.text = timerOn
        timerOffField.text = timerOff
    }
    
    func refreshPicker(){
        var result: String!
        do {
            result = try sshWrapper.executeCommand("sudo crontab -l")
        }
        catch {
            result = "Error"
            
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        var hourRange = result.startIndex.advancedBy(3)..<result.startIndex.advancedBy(5)
        var minRange = result.startIndex.advancedBy(0)..<result.startIndex.advancedBy(2)
        var hour = result.substringWithRange(hourRange).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var min = result.substringWithRange(minRange).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        offPicker.date = dateFormatter.dateFromString(hour + ":" + min)!
        
        hourRange = result.startIndex.advancedBy(67)..<result.startIndex.advancedBy(69)
        minRange = result.startIndex.advancedBy(64)..<result.startIndex.advancedBy(66)
        hour = result.substringWithRange(hourRange).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        min = result.substringWithRange(minRange).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        onPicker.date = dateFormatter.dateFromString(hour + ":" + min)!
    }
    
    func pickerToString(datePicker:UIDatePicker) -> String
    {
        let date = datePicker.date
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute] , fromDate: date)

        var hour : String!
        var minute : String!
        
        if (components.minute < 10) {
            minute = "0" + String(components.minute)
        } else {
            minute = String(components.minute)
        }
        
        if (components.hour < 10) {
            hour = "0" + String(components.hour)
        } else {
            hour = String(components.hour)
        }
        
        
        
        return minute + " " + hour
    }
}
