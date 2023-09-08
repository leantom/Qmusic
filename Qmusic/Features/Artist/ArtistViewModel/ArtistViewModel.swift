//
//  ArtistViewModel.swift
//  Qmusic
//
//  Created by QuangHo on 08/09/2023.
//

import Foundation
import RxSwift

enum ArtistViewModelError {
    case getArtistDetail(String)
}

class ArtistViewModel: BaseViewModel {
    struct Input {}
    
    struct Output {
        let error: PublishSubject<ArtistViewModelError>
        let artisDetail:PublishSubject<ArtistDetailModel>
    }
    
    let input: Input
    let output: Output
    let errorObserver = PublishSubject<ArtistViewModelError>()
    let artisDetailObserver = PublishSubject<ArtistDetailModel>()
    var idArtist: String = ""
    let disposeBag = DisposeBag()
    var topTracks:[TopTracks] = []
    var albums: [ArtistModel.Items] = []
    var artistDetail:ArtistDetailModel?
    
    init(id: String) {
        self.input = Input()
        self.output = Output(error: errorObserver,
                             artisDetail: artisDetailObserver)
        idArtist = id
        getArtistDetail()
    }
    
    func getArtistDetail() {
        let apiClient = NetworkManager.sharedInstance
        apiClient.getArtist(by: idArtist).subscribe(
            onNext: { result in
                //MARK: display in UITableView
                self.artistDetail = result
                self.output.artisDetail.onNext(result)
                if let tracks = result.discography?.topTracks {
                    self.topTracks.append(contentsOf: tracks)
                }
                if let albums = result.discography?.albums,
                   let items = albums.items {
                    self.albums.append(contentsOf: items)
                }
                
            },
            onError: { error in
                print(error.localizedDescription)
            },
            onCompleted: {
                print("Completed event.")
            }).disposed(by: disposeBag)
    }
    
}
