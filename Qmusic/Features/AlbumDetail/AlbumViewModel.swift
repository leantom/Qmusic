//
//  AlbumViewModel.swift
//  Qmusic
//
//  Created by QuangHo on 02/09/2023.
//

import Foundation
import RxSwift
enum AlbumError {
    case getError(String)
}
class AlbumViewModel: BaseViewModel {
    struct Input {}
    
    struct Output {
        let error: PublishSubject<AlbumError>
        let getAlbumDetail:PublishSubject<AlbumDetail> // get thong tin track trong album
        let getAlbumMetadata:PublishSubject<AlbumMetadata> // get thong tin chung album
    }
    let input: Input
    let output: Output
    
    let errorObserver =  PublishSubject<AlbumError>()
    let getAlbumDetailObserver = PublishSubject<AlbumDetail>()
    let getAlbumMetadataObserver = PublishSubject<AlbumMetadata>()
    
    let disposeBag = DisposeBag()
    
    init() {
        
        self.input = Input()
        self.output = Output(error: errorObserver,
                             getAlbumDetail: getAlbumDetailObserver,
                             getAlbumMetadata: getAlbumMetadataObserver)
    }
    
    func getAlbum(by id : String) {
        let apiClient = NetworkManager.sharedInstance
        let api1 = apiClient.getAlbumMetadataByID(id: id)
        let api2 = apiClient.getAlbumByID(id: id)
        
        
        Observable.combineLatest(api1, api2) { (result1, result2) in
            return (result1, result2)
        }.subscribe { metadata, result in
            if let _ =  result.tracks {
                self.output.getAlbumDetail.onNext(result)
            } else {
                self.output.error.onNext(.getError("Album không có trong hệ thống của chúng tôi"))
            }
            
            self.output.getAlbumMetadata.onNext(metadata)
            
        }.disposed(by: disposeBag)
        
    }
    
}
