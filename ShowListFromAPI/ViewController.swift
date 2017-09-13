//
//  ViewController.swift
//  ShowListFromAPI
//
//  Created by Livnoor Brar on 12/09/17.
//  Copyright © 2017 Livnoor Brar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var avatarTableView: UITableView!
    var actorInfo: [Avatar] = []
    
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
                        let actorImageUrl = actor["avatar_url"] as! String
                        self.actorInfo.append(Avatar(name: actorName, imageURL: actorImageUrl, dateOfCreation: creationTime))
                    }
                    self.avatarTableView.reloadData()
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
        print(actorInfo.count)
        return actorInfo.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMadeCell" , for: indexPath) as! ViewControllerTableViewCell
        
        cell.nameOfAvatar.text = actorInfo[indexPath.row].actorName
        let createdDate = DateFormatter().date(fromSwapiString: actorInfo[indexPath.row].actorCreatedOn)
        let date = DateFormatter.localizedString(from: createdDate!, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
        cell.dateOfCreation.text = date
        
        let networkService = NetworkService(url: URL(string: actorInfo[indexPath.row].actorImage)!)
        networkService.downloadImage { (data) in
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                cell.imageOfAvatar.image = image
            }
            
        }
        
        return(cell)
    }
    
    
}

class Avatar{
    var actorName: String
    var actorImage: String
    var actorCreatedOn: String
    
    init(name: String, imageURL: String, dateOfCreation: String){
        self.actorName = name
        self.actorImage = imageURL
        self.actorCreatedOn = dateOfCreation
    }
}

class NetworkService{
    
    lazy var session = URLSession(configuration: URLSessionConfiguration.default)
    
    let url: URL
    
    init(url: URL){
        self.url = url
    }
    
    func downloadImage(completion: @escaping ((Data) -> Void)) {
        let request = URLRequest(url: self.url)
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error == nil {
                if let data = data {
                    completion(data)
                }
            }else {
                print("error in downloading")
            }
        })
        dataTask.resume()
    }
    
}


extension DateFormatter {
    func date(fromSwapiString dateString: String) -> Date? {
        // SWAPI dates look like: "2014-12-10T16:44:31Z"
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.timeZone = TimeZone(abbreviation: "UTC")
        self.locale = Locale(identifier: "en_US_POSIX")
        return self.date(from: dateString)
    }
}
