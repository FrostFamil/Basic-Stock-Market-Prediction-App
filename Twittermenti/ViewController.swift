//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let tweetCount = 100
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    let swifter = Swifter(consumerKey: "YOUR_API_KEY", consumerSecret: "YOUR_API_SECRET_KEY")

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func predictPressed(_ sender: Any) {
        fetchTweets()
    }
    
    
    func fetchTweets() {
        if let searchText = textField.text {
            
            swifter.searchTweet(using: searchText,  lang: "en", count: tweetCount, tweetMode: .extended) { (results, metadata) in
                
                var tweets = [TweetSentimentClassifierInput]()
                
                for i in 0..<self.tweetCount {
                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
                
                self.makePrediction(tweets: tweets)
                
            } failure: { (error) in
                print("Error during the fetching tweets, \(error)")
            }
        }
    
    }
    
    func makePrediction(tweets: [TweetSentimentClassifierInput]) {
        do {
            let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
            
            var score = 0
            
            for pred in predictions {
                let sentiment = pred.label
                
                if sentiment == "Pos" {
                    score+=1
                }else if sentiment == "Neg" {
                    score-=1
                }
            }
            
            updateUI(score)
            
        }catch {
            print(error)
        }
    }
    
    func updateUI(_ score: Int) {
        
        if score > 20 {
            self.sentimentLabel.text = "😍"
        }else if score > 10 {
            self.sentimentLabel.text = "😀"
        }else if score > 0 {
            self.sentimentLabel.text = "🙂"
        }else if score == 0 {
            self.sentimentLabel.text = "😐"
        }else if score > -10 {
            self.sentimentLabel.text = "😕"
        }else if score > -20 {
            self.sentimentLabel.text = "😡"
        }else {
            self.sentimentLabel.text = "🤮"
        }
    }
}

