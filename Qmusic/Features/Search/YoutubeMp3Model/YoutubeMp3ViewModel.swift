//
//  YoutubeMp3ViewModel.swift
//  Qmusic
//
//  Created by QuangHo on 30/08/2023.
//

import Foundation
import RxSwift
import CoreData
import Algorithms

class YoutubeMp3ViewModel: BaseViewModel {
    struct Input {}
    
    struct Output {
        let error: PublishSubject<FEHomeError>
        let searchYoutube:PublishSubject<YoutubeMp3Info>
        
    }
    let input: Input
    let output: Output
    
    let errorObserver =  PublishSubject<FEHomeError>()
    let searchYoutubeObserver = PublishSubject<YoutubeMp3Info>()
    let disposeBag = DisposeBag()
    var youtubeMp3Model: YoutubeMp3Info?
    
    var youtubeLocalData:[YoutubeMp3Info] = []
    
    init() {
        self.input = Input()
        self.output = Output(error: errorObserver,
                             searchYoutube: searchYoutubeObserver)
        getDataYoutubeFromCoreData()
        
    }
    
    func searchYoutube(with url: String) {
        let apiClient = NetworkManager.sharedInstance
        let api1 = apiClient.searchLinkMp3(linkURL: url)
        let api2 = apiClient.searchInfoYoutube(linkURL: url)
        
        Observable.combineLatest(api1, api2) { (result1, result2) in
            return (result1,result2)
        }.subscribe(onNext: { link, info in
            self.youtubeMp3Model = info
            var _info = info
            _info.url = link.link
            _info.duration = link.duration
            self.youtubeLocalData.insert(_info, at: 0)
            self.youtubeLocalData = self.youtubeLocalData.uniqued(on: \.id!)
            self.output.searchYoutube.onNext(_info)
            }).disposed(by: disposeBag)
        
        
           
    }
    
    func getDataYoutubeLocal() -> [YoutubeMp3Info] {
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
            youtubeLocalData = youtubeLocalData.uniqued(on: \.id!)

        }catch {
            print("err")
        }
        
    }

    
    
   
    
}

