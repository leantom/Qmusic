//
//  YoutubeMp3ViewModel.swift
//  Qmusic
//
//  Created by QuangHo on 30/08/2023.
//

import Foundation
import RxSwift
import CoreData

class YoutubeMp3ViewModel: BaseViewModel {
    struct Input {}
    
    struct Output {
        let error: PublishSubject<FEHomeError>
        let searchYoutube:PublishSubject<YoutubeMp3Model>
        
    }
    let input: Input
    let output: Output
    
    let errorObserver =  PublishSubject<FEHomeError>()
    let searchYoutubeObserver = PublishSubject<YoutubeMp3Model>()
    let disposeBag = DisposeBag()
    var youtubeMp3Model: YoutubeMp3Model?
    
    var youtubeLocalData:[YoutubeMp3Model] = []
    
    init() {
        self.input = Input()
        self.output = Output(error: errorObserver,
                             searchYoutube: searchYoutubeObserver)
        getDataYoutubeFromCoreData()
        
    }
    
    func searchYoutube(with url: String) {
        let apiClient = NetworkManager.sharedInstance
        
        apiClient.searchLinkMp3(linkURL: url).subscribe(
            onNext: { result in
                self.youtubeMp3Model = result
                self.youtubeLocalData.append(result)
                self.youtubeLocalData.insert(result, at: 0)
            }).disposed(by: disposeBag)
           
    }
    
    func getDataYoutubeLocal() -> [YoutubeMp3Model] {
        return youtubeLocalData
    }
    
    func getDataYoutubeFromCoreData() {

         let manageContent = appDelegate.persistentContainer.viewContext
         let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: "YoutubeModel")

        do {

            let result = try manageContent.fetch(fetchData)

            for data in result as! [NSManagedObject]{
                if let id = data.value(forKeyPath: "id") as? String,
                   let data = AppSetting.shared.getDataYoutube(id: id) {
                    youtubeLocalData.append(data)
                }
                 print(data.value(forKeyPath: "id") as Any)
                 print(data.value(forKeyPath: "user") as Any)
            }
           
        }catch {
            print("err")
        }
        
    }

    
    
    func getBitrateMax() -> AdaptiveFormats? {
        guard let youtubeMp3Model = self.youtubeMp3Model else {return nil}
        guard let adaptiveFormats = youtubeMp3Model.adaptiveFormats else {return nil}
        
        let formats = adaptiveFormats.filter({
            guard let mimeType = $0.mimeType else {return false}
            return mimeType.contains("audio/mp4")
            
        })
        
        if let bitrate = formats.sorted(by: { item1, item2 in
            guard let bitrate1 = item1.bitrate else {return false}
            guard let bitrate2 = item2.bitrate else {return false}
            return bitrate1 < bitrate2
        }).first {
            return bitrate
        }
        return adaptiveFormats.first
    }
    
    func getThumbnailSmall() -> URL? {
        guard let youtubeMp3Model = self.youtubeMp3Model else {return nil}
        guard let thumbnails = youtubeMp3Model.thumbnail else {return nil}
        return URL(string: thumbnails.first?.url ?? "")
    }
    
}

func getBitrateMax(youtubeMp3Model: YoutubeMp3Model) -> AdaptiveFormats? {
    
    guard let adaptiveFormats = youtubeMp3Model.adaptiveFormats else {return nil}
    
    let formats = adaptiveFormats.filter({
        guard let mimeType = $0.mimeType else {return false}
        return mimeType.contains("audio/mp4")
        
    })
    
    if let bitrate = formats.sorted(by: { item1, item2 in
        guard let bitrate1 = item1.bitrate else {return false}
        guard let bitrate2 = item2.bitrate else {return false}
        return bitrate1 < bitrate2
    }).first {
        return bitrate
    }
    return adaptiveFormats.first
}
