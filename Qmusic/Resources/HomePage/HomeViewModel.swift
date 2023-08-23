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
    private var playlistDetail: PlaylistDetail?
    private var playlistSelected: HomePage.Items?
    
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
               
           },
           onError: { error in
               print(error.localizedDescription)
           },
           onCompleted: {
               print("Completed event.")
           }).disposed(by: disposeBag)
        
    }
    
    func getPlaylistSeleted() -> HomePage.Items? {
        return playlistSelected
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
