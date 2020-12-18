import Foundation
import RxSwift

print("\n\n\n===== Schedulers =====\n")

let globalScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
let bag = DisposeBag()
let animal = BehaviorSubject(value: "[dog]")

animal
  .subscribeOn(MainScheduler.instance)
  .dump()
  .observeOn(globalScheduler)
  .dumpingSubscription()
  .disposed(by: bag)

let fruit = Observable<String>.create { observer in
  observer.onNext("[apple]")
  sleep(2)
  observer.onNext("[pineapple]")
  sleep(2)
  observer.onNext("[strawberry]")
  return Disposables.create()
}

fruit
  .dump()
  .observeOn(globalScheduler)
  .dumpingSubscription()
  .disposed(by: bag)

let animalsThread = Thread() {
  sleep(3)
  animal.onNext("[cat]")
  sleep(3)
  animal.onNext("[tiger]")
  sleep(3)
  animal.onNext("[fox]")
  sleep(3)
  animal.onNext("[leopard]")
}

animalsThread.name = "animals thread"
animalsThread.start()


RunLoop.main.run(until: Date(timeIntervalSinceNow: 13))
