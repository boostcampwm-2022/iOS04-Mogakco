//
//  UIVIew+RxSkeleton.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/12/08.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

extension UIView {
    func addSkeleton() {
        if self is UIImageView || self is ChatRoomUsersImageView {
            fillView(loadingView: SkeletonView(frame: frame, type: .image))
        } else if self is RectLoadingListContentsView {
            fillView(loadingView: SkeletonView(frame: frame, type: .rectList))
        } else if self is ChatRoomListContentsView {
            fillView(loadingView: SkeletonView(frame: frame, type: .chatList))
        } else {
            fillView(loadingView: SkeletonView(frame: frame, type: .none))
        }
    }
    
    func removeSkeleton() {
        self.subviews.forEach {
            if $0 is SkeletonView { $0.removeFromSuperview() }
        }
    }
    
    private func fillView(loadingView: UIView) {
        addSubview(loadingView)
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension Reactive where Base: UIView {
    var skeleton: Binder<Bool> {
        return Binder(base) { base, isLoading in
            if isLoading {
                base.addSkeleton()
            } else {
                base.removeSkeleton()
            }
        }
    }
}
