import Cocoa
import CreateML

//actual place of data
//let urlData = "/Users/familsamadli/Library/Mobile\ Documents/com\~apple\~CloudDocs/Desktop/Twittermenti-iOS13/twitter-sanders-apple3.csv"

let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/familsamadli/Desktop/twitter-sanders-apple3.csv"))

//split data for training(80%) and testing(20%)
//seed saves data random splitting and we can use it to split other datas just like this using seed
let(trainingData, testingData) = data.randomSplit(by: 0.8, seed: 5)

let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")

let evaluationMetrics = sentimentClassifier.evaluation(on: testingData, textColumn: "text", labelColumn: "class")

let evaluationAccuracy = (1.0 - evaluationMetrics.classificationError) * 100

//create metaData and save data
let metaData = MLModelMetadata(author: "Famil Samadli", shortDescription: "A model trained to sentiment on Tweets", version: "1.0")

try sentimentClassifier.write(to: URL(fileURLWithPath: "/Users/familsamadli/Desktop/TweetSentimentClassifier.mlmodel"))

//testing saved classifier
try sentimentClassifier.prediction(from: "@Apple is terrible company")
try sentimentClassifier.prediction(from: "@CocaCola is very good company")
try sentimentClassifier.prediction(from: "I have just saw best girl and she works @Apple")
