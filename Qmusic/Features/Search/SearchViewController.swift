//
//  SearchViewController.swift
//  Qmusic
//
//  Created by QuangHo on 18/08/2023.
//

import UIKit
import AVFoundation
import RxSwift

class SearchViewController: UIViewController {
    var player: AVPlayer?
    
    @IBOutlet weak var tbContent: UITableView!
    var objectMp3: YoutubeMp3Model?
    @IBOutlet weak var tfSearch: UITextField!

    @IBOutlet weak var musicContainView: UIView!
    let youtubeViewModel = YoutubeMp3ViewModel()
    @IBOutlet weak var heightContraintMusicBarView: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbContent.register(UINib(nibName: "RadioPopularTableViewCell", bundle: nil), forCellReuseIdentifier: "RadioPopularTableViewCell")
        tbContent.delegate = self
        tbContent.dataSource = self
        tfSearch.delegate = self
        tfSearch.attributedPlaceholder = NSAttributedString(
                string: "ex:youtube.com/watch?v=oqf2seMc1fQ",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "9F9F9F")]
            )
        setupRx()
    }

    
    func setupRx() {
        youtubeViewModel.output.searchYoutube.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                self?.tbContent.reloadData()
            })
            .disposed(by: youtubeViewModel.disposeBag)
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.pop()
    }
    

    @IBAction func actionHideKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func showError() {
        let ac = UIAlertController(title: "Xin lỗi", message: "Link bạn tìm kiếm không đúng", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default) { alert in
            
        })
        self.present(ac, animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let inputSearch =  textField.text,
           let _ = URL(string: inputSearch) {
            youtubeViewModel.searchYoutube(with: inputSearch)
        }
    }
    
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return youtubeViewModel.getDataYoutubeLocal().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RadioPopularTableViewCell", for: indexPath) as! RadioPopularTableViewCell
        
        let data = youtubeViewModel.getDataYoutubeLocal()
        
        cell.lblDesc.text = data[indexPath.row].description
        cell.lblTitle.text = data[indexPath.row].title
        if let thumbnail = data[indexPath.row].getThumbnailSmall() {
            cell.thumbnail.setImage(from: thumbnail)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objectMp3 = youtubeViewModel.getBitrateMax(),
           let url = objectMp3.url {
            playMusic(link: url)
        }
    }
    
    func playMusic(link: String) {
        if let youtubeModel = self.youtubeViewModel.youtubeMp3Model {
            MusicHelper.sharedHelper.playMusicWithYoutube(link: link,
                                                          youtubeModel: youtubeModel,
                                                          with: .YoutubeLink)
        }
       
        
        
    }

    
}
