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
enum GetLinkError {
    case getLinkYoutube(String)
}
class YoutubeMp3ViewModel: BaseViewModel {
    struct Input {}
    
    struct Output {
        let error: PublishSubject<GetLinkError>
        let searchYoutube:PublishSubject<YoutubeMp3Info>
        let reloadLinkExpireYoutube:PublishSubject<YoutubeDataMP3>
    }
    let input: Input
    let output: Output
    
    let errorObserver =  PublishSubject<GetLinkError>()
    let searchYoutubeObserver = PublishSubject<YoutubeMp3Info>()
    let reloadLinkExpireYoutube = PublishSubject<YoutubeDataMP3>()
    let disposeBag = DisposeBag()
    var youtubeMp3Model: YoutubeMp3Info?
    
    var youtubeLocalData:[YoutubeMp3Info] = []
    
    init() {
        self.input = Input()
        self.output = Output(error: errorObserver,
                             searchYoutube: searchYoutubeObserver,
                             reloadLinkExpireYoutube: reloadLinkExpireYoutube)
        getDataYoutubeFromCoreData()
        
    }
    
    func getExpireTime(link: String) -> Double {
        if let urlComponents =  URLComponents(string: link),
           let queryItems = urlComponents.queryItems {
            if let expired = queryItems.filter({$0.name == "s"}).first {
                return Double(expired.value ?? "0") ?? 0
            }
        }
        return 0
    }
    
    
    func searchYoutube(with url: String) {
        let apiClient = NetworkManager.sharedInstance
        let api1 = apiClient.searchLinkMp3(linkURL: url)
        let api2 = apiClient.searchInfoYoutube(linkURL: url)
        
        Observable.combineLatest(api1, api2) { (result1, result2) in
            return (result1,result2)
        }.subscribe(onNext: { link, info in
            if link.link.isEmpty == false {
                self.youtubeMp3Model = info
                var _info = info
                _info.url = link.link
                _info.duration = link.duration
                _info.expireTimestamp = self.getExpireTime(link: link.link)
                self.youtubeLocalData.insert(_info, at: 0)
                self.youtubeLocalData = self.youtubeLocalData.uniqued(on: \.id!)
                AppSetting.shared.archiveDataYoutube(data: _info, id: _info.id ?? "")
                self.output.searchYoutube.onNext(_info)
            } else {
                self.output.error.onNext(.getLinkYoutube("không thấy bài hát bạn tìm"))
            }
            
            }).disposed(by: disposeBag)
        
        
           
    }
    
    func searchLinkYoutube(with id: String) {
        let apiClient = NetworkManager.sharedInstance
        
        apiClient.searchLinkMp3(by: id).subscribe(
            onNext: { result in
                if result.link.isEmpty == false {
                    // cap nhat lai url trong core data
                    
                    var _info = self.youtubeMp3Model
                    _info?.url = result.link
                    _info?.expireTimestamp = self.getExpireTime(link: result.link)
                    self.saveLinkYoutube(youtubeLink: result, id: id)
                    self.output.reloadLinkExpireYoutube.onNext(result)
                } else {
                    self.output.error.onNext(.getLinkYoutube("không thấy bài hát bạn tìm"))
                }
                
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
                
                let status = data.value(forKey: "status") ?? ""
                let id = data.value(forKey: "id") ?? ""
                let user = data.value(forKey: "user") ?? ""
                let duration = data.value(forKey: "duration")  ?? 0
                let url = data.value(forKey: "url") ?? ""
                let thumb = data.value(forKey: "thumb") ?? ""
                let title = data.value(forKey: "title") ?? ""
                let author = data.value(forKey: "author") ?? ""
                let expire = data.value(forKey: "expireTimestamp") ?? 0
                
                let youtubeData = YoutubeMp3Info(status: status as! String, id: id as! String, title: title as! String, author: author as! String, thumb: thumb as! String, url: url as! String, duration: duration as! Float, expire: expire as! Double)
                youtubeLocalData.append(youtubeData)
                
                 print(data.value(forKeyPath: "id") as Any)
                 print(data.value(forKeyPath: "user") as Any)
            }
            youtubeLocalData = youtubeLocalData.uniqued(on: \.id!)
            youtubeLocalData = youtubeLocalData.filter({$0.url.isEmpty == false})

        }catch {
            print("err")
        }
        
    }
    
    
    func saveLinkYoutube(youtubeLink: YoutubeDataMP3, id: String) {
        do {
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "YoutubeModel")
            fetchRequest.predicate = NSPredicate(format: "id = %@", id)
            
            let result = try? context.fetch(fetchRequest)
            if let item = result?.first as? NSManagedObject {
                item.setValue(youtubeLink.link, forKeyPath: "url")
            }
            try context.save()
        } catch let err{
           print(err)
        }
        
       
    }
    
}

