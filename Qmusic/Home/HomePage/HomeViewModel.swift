//
//  HomeViewModel.swift
//  Qmusic
//
//  Created by QuangHo on 21/08/2023.
//

import Foundation
import RxSwift

enum FEHomeError {
    case _403(String)
}

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
}

class HomeViewModel: BaseViewModel {
    struct Input {}
    
    struct Output {
        let error: PublishSubject<FEHomeError>
        let SpotifysChoice:PublishSubject<[HomePage.Items]>
        let charts:PublishSubject<HomePage.Genres>
        let pianoAlbums:PublishSubject<[HomePage.Items]>
        let playlistDetail:PublishSubject<PlaylistDetail>
        let songdetail: PublishSubject<SongDetailModel>
    }
    
    let input: Input
    let output: Output
    
    let errorObserver = PublishSubject<FEHomeError>()
    let SpotifysChoiceObserver = PublishSubject<[HomePage.Items]>()
    let chartsObserver = PublishSubject<HomePage.Genres>()
    let pianoAlbumsObserver = PublishSubject<[HomePage.Items]>()
    let playlistDetailObserver = PublishSubject<PlaylistDetail>()
    let songdetailObserver = PublishSubject<SongDetailModel>()
    
    var songdetail: SongDetailModel?
    let disposeBag = DisposeBag()
    private var spotifysChoice:[HomePage.Items] = []
    private var charts:HomePage.Genres?
    private var pianoAlbums:[HomePage.Items] = []
    private var moodPlaylist:[HomePage.Items] = []
    private var popularnewRelease:[HomePage.Items] = []
    internal var playlistDetail: PlaylistDetail?
    internal var playlistSelected: HomePage.Items?
    
    init() {
        self.input = Input()
        self.output = Output(error: errorObserver,
                             SpotifysChoice: SpotifysChoiceObserver,
                             charts: chartsObserver,
                             pianoAlbums: pianoAlbumsObserver,
                             playlistDetail: playlistDetailObserver,
                             songdetail: songdetailObserver)
    }
    
    func getHomePage() {
        let apiClient = NetworkManager.sharedInstance
        
        apiClient.getHomePage().subscribe(
           onNext: { result in
               //MARK: display in UITableView
               if let genres = result.genres,
               let items = genres.first?.contents?.items
               {
                   self.spotifysChoice = items
                   self.output.SpotifysChoice.onNext(items)
                   
               }
               
               if let genres = result.genres,
                  genres.count > 1
               {
                   self.charts = genres[1]
                   self.output.charts.onNext(genres[1])
                   
                   
               }
               
               if let genres = result.genres,
                  genres.count > 2,
                  let items = genres[2].contents?.items
               {
                   self.pianoAlbums = items
                   self.output.pianoAlbums.onNext(items)
                   
               }
               
               if let popular = result.genres?.filter({$0.id == "NMF-PopularNewReleases"
               }).first,
                  let items = popular.contents?.items {
                   self.popularnewRelease = items
                   
               }
               
               if let popular = result.genres?.filter({$0.id == "mood-home-wrapper"
               }).first,
                  let items = popular.contents?.items {
                   self.moodPlaylist = items
                   
                   
               }
               
//               if let genres = result.genres {
//                   genres.forEach { items in
//                       if let contents = items.contents,
//                          let playlist = contents.items {
//                           playlist.forEach { item in
//                               let playlistSelected = item
//                               let req = Request.Playlist(id: item.id ?? "", type: "popular", name: playlistSelected.name ?? "", description: playlistSelected.description ?? "", trackCount: playlistSelected.trackCount ?? 0, followerCount: 0, cover: playlistSelected.images?.last?.last?.url ?? "", shareurlSpotify: playlistSelected.shareUrl ?? "", shareurlApp: playlistSelected.shareUrl ?? "", likeCount: 0, status: 1)
//
//                               NetworkManager.sharedInstance.addPlaylistToDB(req: req)
//                               do {
//                                   sleep(1)
//                               }
//                           }
//                       }
//                   }
//               }
               
               
           },
           onError: { error in
               print(error.localizedDescription)
           },
           onCompleted: {
               print("Completed event.")
           }).disposed(by: disposeBag)
        
    }
    
    func getPlaylistSeleted() -> HomePage.Items? {
        return self.playlistSelected
    }
    
    func setPlaylistSeleted(item: HomePage.Items) {
        self.playlistSelected = item
    }
    
    func getPlaylistDetail(id: String) {
        let apiClient = NetworkManager.sharedInstance
        
        apiClient.getPlaylistDetail(id: id).subscribe(
           onNext: { result in
               //MARK: display in UITableView
               self.playlistDetail = result
               self.output.playlistDetail.onNext(result)
               
//               result.contents?.items?.forEach({ item in
//
//                   if let artist = item.artists {
//                       artist.forEach { artist in
//                           let reqArtist = Request.Artist(id: artist.id ?? "", verified: 1, name: artist.name ?? "")
//
//                           NetworkManager.sharedInstance.addArtistToDB(req: reqArtist) { result in
//                               switch result {
//
//                               case .success(_):
//                                   let req = Request.Song(id: item.id ?? "",
//                                                          type: "pop", name: item.name ?? "",
//                                                          artistId: item.artists?.first?.id ?? "",
//                                                          durationms: item.durationMs ?? 0,
//                                                          durationText: item.durationText ?? "",
//                                                          albumId: item.album?.id ?? "",
//                                                          url: "",
//                                                          mimeType: "",
//                                                          likeCount: 0,
//                                                          lyricId: "",
//                                                          shareurlApp: item.shareUrl ?? "")
//                                   NetworkManager.sharedInstance.addSongToDB(req: req)
//                                   do {
//                                       sleep(1)
//                                   }
//                               case .failure(let err):
//                                   print(err.localizedDescription)
//                               }
//                           }
//                           do {
//                               sleep(1)
//                           }
//                       }
//                   }
//                   do {
//                       sleep(1)
//                   }
//               })
           },
           onError: { error in
               print(error.localizedDescription)
           },
           onCompleted: {
               print("Completed event.")
           }).disposed(by: disposeBag)
    }
    
    func getSongDetail(id: String) {
        let apiClient = NetworkManager.sharedInstance
        let now = Date()
        
        apiClient.getDetailSong(id: id).subscribe(
           onNext: { result in
               //MARK: display in UITableView
               self.songdetail = result
               self.output.songdetail.onNext(result)
               
           },
           onError: { error in
               print(error.localizedDescription)
           },
           onCompleted: {
               print("Completed event.")
           }).disposed(by: disposeBag)
    }
    //MARK: --getSpotifyItems
    func getSpotifyItems() -> [HomePage.Items] {
        return spotifysChoice
    }
    
    func getChart() -> HomePage.Genres? {
        return charts
    }
    
    func getpianoAlbums() -> [HomePage.Items] {
        return pianoAlbums
    }
    
    func getmoodPlaylist() -> [HomePage.Items] {
        return moodPlaylist
    }
    
    func getpopularNewRelease() -> [HomePage.Items] {
        return popularnewRelease
    }
    
}
