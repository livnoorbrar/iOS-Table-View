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
        self.title = "My Training App"
        avatarTableView.estimatedRowHeight = 80.0
        avatarTableView.rowHeight = UITableViewAutomaticDimension
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
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print(actorInfo.count)
        return actorInfo.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMadeCell" , for: indexPath) as! ViewControllerTableViewCell
        
//        cell.nameOfAvatar.text = actorInfo[indexPath.row].actorName
        cell.nameOfAvatar.text = " 'Hello' is a song by English singer Adele, released on 23 October 2015 by XL Recordings as the lead single from her third studio album, 25 (2015). Adele co-wrote the song with her producer, Greg Kurstin. 'Hello' is a piano ballad with soul influences, and lyrics that discuss themes of nostalgia and regret."
        let createdDate = DateFormatter().date(fromSwapiString: actorInfo[indexPath.row].actorCreatedOn)
        let date = DateFormatter.localizedString(from: createdDate!, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
        cell.dateOfCreation.text = date

        downloadImage (url: actorInfo[indexPath.row].actorImage,completion: { (data) in
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                cell.imageOfAvatar.image = image
            }
            
        })
        
        return(cell)
    }
    
    
    func downloadImage(url: String, completion: @escaping ((Data) -> Void)) {
        let urlToLoadFrom = URL(string: url)
        let request = URLRequest(url: urlToLoadFrom!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
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
    
    var indexSelected = 0
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destiantionVC = storyboard.instantiateViewController(withIdentifier: "DetailsOfAvatar") as? DetailedViewController {
            let selectedCell = avatarTableView.cellForRow(at: indexPath) as? ViewControllerTableViewCell
            destiantionVC.avatarImage = selectedCell?.imageOfAvatar.image
            destiantionVC.avatarName = (selectedCell?.nameOfAvatar.text)!
            self.navigationController?.pushViewController(destiantionVC, animated: true)
        }
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

extension DateFormatter {
    func date(fromSwapiString dateString: String) -> Date? {
        // SWAPI dates look like: "2014-12-10T16:44:31Z"
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.timeZone = TimeZone(abbreviation: "UTC")
        self.locale = Locale(identifier: "en_US_POSIX")
        return self.date(from: dateString)
    }
}
