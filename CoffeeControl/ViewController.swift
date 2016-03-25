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
    
    @IBOutlet weak var timerOnField: UILabel!
    @IBOutlet weak var timerOffField: UILabel!
    
    var sshWrapper = SSHWrapper()
    
    @IBAction func coffeeOn(sender: AnyObject) {
        let sshWrapper = SSHWrapper()
        var error: NSError?
        
        sshWrapper.connectToHost("192.168.0.126", port: 22, user: "pi", password: "raspberry", error: &error)
        
        if error != nil {
            let alertController = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            do {
                try sshWrapper.executeCommand("gpio write 1 1")
            }
            catch {
                
            }
        }
    }

    @IBAction func light1Changed(sender: AnyObject) {
        switch (self.onOffLight1.selectedSegmentIndex) {
        case 0:

                do {
                    try sshWrapper.executeCommand("sudo /usr/bin/python /home/pi/onLight1.py")
                }
                catch {
                    
                }
        case 1:

                do {
                    try sshWrapper.executeCommand("sudo /usr/bin/python /home/pi/offLight1.py")
                }
                catch {
                    
                }
            
            
            
        default:
            break
    }
    
    }
    
    @IBAction func light2Changed(sender: AnyObject) {
        switch (self.onOffLight2.selectedSegmentIndex) {
        case 0:
            
            do {
                try sshWrapper.executeCommand("sudo /usr/bin/python /home/pi/onLight2.py")
            }
            catch {
                
            }
        case 1:
            
            do {
                try sshWrapper.executeCommand("sudo /usr/bin/python /home/pi/offLight2.py")
            }
            catch {
                
            }
            
        default:
            break
        }
    }
    
    @IBAction func coffeeChanged(sender: AnyObject) {
        switch (self.onOffCoffee.selectedSegmentIndex) {
        case 0:
            do{
            try sshWrapper.executeCommand("sudo /usr/bin/python /home/pi/onCoffee.py")
            } catch {
                
            }
        case 1:
            do{
            try sshWrapper.executeCommand("sudo /usr/bin/python /home/pi/offCoffee.py")
            } catch {
                
            }

        default:
            break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Coffee Control"
        
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
        var hour = result.substringWithRange(hourRange)
        var min = result.substringWithRange(minRange)
        let timerOff = hour + "h " + min + "m"
        
        hourRange = result.startIndex.advancedBy(54)..<result.startIndex.advancedBy(56)
        minRange = result.startIndex.advancedBy(51)..<result.startIndex.advancedBy(53)
        hour = result.substringWithRange(hourRange)
        min = result.substringWithRange(minRange)
        let timerOn = hour + "h " + min + "m"
        
        timerOnField.text = timerOn
        timerOffField.text = timerOff
    }
}
