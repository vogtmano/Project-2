//
//  ViewController.swift
//  Project2.2
//
//  Created by Maks Vogtman on 18/07/2022.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionsAsked = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        let scheduleButton = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        let scoreButton = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(showScore))
        navigationItem.rightBarButtonItems = [scheduleButton, scoreButton]
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { granted, error in
            if granted {
                print("Yaay!")
            } else {
                print("D'oh!")
            }
        })
    }
    
    
    @objc func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Time to play!"
        content.body = "Here's your chance to improve your knowledge about world's flags."
        content.categoryIdentifier = "alarm"
        content.sound = .default
        
        var dateComponents = Calendar.current.dateComponents([.weekday, .hour, .minute], from: Date())
        dateComponents.hour = 10
        dateComponents.minute = 45
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let play = UNNotificationAction(identifier: "play", title: "Let's play", options: .foreground)
        
        let category = UNNotificationCategory(identifier: "alarm", actions: [play], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }

    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        button1.transform = .identity
        button2.transform = .identity
        button3.transform = .identity
        
        title = "Pick \(countries[correctAnswer].uppercased())"
    }
    
    
    func playAgain(action: UIAlertAction! = nil) {
        score = 0
        askQuestion()
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title = ""
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.38, initialSpringVelocity: 7, options: [], animations: { [self] in
            switch sender.tag {
            case self.correctAnswer:
                title = "CORRECT!"
                self.score += 1
                self.questionsAsked += 1
                sender.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            default:
                title = "WRONG! That's the flag of \(self.countries[sender.tag].uppercased())"
                self.score -= 1
                self.questionsAsked += 1
                sender.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            }
            
            var ac = UIAlertController(title: title, message: "Your score is \(self.score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            
            if questionsAsked == 10 {
                ac = UIAlertController(title: "THE END", message: "Your final score is \(score)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Play again", style: .default, handler: playAgain))
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            }
            
            present(ac, animated: true)
        })
    }
    
    
    @objc func showScore() {
        let ac = UIAlertController(title: "SCORE", message: "Your current score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
}

