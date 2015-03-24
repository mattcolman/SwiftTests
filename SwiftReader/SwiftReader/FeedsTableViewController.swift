//
//  FeedsTableViewController.swift
//  SwiftReader
//
//  Created by Matt Colman on 17/03/2015.
//  Copyright (c) 2015 Matt Colman. All rights reserved.
//

import UIKit

class FeedsTableViewController: UITableViewController, NSXMLParserDelegate {
    
    var parser: NSXMLParser = NSXMLParser()
    var feedUrl: String = String()
    
    var feedTitle: String = String()
    var articleTitle: String = String()
    var articleLink: String = String()
    var articlePubDate: String = String()
    var parsingChannel: Bool = false
    var eName: String = String()
    
    var feeds: [FeedModel] = []
    var articles: [ArticleModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AddNewFeed("https://developer.apple.com/news/rss/news.rss")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func AddNewFeed(url: String) {
        feedUrl = url
        let url: NSURL = NSURL(string: feedUrl)!
        
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.parse()
    }
    
    @IBAction func retrieveNewFeed(segue: UIStoryboardSegue) {
        
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        eName = elementName
        if elementName == "channel" {
            feedTitle = String()
            feedUrl = String()
            articles = []
            parsingChannel = true
        } else if elementName == "item" {
            articleTitle = String()
            articleLink = String()
            articlePubDate = String()
            parsingChannel = false
        }
        
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if (!data.isEmpty) {
            if parsingChannel {
                if eName == "title" {
                    feedTitle += data
                }
            } else {
                if eName == "title" {
                    articleTitle += data
                } else if eName == "link" {
                    articleLink += data
                } else if eName == "pubDate" {
                    articlePubDate += data
                }
            }
        }
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        
        if elementName == "channel" {
            let feed: FeedModel = FeedModel()
            feed.title = feedTitle
            feed.url = feedUrl
            feed.articles = articles
            feeds.append(feed)
        } else if elementName == "item" {
            let article: ArticleModel = ArticleModel()
            article.title = articleTitle
            article.link = articleLink
            article.pubDate = articlePubDate
            articles.append(article)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return feeds.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell", forIndexPath: indexPath) as UITableViewCell

        let feed: FeedModel = feeds[indexPath.row]
        cell.textLabel!.text = feed.title

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowArticles") {
            let viewController: ArticlesViewController = segue.destinationViewController as ArticlesViewController
            let indexPath = self.tableView.indexPathForSelectedRow()!
            let feed = feeds[indexPath.row]
            
            viewController.articles = feed.articles
        }
    }

}
