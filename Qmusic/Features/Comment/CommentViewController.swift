//
//  CommentViewController.swift
//  Qmusic
//
//  Created by QuangHo on 14/09/2023.
//

import UIKit

class CommentViewController: UIViewController {

    @IBOutlet weak var tbContent: UITableView!
    var songDetail: PlaylistModel.ItemsPlaylist?
    let textDefault = "Nhập bình luận của bạn ở đây"
    @IBOutlet weak var tvComment: UITextView!
    
    @IBOutlet weak var bottomKeyboardContraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbContent.dataSource = self
        tbContent.delegate = self
        
        tbContent.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        
        tbContent.register(UINib(nibName: "HeaderRadioView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderRadioView")
        tvComment.delegate = self
        tvComment.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Do any additional setup after loading the view.
    }

    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomKeyboardContraint.constant = keyboardSize.height
            
        }

    }

    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomKeyboardContraint.constant = 0
        }
    }
    
    
    convenience init(data: PlaylistModel.ItemsPlaylist) {
        self.init(nibName: "CommentViewController", bundle: nil)
        self.songDetail = data
        
    }
    @IBAction func actionClose(_ sender: Any) {
        self.navigationController?.pop()
    }
    
    @IBAction func actionSend(_ sender: Any) {
        if let songDetail = self.songDetail {
            for _ in 1...5 {
                NetworkManager.sharedInstance.getCommentPositiveChatGPT(name: songDetail.artists?.first?.name ?? "" , song: songDetail.name ?? "", songID: songDetail.id ?? "")
                do {
                    sleep(2)
                }
            }
            
            for _ in 1...5 {
                NetworkManager.sharedInstance.getCommentPositiveChatGPT(name: songDetail.artists?.first?.name ?? "" , song: songDetail.name ?? "", songID: songDetail.id ?? "")
                do {
                    sleep(2)
                }
            }
            
        }
        
    }
    
}
extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        cell.selectionStyle = .none
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}
extension CommentViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textDefault {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = textDefault
        }
    }
}
