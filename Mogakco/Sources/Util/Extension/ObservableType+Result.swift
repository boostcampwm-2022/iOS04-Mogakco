//
//  ObservableType+Result.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/30.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import RxSwift

extension ObservableType {
    func asResult() -> Observable<Result<Element, Error>> {
        return self.map { .success($0) }
            .catch { .just(.failure($0)) }
    }
}
