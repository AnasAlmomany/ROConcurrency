//
//  BarrierComplex.swift
//  RASCOcloud
//
//  Created by Robin Oster on 15/10/14.
//  Copyright (c) 2014 Robin Oster. All rights reserved.
//

import Foundation

public class BarrierComplex {
    
    var tasks:[TaskComplex]
    var afterTask:TaskComplex
    var verbose:Bool
    
    var taskStatus:[String : Bool]
    
    var logger = SynchronizedLogger.sharedInstance
    
    public init(tasks:[TaskComplex], afterTask:TaskComplex, verbose:Bool = false) {
        self.tasks = tasks
        self.afterTask = afterTask
        self.verbose = verbose
        
        // Initialize the taskStatus, mark everyone as false (unfinished)
        self.taskStatus = [String : Bool]()
        
        for task in self.tasks {
            self.taskStatus[task.taskUUID] = false
        }
    }
    
    public func startTasks() -> () {
        
        // Start executing all tasks and monitor their finish status
        for task in self.tasks {
            
            if self.verbose { self.logger.log("Execute Task: \(task.taskUUID)") }
           
            // Execute asynchronously
            task.execute({() -> () in
               
                if self.verbose { self.logger.log("TASK finished: \(task.taskUUID)") }
               
                // Mark task as finished
                self.taskStatus[task.taskUUID] = true
               
                // Check if all tasks are finished
                if self.allTasksFinished() {
                    self.afterTask.execute({() -> () in
                        if self.verbose { self.logger.log("After Tasked finished!") }
                    })
                }
            })
        }
    }
    
    public func allTasksFinished() -> Bool {
        return self.taskStatus.values.array.filter{$0 == false}.count == 0
    }
}