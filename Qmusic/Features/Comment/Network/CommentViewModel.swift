//
//  CommentViewModel.swift
//  Qmusic
//
//  Created by QuangHo on 18/09/2023.
//

import Foundation
import RxSwift
enum CommentErrors {
    case getComment(String)
    case addComment(String)
}
class CommentViewModel: BaseViewModel {
    struct Input {}
    
    struct Output {
        let error: PublishSubject<ArtistViewModelError>
        let getComments:PublishSubject<[CommentModel]>
        let addComment:PublishSubject<Bool>
    }
    
    let input: Input
    let output: Output
    let disposeBag = DisposeBag()
    let errorObserver = PublishSubject<ArtistViewModelError>()
    let getCommentsObserver = PublishSubject<[CommentModel]>()
    let addCommentObserver = PublishSubject<Bool>()
    
    var idSong = ""
    var listComment: [CommentModel] = []
    
    init(id: String) {
        self.input = Input()
        self.output = Output(error: errorObserver,
                             getComments: getCommentsObserver,
                             addComment: addCommentObserver)
        idSong = id
    }
    
    
    func getComments() {
        let apiClient = NetworkManager.sharedInstance
        apiClient.getComment(by: idSong).subscribe(
            onNext: { result in
                //MARK: display in UITable
                self.output.getComments.onNext(result)
                self.listComment.append(contentsOf: result)
                
            },
            onError: { error in
                print(error.localizedDescription)
            },
            onCompleted: {
                print("Completed event.")
            }).disposed(by: disposeBag)
    }
    
    func addCommentSong(comment: String) {
        let apiClient = NetworkManager.sharedInstance
        apiClient.addCommentSong(req: Request.CommentSong(songId: idSong, comment: comment)).subscribe(
            onNext: { result in
                // MARK: -- addComment
                self.output.addComment.onNext(result)
            },
            onError: { error in
                print(error.localizedDescription)
            },
            onCompleted: {
                print("Completed event.")
            }).disposed(by: disposeBag)
    }
    
    func getObject(at index: Int) -> CommentModel{
        return listComment[index]
    }
    
    func getNumberOfObject() -> Int{
        return listComment.count
    }
}
