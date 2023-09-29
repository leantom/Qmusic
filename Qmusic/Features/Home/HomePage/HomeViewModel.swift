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
        let lyricDetail: PublishSubject<[LyricLineModel]>
        let trendingDetail: PublishSubject<Trending_DataResult>
        let chartDetail: PublishSubject<Trending_DataResult>
    }
    
    let input: Input
    let output: Output
    
    let errorObserver = PublishSubject<FEHomeError>()
    let SpotifysChoiceObserver = PublishSubject<[HomePage.Items]>()
    let chartsObserver = PublishSubject<HomePage.Genres>()
    let pianoAlbumsObserver = PublishSubject<[HomePage.Items]>()
    let playlistDetailObserver = PublishSubject<PlaylistDetail>()
    let songdetailObserver = PublishSubject<SongDetailModel>()
    let lyricDetailObserver = PublishSubject<[LyricLineModel]>()
    let trendingDetailObserver = PublishSubject<Trending_DataResult>()
    let chartDetailObserver = PublishSubject<Trending_DataResult>()
    
    var songdetail: SongDetailModel?
    let disposeBag = DisposeBag()
    private var homePageData:[HomePage.Genres] = []
    
    private var spotifysChoice:[HomePage.Items] = []
    private var charts:HomePage.Genres?
    private var pianoAlbums:[HomePage.Items] = []
    private var moodPlaylist:[HomePage.Items] = []
    private var popularnewRelease:[HomePage.Items] = []
    internal var playlistDetail: PlaylistDetail?
    internal var playlistSelected: HomePage.Items?
    internal var topTracksInChart: [TopTracks] = []
    internal var tracksInTrending: [TopTracks] = []
    
    init() {
        self.input = Input()
        self.output = Output(error: errorObserver,
                             SpotifysChoice: SpotifysChoiceObserver,
                             charts: chartsObserver,
                             pianoAlbums: pianoAlbumsObserver,
                             playlistDetail: playlistDetailObserver,
                             songdetail: songdetailObserver,
                             lyricDetail: lyricDetailObserver,
                             trendingDetail: trendingDetailObserver,
                             chartDetail: chartDetailObserver)
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
               
               self.homePageData = result.genres ?? []
               
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
    
    func getLyricDetail(id: String) {
        let apiClient = NetworkManager.sharedInstance
        apiClient.getLyric(id: id) { result in
            switch result {
            case .success(let object):
                DispatchQueue.main.async {
                    let lyrics = MusicHelper.sharedHelper.parseLyrics(lyricsText: object)
                    self.output.lyricDetail.onNext(lyrics)
                }
            case .failure(_):
             print("Err")
            }
        }
    }
    //MARK: --getSpotifyItems
//    func getSpotifyItems() -> [HomePage.Items] {
//        return spotifysChoice
//    }
//
    // MARK: -- chart base on data from spotify
    func getChart() -> HomePage.Genres? {
        return charts
    }
    // MARK: --getChartIntoDBNotSpotify
    func getChartIntoDBNotSpotify() {
        let apiClient = NetworkManager.sharedInstance
        
        apiClient.getChart().subscribe(
            onNext: { result in
                
                self.output.chartByDB.onNext(result)
                self.topTracksInChart.append(contentsOf: result)
            },
            onError: { error in
                print(error.localizedDescription)
            },
            onCompleted: {
                print("Completed event.")
            }).disposed(by: disposeBag)
    }
    
    func getItemsInChart() -> Int {
        return topTracksInChart.count
    }
    
    func getItemChart(by index:  Int) -> TopTracks? {
        if topTracksInChart.count > index {
            return topTracksInChart[index]
        }
        return nil
    }
    
    func getTotalTrackInChart() -> [TopTracks] {
        return topTracksInChart
    }
    
    func getNumberItemsInTrending() -> Int {
        return tracksInTrending.count
    }
    
    func getItemsInTrending() -> [TopTracks] {
        return tracksInTrending
    }
    
    func getItemTrending(by index:  Int) -> TopTracks? {
        if tracksInTrending.count > index {
            return tracksInTrending[index]
        }
        return nil
    }
    
    
    func getItemInGenre(by index: Int) -> [HomePage.Items] {
        if homePageData.count > index {
            return homePageData[index].contents?.items ?? []
        }
        return []
    }
    
    func getTitleSectionByID(by index: Int) -> String {
        if homePageData.count > index {
            return homePageData[index].name ?? ""
        }
        return ""
    }
    
    func getTrending(completion: @escaping () -> Void) {
        let apiClient = NetworkManager.sharedInstance
        apiClient.getTrending { result in
            switch result {
            case .success(let object):
                DispatchQueue.main.async {
                    guard let result = object.result, let data = result.data, let tracks = data.tracks?.items else {
                        print("Err Trending")
                        return
                    }
                    
                    self.tracksInTrending.append(contentsOf: tracks)
                    self.output.trendingDetail.onNext(data)
                }
            case .failure(_):
             print("Err Trending")
            }
            completion()
        }
    }
    
    func getExploreChart(completion: @escaping () -> Void) {
        let apiClient = NetworkManager.sharedInstance
        apiClient.getChart { result in
            switch result {
            case .success(let object):
                DispatchQueue.main.async {
                    guard let result = object.result, let data = result.data else {
                        print("Err Chart")
                        return
                    }
                    self.output.chartDetail.onNext(data)
                }
            case .failure(_):
             print("Err Chart")
            }
            completion()
        }
    }
    
    func getTopics() -> [HotTopic] {
        let pop = HotTopic(image: "pop", name: "Pop")
        let rap = HotTopic(image: "rap", name: "Rap")
        let kpop = HotTopic(image: "kpop", name: "Kpop")
        let dance = HotTopic(image: "dance", name: "Dance")
        let bolero = HotTopic(image: "bolero", name: "Bolero")
        let balad = HotTopic(image: "balad", name: "Balad")
        let acoutic = HotTopic(image: "acoutic", name: "Acoutic")
        
        return [pop, rap, kpop, dance, bolero, balad, acoutic]
    }
}
struct HotTopic {
    let image: String
    let name: String
}
