//
//  ViewController.swift
//  stopwatch
//
//  Created by 菅家俊太郎 on 2022/11/23.
//

import UIKit

final class ViewController: UIViewController {
    
    private struct RunningState {
        var elapsedTime: TimeInterval
        let startDate = Date()
        var timer: Timer
    }
    
    private struct PauseState {
        var elapsedTime: TimeInterval
    }
    
    private enum State {
        case idle
        case running(RunningState)
        case pause(PauseState)
        
        
        
        func elapsedTime(now: Date) -> TimeInterval {
            switch self {
            case .idle:
                return 0
            case let .running(state):
                return state.elapsedTime
                    + now.timeIntervalSince(state.startDate)
            case let .pause(state):
                return state.elapsedTime
            }
        }
    }
    
    private var state: State = .idle
    
    
    @IBOutlet private weak var elapsedTimeLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        elapsedTimeLabel.font = UIFont.monospacedDigitSystemFont(
            ofSize: 50,
            weight: .bold
        )
            
        
       
        
        updateUI()
        
    }
    
    private func scheduleRTimer() -> Timer {
        Timer.scheduledTimer(
            withTimeInterval: 1.0 /
                100.0,
            repeats: true,
            block: { [weak self] _ in
                print("blook")
                self?.updateElapsedTimeLabel()
                
            }
        )
       
    }
    
   

    @IBAction func didTapStartButton(_ sender: Any) {
        switch state {
        case .idle:
            state = .running(
                RunningState(
                    elapsedTime: 0,
                    timer: scheduleRTimer()
                )
            )
        case let.running(runningState):
            runningState.timer.invalidate()
            state = .pause(
                PauseState(
                    elapsedTime: runningState.elapsedTime +
                        Date().timeIntervalSince(runningState
                        .startDate)
                )
            )
        case let .pause(pauseState):
            state = .running(
                RunningState(
                    elapsedTime: pauseState.elapsedTime,
                    timer: scheduleRTimer()
                )
            )
        }
        
        updateUI()
    }
    
    @IBAction func didTapResetButton(_ sender: Any) {
        switch state{
        case .idle:
            break
        case let .running(runningState):
            runningState.timer.invalidate()
            state = .idle
        case .pause:
            state = .idle
        }
        updateUI()
    }
    
    private func updateUI() {
        startButton.setTitle(
            {
                switch state {
                case .idle, .pause:
                    return "開始"
                case .running:
                    return "停止"
                }
            }(),
            for: .normal
        )
        updateElapsedTimeLabel()
    }
    
    private func updateElapsedTimeLabel() {
        let elapsedTime = state.elapsedTime(now: Date())
        
        let minute = Int(elapsedTime) / 60
        let second = Int(elapsedTime) % 60
        let centiSecond = Int(elapsedTime * 100) % 100
        
        elapsedTimeLabel.text = String(
            format: "%02d:%02d.%02d",
            minute,
            second,
            centiSecond
        )
    }
}

