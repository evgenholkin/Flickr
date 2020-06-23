//
//  DateViewController.swift
//  Flickr
//
//  Created by Евгений Холкин on 13.06.2020.
//  Copyright © 2020 Евгений Холкин. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
//MARK: - Properties
    
    var publishDateInfo = ""
    var takenDateInfo = ""
    var tags = ""
    
//MARK: - Outlets
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tagsListLable: UILabel!
    @IBOutlet weak var separatorTags: UIView!
    @IBOutlet weak var publishingDateLabel: UILabel!
    @IBOutlet weak var takenDateLabel: UILabel!
    @IBOutlet weak var takenDate: UILabel!
    @IBOutlet weak var publishingDate: UILabel!
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
//MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        publishingDate.text = dateDecoder(type: 1, date: publishDateInfo)
        takenDate.text = dateDecoder(type: 2, date: takenDateInfo)
        
        configureLayout()
    }
    
    //MARK: - Methods
    
    private func configureLayout() {
        if tags == "" {
            separatorTags.removeFromSuperview()
            tagsListLable.removeFromSuperview()
        } else {
            tagsListLable.text = "#" + tags.replacingOccurrences(of: " ", with: " #")
        }
    }
    
    private func dateDecoder(type: Int, date: (String)) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: date)!
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "HST")
        let dateString = dateFormatter.string(from: date)
        return dateString
    }

}
