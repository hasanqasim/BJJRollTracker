//
//  AnimationViewController.swift
//  BJJRollTracker
//
//  Created by Hasan Qasim on 22/9/20.
//  Copyright © 2020 Hasan Qasim. All rights reserved.
//

import UIKit
import AVFoundation

class TimerViewController: UIViewController {
        
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    
    let subview = UIView()
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    var textLayer: CATextLayer?
     
    var timer: Timer?
    var secondsCounter = 60
    var minutesCounter = 0
    var restTime = 0
    var totalRounds = 0
    var roundCounter = 0
    
    var seshStarted = false
    var isRestTime = false
    
    var currentRollSetting: RollSetting?
    
    var strokeEndMultiplier: CGFloat?
    
    var audioPlayerRoundEnd: AVAudioPlayer?
    var audioPlayerRoundStart: AVAudioPlayer?
    var audioPlayerWarning: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        
        setupAudioPlayer()
        createSubview()

        trackLayer.animate(with: UIColor.darkGray.cgColor)
        shapeLayer.animate(with: UIColor.systemRed.cgColor)
        shapeLayer.strokeEnd = 0
        textLayer = createTextLayer(textColor: UIColor.white.cgColor)
        
        positionLayers()
        addLayersToSubview()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settings" {
            let settingsViewController = segue.destination as! SettingsViewController
            settingsViewController.delegate = self
        }
    }
    
    func setupAudioPlayer() {
        let roundEndBeep = Bundle.main.path(forResource: "alarm", ofType: "mp3")
        let roundStartBeep = Bundle.main.path(forResource: "start", ofType: "mp3")
        let warningBeep = Bundle.main.path(forResource: "warning", ofType: "mp3")
        do {
            audioPlayerRoundEnd = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: roundEndBeep!))
            audioPlayerRoundStart = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: roundStartBeep!))
            audioPlayerWarning = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: warningBeep!))
        } catch {
            print(error)
        }
    }
    @IBAction func resetTimer(_ sender: Any) {
        if seshStarted {
            roundCounter -= roundCounter == 0 ? 0 : 1
            resetSettings()
            updateUI()
            print("we inside \(#function)")
        }
    }
}

//MARK: timer logic
extension TimerViewController {
    
    @objc func handleTap() {
        print("attempting to animate stroke")
        if timer == nil {
            if seshStarted {
                startTimer()
            }
        } else {
            print("timer already running")
            stopTimer()
        }
    }
    
    @objc func updateTimer() {
        if minutesCounter == currentRollSetting?.roundTime && secondsCounter == 60 && roundCounter < totalRounds && !isRestTime {
            startNewRound()
        }
        
        secondsCounter = secondsCounter == 0 && minutesCounter != 0 ? 60 : secondsCounter
        minutesCounter -= secondsCounter == 60 ? 1 : 0
        secondsCounter -= 1
        
        if minutesCounter == 0 && secondsCounter == currentRollSetting!.warningTime && !isRestTime {
            audioPlayerWarning?.play()
        }
        
        //textLayer?.string = (secondsCounter >= 10) ? "0\(minutesCounter):\(secondsCounter)": "0\(minutesCounter):0\(secondsCounter)"
        updateTextLayer()
        if let multiplier = strokeEndMultiplier {
            shapeLayer.strokeEnd += (1/75)/multiplier
        }
        
        if minutesCounter == 0 && secondsCounter == 0 {
            if !isRestTime{
                audioPlayerRoundEnd?.play()
                isRestTime = true
            } else {
                isRestTime = false
            }
            //isRestTime = strokeEndMultiplier == CGFloat(currentRollSetting!.roundTime) ? true : false
            stopTimer()
            if roundCounter < totalRounds {
                secondsCounter = 60
                minutesCounter = isRestTime ?  currentRollSetting!.restTime : currentRollSetting!.roundTime
                strokeEndMultiplier = isRestTime ? CGFloat(currentRollSetting!.restTime) : CGFloat(currentRollSetting!.roundTime)
                shapeLayer.strokeEnd = 0
                shapeLayer.strokeColor = isRestTime ? UIColor.blue.cgColor : UIColor.systemRed.cgColor
                startTimer()
            } else {
                seshStarted = false
            }
        }
    }
    
    func updateTextLayer() {
        let minutes = minutesCounter > 9 ? "\(minutesCounter)" : "0\(minutesCounter)"
        let seconds = secondsCounter > 9 ? "\(secondsCounter)": "0\(secondsCounter)"
        textLayer?.string = "\(minutes):\(seconds)"
    }
    
    func startNewRound() {
        audioPlayerRoundStart?.play()
        isRestTime = false
        shapeLayer.strokeEnd = 0
        roundCounter += 1
        roundLabel.text = "\(roundCounter)/\(totalRounds)"
    }
    
    func startTimer() {
        let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        self.timer = timer
        print("timer started")
    }
    
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
            print("in function: \(#function), timer stopped")
        }
    }
}

//MARK: delegate
extension TimerViewController: SettingsViewControllerDelegate {
    
    func didSelectRollSetting(rollSetting: RollSetting) {
        seshStarted = true
        currentRollSetting = rollSetting
        roundCounter = 0
        resetSettings()
        updateUI()
        
        print("we here \(#function)")
    }
}

//MARK: AnimationViewController UI updates
extension TimerViewController {
    
    func createSubview() {
        subview.frame = CGRect(x: 0, y: 0, width: 375, height: 400)
        subview.backgroundColor = .black
        subview.center = view.center
        view.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.widthAnchor.constraint(equalToConstant: 375).isActive = true
        subview.heightAnchor.constraint(equalToConstant: 400).isActive = true
        subview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func createTextLayer(textColor: CGColor) -> CATextLayer {
        let width = view.frame.width
        let height = view.frame.height
        
        let fontSize = min(width, height) / 4
        let offset = min(width, height) * 0.1
        
        let layer = CATextLayer()
        layer.string = "00:00"
        layer.foregroundColor = textColor
        layer.fontSize = fontSize
        layer.frame = CGRect(x: 0, y: (height-fontSize-offset)/2, width: width, height: fontSize + offset)
        layer.alignmentMode = .center
        return layer
    }

    func positionLayers() {
        trackLayer.position = CGPoint(x: subview.bounds.midX, y: subview.bounds.midY)
        shapeLayer.position = CGPoint(x: subview.bounds.midX, y: subview.bounds.midY)
        textLayer!.position = CGPoint(x: subview.bounds.midX, y: subview.bounds.midY)
    }
    
    func addLayersToSubview() {
        subview.layer.addSublayer(trackLayer)
        subview.layer.addSublayer(shapeLayer)
        subview.layer.addSublayer(textLayer!)
    }
    
    func updateUI() {
        shapeLayer.strokeEnd = 0
        shapeLayer.strokeColor = UIColor.systemRed.cgColor
        textLayer?.string = minutesCounter < 10 ? "0\(minutesCounter):00" : "\(minutesCounter):00"
        roundLabel.text = "\(roundCounter)/\(totalRounds)"
    }
    
    func resetSettings() {
        stopTimer()
        isRestTime = false
        minutesCounter = currentRollSetting!.roundTime
        secondsCounter = 60
        restTime = currentRollSetting!.restTime
        totalRounds = currentRollSetting!.numberOfRounds
        strokeEndMultiplier = CGFloat(minutesCounter)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("\(#function)")
        print(UIDevice.current.orientation.isLandscape ? "landscape":"potrait")
        if UIDevice.current.orientation.isLandscape {
            navigationController?.setNavigationBarHidden(true, animated: true)
            buttonOne.isHidden = true
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
            buttonOne.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(#function)")
        if UIDevice.current.orientation.isLandscape {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }

}

// MARK: CAShapeLayer extension
extension CAShapeLayer {
    func animate(with color: CGColor) {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 175, startAngle: -CGFloat.pi/2, endAngle: 2*CGFloat.pi, clockwise: true)
        self.path = circularPath.cgPath
        self.strokeColor = color
        self.lineWidth = 10
        self.lineCap = .round
    }
}




