//
//  QuotesViewController.swift
//  Pensamentos
//
//  Created by Douglas Hennrich on 03/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import UIKit

class QuotesViewController: UIViewController {

    // MARK: Properties
    let quotesManager: QuotesManager = QuotesManager()
    let config = Configuration.shared
    var timer: Timer?
    
    // MARK: IBOutlets
    @IBOutlet weak var photoBackgroundImageView: UIImageView!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var quotesLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default
            .addObserver(forName: NSNotification.Name(rawValue: "Refresh"),
                         object: nil,
                         queue: nil) { [weak self] _ in
                            self?.formatView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        prepareQuote()
    }
    
    // MARK: Actions
    func formatView() {
        view.backgroundColor = config.colorScheme == 0 ? .white : UIColor(red: 156/255,
                                                                          green: 68/255,
                                                                          blue: 15/255,
                                                                          alpha: 1)
        quotesLabel.textColor = config.colorScheme == 0 ? .black : .white
        authorLabel.textColor = config.colorScheme == 0 ? UIColor(red: 192/255,
                                                                  green: 96/255,
                                                                  blue: 49/255,
                                                                  alpha: 1) : .yellow
        prepareQuote()
    }
    
    func prepareQuote() {
        timer?.invalidate()
        
        if config.autorefresh {
            timer = Timer.scheduledTimer(withTimeInterval: config.timeInterval,
                                         repeats: true,
                                         block: { [weak self] timer in
                                            self?.showRandomQuote()
            })
        }
        
        showRandomQuote()
    }
    
    func showRandomQuote() {
        let quote = quotesManager.getRandomQuote()
        quotesLabel.text = quote.quoteFormatted
        authorLabel.text = quote.authorFormatted
        photoImageView.image = UIImage(named: quote.image)
        photoBackgroundImageView.image = photoImageView.image
        
        quotesLabel.alpha = 0
        authorLabel.alpha = 0
        photoImageView.alpha = 0
        photoBackgroundImageView.alpha = 0
        topConstraint.constant = 50
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 2.5) { [weak self] in
            self?.quotesLabel.alpha = 1
            self?.authorLabel.alpha = 1
            self?.photoImageView.alpha = 1
            self?.photoBackgroundImageView.alpha = 0.25
            self?.topConstraint.constant = 10
            self?.view.layoutIfNeeded()
        }
    }
    
}
