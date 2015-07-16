//
//  ViewController.swift
//  ROConcurrency
//
//  Created by Robin Oster on 16/07/15.
//  Copyright (c) 2015 Rascor International AG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var logger = SynchronizedLogger.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        // Run all examples
        barrierExample()
        barrierComplexExample()
    }
    
    func barrierExample() {
        var task_one = Task {
            sleep(3)
            self.logger.log("Task one is doing some stuff..")
        }
        
        var task_two = Task {
            self.logger.log("Task two is doing some stuff..")
        }
        
        var task_third = Task {
            self.logger.log("Task three is doing some stuff..")
        }
        
        var afterTask = Task {
            self.logger.log("I should get executed at the end of all the other requests")
        }
        
        var barrier = Barrier(tasks: [task_one, task_two, task_third], afterTask:afterTask)
        barrier.startTasks()
    }
    
    func barrierComplexExample() {
        var taskDownload = TaskComplex { (finished) -> () in
            // Do something asynchronously and then at the end call the finished block to notify the barrier that it's finished
            finished()
        }
        
        var taskCompress = TaskComplex { (finished) -> () in
            // Do something else
            finished()
        }
        
        var notifiyEveryoneAtTheEnd = TaskComplex { (finished) -> () in
            // Notify everyone
            finished()
        }
        
        var barrierComplex = BarrierComplex(tasks: [taskDownload, taskCompress], afterTask: notifiyEveryoneAtTheEnd, verbose: true)
        
        barrierComplex.startTasks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

