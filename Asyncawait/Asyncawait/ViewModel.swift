//
//  ViewModel.swift
//  Asyncawait
//
//  Created by Nivedha Rajendran on 14.10.24.
//
import Combine
import UIKit

final class ViewModel: ObservableObject {
    
    //we cannot do this here, we can only declare variables as async locally
//    async let firstImage = await loadImage(index: 1)
        
    
    private var loadingTask: Task<Void, Never>?
    
//    private let database: Database - in this case Task.detached(priority: .userInitiated) has to be used
    
    //1. How we used completion handler
    
//    func fetchImages(completion: (Result<[UIImage], Error>) -> Void) {
//        // .. perform data request
//    }
    
    //2. How we returned using result type
//    func fetchImages(completion: ([UIImage]?, Error?) -> Void) {
//        // .. perform data request
//    }
    
    
    //Before code
    // 1. Call the method
//    fetchImages { result in
//        // 3. The asynchronous method returns
//        switch result {
//        case .success(let images):
//            print("Fetched \(images.count) images.")
//        case .failure(let error):
//            print("Fetching images failed with error \(error)")
//        }
//    }
    // 2. The calling method exits
    
    
    //After code
    //3.using Async - is modern way
    //This method fetchData to support concurrency, we are declaring this as Main Actor. If we used async throws here-> this would move the error somewhere else
    //MainActor is used when we are returning the result from a method to update in a UI or main thread
    func fetchIData() {
        
        guard loadingTask == nil else { return }
        
        loadingTask = Task {@MainActor in
            do {
                
                //This looks fine and the results will be returned concurrently, but if we want them to run in parallel, declare as async
                let images = try await fetchImages()
                
                let resizedImages = try await resizeImages(images)
                
                
                //using async keyword to run the next two lines in parallel
                
                async let images1 = fetchImages()
                
                async let resizedImages2 = resizeImages(images)
                
                let arrayofImages = try await [images1, resizedImages2]
                //
                
                print("Fetched \(images.count) images.")
            } catch is CancellationError { //  to check if it is handled
                print("Task was canceled.")
            } catch {
                print("Fetching images failed with error \(error)")
            }
            loadingTask = nil
        }
    }
    
    //no need to use throws keyword if we dont have any error type returning, in other words no error handling inside this method
    func fetchImages() async throws -> [UIImage] {
        return []
    }
    
    
    func resizeImages(_ : [UIImage]) async throws -> [UIImage] {
        return []
    }
    
    
    
    //Task Groups
    func taskGroup() async {
        let operations: [SlowDivideOperation] = [
            SlowDivideOperation(name: "operation-0", a: 5, b: 1, sleepDuration: 5),
                SlowDivideOperation(name: "operation-1", a: 14, b: 7, sleepDuration: 1),
                SlowDivideOperation(name: "operation-2", a: 8, b: 2, sleepDuration: 3),
        ]
        let allResults = await withTaskGroup(of: (String, Double).self,
                                             returning: [String: Double].self,
                                             body: { taskGroup in
            
            // Loop through operations array
                for operation in operations {
                    
                    // Add child task to task group
                    taskGroup.addTask {
                        
                        // Execute slow operation
                        let value = await operation.execute()
                        
                        // Return child task result
                        return (operation.name, value)
                    }
                    
                }
            
            // Collect results of all child task in a dictionary
            var childTaskResults = [String: Double]()
            for await result in taskGroup {
                // Set operation name as key and operation result as value
                childTaskResults[result.0] = result.1
            }

            // Task group finish running & return task group result
            return childTaskResults
            
        })
    }
    
    
    func accessingCounter() {
        let counter = Counter()
        // Incrementing the counter asynchronously
        Task {
            await counter.increment()
            let currentValue = await counter.getValue()
            print("Current Counter Value: \(currentValue)")
        }
    }
    
    
    deinit {
        loadingTask?.cancel()
        loadingTask = nil
    }
}


