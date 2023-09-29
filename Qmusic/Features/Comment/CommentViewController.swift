//
//  CommentViewController.swift
//  Qmusic
//
//  Created by QuangHo on 14/09/2023.
//

import UIKit
import RxSwift

class CommentViewController: UIViewController {

    @IBOutlet weak var tbContent: UITableView!
    var songDetail: PlaylistModel.ItemsPlaylist?
    let textDefault = "Nhập bình luận của bạn ở đây"
    @IBOutlet weak var tvComment: UITextView!
    
    @IBOutlet weak var bottomKeyboardContraint: NSLayoutConstraint!
    var commentViewModel: CommentViewModel?
    
    
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
        setupRx()
    }

    func setupRx() {
        guard let songDetail = self.songDetail else {return}
        commentViewModel = CommentViewModel(id: songDetail.id ?? "")
        guard let commentViewModel = self.commentViewModel else {return}
        commentViewModel.output.getComments.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                
                self.tbContent.reloadData()
            })
            .disposed(by: commentViewModel.disposeBag)
        // MARK: -- addComment
        commentViewModel.output.addComment.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                
                self.tbContent.reloadData()
            })
            .disposed(by: commentViewModel.disposeBag)
        
        commentViewModel.getComments()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomKeyboardContraint.constant = keyboardSize.height
        }

    }

    @objc func keyboardWillHide(notification: Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
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
        guard let songDetail = self.songDetail else {return}
        guard let commentViewModel = self.commentViewModel else {return}
        if let comment = tvComment.text {
            commentViewModel.addCommentSong(comment: comment)
            self.view.endEditing(true)
            tvComment.text = textDefault
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            commentViewModel.getComments()
        }
    }
}

extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let commentViewModel = self.commentViewModel else {return 0}
        return commentViewModel.getNumberOfObject()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.setupData(comment: (commentViewModel?.getObject(at: indexPath.row))!)
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
