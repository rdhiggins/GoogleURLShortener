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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    fileprivate func updateButtonStates() {

        if let gu = googleURL {
            shortenURLButton.isEnabled = gu.isLongURLValid ? true : false
            lookupURLButton.isEnabled = gu.isShortURLValid ? true : false
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

    @IBAction func longURLEditingChanged(_ sender: UITextField) {

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

    @IBAction func shortURLEditingChanged(_ sender: UITextField) {

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
    
    @IBAction func shortenURLRequested(_ sender: AnyObject) {
        if let lu = longURLField.text {
            GoogleURLShortener.requestShorten(lu) { result in
                switch result {
                case let .success(googleURL):
                    self.googleURL = googleURL
                case .failedParse:
                    self.showGoogleURLShortenerErrorMessage("Could not parse the response from the service!")
                case let .failure(error):
                    self.showGoogleURLShortenerErrorMessage("WebAPI Error \(error)")
                }
            }
        }
    }
    
    @IBAction func lookupURLRequested(_ sender: AnyObject) {
        if let su = shortURLField.text {
            GoogleURLShortener.requestLookup(su) { result in
                switch result {
                case let .success(googleURL):
                    self.googleURL = googleURL
                case .failedParse:
                    self.showGoogleURLShortenerErrorMessage("Could not parse the response from the service!")
                case let .failure(error):
                    self.showGoogleURLShortenerErrorMessage("WebAPI Error \(error)")
                }
            }
        }
    }
    
    fileprivate func showGoogleURLShortenerErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
