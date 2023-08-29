//
//  HomeViewModel+AddDB.swift
//  Qmusic
//
//  Created by QuangHo on 28/08/2023.
//

import Foundation
extension HomeViewModel {
    func uploadMP3DB() {
        let apiClient = NetworkManager.sharedInstance
        self.playlistDetail?.contents?.items?.forEach({ item in
            // MARK: -- get album
            
            let now = Date()
            guard let idSong = item.id else {return}
            apiClient.getDetailSong(id: idSong).subscribe(
               onNext: { result in
                   //MARK: display in UITableView
                   self.songdetail = result
                   self.output.songdetail.onNext(result)
                   let req = Request.UploadMP3(url: result.soundcloudTrack?.audio?.first?.url ?? "", songID: idSong, songName: result.spotifyTrack?.name ?? "")
                   apiClient.uploadSong(req: req) { result in
                       print(Date().timeIntervalSince1970 - now.timeIntervalSince1970)
                       switch result {
                       case .success(_):
                           print("success")
                       case .failure(_):
                           do {
                               sleep(3)
                           }
                           apiClient.uploadSong(req: req) { result in
                               switch result {

                               case .success(_):
                                   print("success")
                               case .failure(_):
                                   print("failure lan 2")
                                   do {
                                       sleep(3)
                                   }
                                   apiClient.uploadSong(req: req) { result in
                                       switch result {
                                       case .success(_):
                                           print("success")
                                       case .failure(_):
                                           print("failure lan 3")
                                           
                                       }
                                   }
                               }
                           }
                           print("failure lan 1")
                       }
                   }
                   
                   
               },
               onError: { error in
                   print(error.localizedDescription)
               },
               onCompleted: {
                   print("Completed event.")
               }).disposed(by: self.disposeBag)
            
            do {
                sleep(10)
            }
            
        })
    }
}
