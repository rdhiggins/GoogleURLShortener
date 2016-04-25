//
// GoogleURLShortenerViewController.swift
// MIT License
//
// Copyright (c) 2016 Spazstik Software, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

class GoogleURLShortenerViewController: UIViewController {

    @IBOutlet weak var longURLLabel: UILabel!
    @IBOutlet weak var longURLField: UITextField!
    @IBOutlet weak var shortURLLabel: UILabel!
    @IBOutlet weak var shortURLField: UITextField!
    @IBOutlet weak var shortenURLButton: UIButton!
    @IBOutlet weak var lookupURLButton: UIButton!


    // Properties
    var googleURL: GoogleURL? {
        didSet {
            longURLField.text = googleURL?.longURL
            shortURLField.text = googleURL?.shortURL

            updateButtonStates()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("longText: \(self.longURLField)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    private func updateButtonStates() {

        if let gu = googleURL {
            shortenURLButton.enabled = gu.isLongURLValid ? true : false
            lookupURLButton.enabled = gu.isShortURLValid ? true : false
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func longURLEditingChanged(sender: UITextField) {

        if let n = sender.text {
            if googleURL == nil {
                googleURL = GoogleURL(longURL: n)
            } else {
                googleURL?.longURL = n
            }
        } else {
            if googleURL == nil {
                googleURL = GoogleURL(longURL: "")
            } else {
                googleURL?.longURL = ""
            }
        }

        updateButtonStates()
    }

    @IBAction func shortURLEditingChanged(sender: UITextField) {

        if let n = sender.text {
            if googleURL == nil {
                googleURL = GoogleURL(shortURL: n)
            } else {
                googleURL?.shortURL = n
            }
        } else {
            if googleURL == nil {
                googleURL = GoogleURL(shortURL: "")
            } else {
                googleURL?.shortURL = ""
            }
        }

        updateButtonStates()
    }
    
    @IBAction func shortenURLRequested(sender: AnyObject) {
        if let lu = longURLField.text {
            WebAPI.request(GoogleURLShortenerRouter.Shorten(longURL: lu)) { result in
                dispatch_async(dispatch_get_main_queue()) {
                    switch result {
                    case let .Failure(error):
                        print("Error need to work on this \(error)")
                    case let .Success(data):
                        if let json = WebAPI.parseJSON(data) {
                            if let shortURL = json["id"] as? String {
                                if let longURL = json["longUrl"] as? String {
                                    self.googleURL = GoogleURL(longURL: longURL, shortURL: shortURL)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func lookupURLRequested(sender: AnyObject) {
        if let su = shortURLField.text {
            WebAPI.request(GoogleURLShortenerRouter.Lookup(shortURL: su)) { result in
                dispatch_async(dispatch_get_main_queue()) {
                    switch result {
                    case let .Failure(error):
                        print("Error needs work \(error)")
                    case let .Success(data):
                        if let json = WebAPI.parseJSON(data) {
                            if let shortURL = json["id"] as? String {
                                if let longURL = json["longUrl"] as? String {
                                    self.googleURL = GoogleURL(longURL: longURL, shortURL: shortURL)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
