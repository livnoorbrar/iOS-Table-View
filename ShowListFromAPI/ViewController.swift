//
//  ViewController.swift
//  ShowListFromAPI
//
//  Created by Livnoor Brar on 12/09/17.
//  Copyright © 2017 Livnoor Brar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseData()
    }
    
    func parseData(){
        
        let url = "https://api.github.com/events"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error as Any)
            }else{
                do{
                    let fetchedData = try JSONSerialization.jsonObject(with: (data)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    
                    for eachFetchedAvatar in fetchedData{
                        let avatar = eachFetchedAvatar as! Dictionary<String, Any>
                        let creationTime = avatar["created_at"] as! String
                        let actor = avatar["actor"] as! Dictionary<String, Any>
                        let actorName = actor["login"] as! String
                        print(actorName)
                    }
                    
                }
                catch{
                }
                
            }
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMadeCell" , for: indexPath) as! ViewControllerTableViewCell
        return(cell)
    }
    
    
}
